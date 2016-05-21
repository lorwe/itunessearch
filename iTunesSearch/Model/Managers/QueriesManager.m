//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "QueriesManager.h"
#import "SearchQuery.h"
#import "Manager.h"


@implementation QueriesManager

- (SearchQuery *)lastQuery {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchQuery"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryDate" ascending:NO]];
	request.fetchLimit = 1;

	NSArray *result = [[[Manager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
	if (result) {
		return result.firstObject;
	}

	return nil;
}

- (SearchQuery *)queryWithTerm:(NSString *)term {
	if (!term) {
		return nil;
	}

	// check if query with such term already exists
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchQuery"];
	request.predicate = [NSPredicate predicateWithFormat:@"term = %@", term];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryDate" ascending:NO]];
	request.fetchLimit = 1;

	NSArray *result = [[[Manager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
	if (result.count > 0) {
		return result.firstObject;
	}

	SearchQuery *searchQuery = [[SearchQuery alloc] initWithEntity:[NSEntityDescription entityForName:@"SearchQuery" inManagedObjectContext:[[Manager sharedManager] managedObjectContext]]
									insertIntoManagedObjectContext:[[Manager sharedManager] managedObjectContext]];
	searchQuery.term = term;

	[[Manager sharedManager] saveContext];

	return searchQuery;
}

- (NSArray *)recentQueriesWithTerm:(NSString *)term {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchQuery"];
	if (term.length > 0) {
		request.predicate = [NSPredicate predicateWithFormat:@"term CONTAINS[cd] %@", term];
	}
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryDate" ascending:NO]];
	return [[[Manager sharedManager] managedObjectContext] executeFetchRequest:request error:nil];
}

@end
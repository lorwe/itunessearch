//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSSearchTrackInteractor.h"
#import "ITSITunesSearchService.h"
#import "ITSSearchTrackInteractorOutput.h"
#import "ITSTrackObject.h"
#import "ITSSearchQueryObject.h"


@interface ITSSearchTrackInteractor () <NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


@implementation ITSSearchTrackInteractor

#pragma mark - InteractorInput

- (ITSSearchQueryObject *)addQueryWithTerm:(NSString *)term {
	SearchQuery *searchQuery = [self.searchService addQueryWithTerm:term];
	return [[ITSSearchQueryObject alloc] initWithEntity:searchQuery];
}

- (NSArray<ITSSearchQueryObject *> *)getRecentQueriesWithTerm:(NSString *)term {
	NSArray *recentQueries = [self.searchService getRecentQueriesWithTerm:term];
	NSMutableArray *result = [NSMutableArray array];

	for (SearchQuery *query in recentQueries) {
		[result addObject:[[ITSSearchQueryObject alloc] initWithEntity:query]];
	}

	return result;
}

- (NSArray<ITSTrackObject *> *)searchQuery:(ITSSearchQueryObject *)searchQuery {
	SearchQuery *query = [self.searchService getQueryWithTerm:searchQuery.term];
	if (!query) {
		self.fetchedResultsController = nil;
		return @[];
	}

	self.fetchedResultsController = [self.searchService fetchedResultsControllerWithQuery:query delegate:self];

	NSMutableArray *result = [NSMutableArray array];
	for (id <NSFetchRequestResult> entity in self.fetchedResultsController.fetchedObjects) {
		[result addObject:[[ITSTrackObject alloc] initWithEntity:(id) entity]];
	}

	[self.searchService searchTrackWithQuery:query];

	return result;
}

- (ITSTrackObject *)trackObjectAtIndex:(NSUInteger)index {
	ITunesEntity *entity = (id) self.fetchedResultsController.fetchedObjects[index];
	return [[ITSTrackObject alloc] initWithEntity:entity];
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.output willChangeContent];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.output didInsertTrack:[[ITSTrackObject alloc] initWithEntity:anObject]
								atIndex:(NSUInteger) newIndexPath.row];
			break;

		case NSFetchedResultsChangeDelete:
			[self.output didDeleteTrackAtIndex:(NSUInteger) indexPath.row];
			break;

		case NSFetchedResultsChangeMove:
			break;

		case NSFetchedResultsChangeUpdate:
			[self.output didUpdateTrack:[[ITSTrackObject alloc] initWithEntity:anObject]
								atIndex:(NSUInteger) indexPath.row];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.output didChangeContent];
}

@end
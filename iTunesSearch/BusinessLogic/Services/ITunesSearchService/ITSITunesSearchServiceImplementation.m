//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSITunesSearchServiceImplementation.h"
#import "ITSCoreDataStore.h"
#import "ITSNetworking.h"
#import "SearchQuery.h"
#import "ITSTrackSearchOperation.h"
#import "ITunesEntity.h"


@interface ITSITunesSearchServiceImplementation () <ITSTrackSearchOperationDelegate>

@property(nonatomic, strong) NSOperationQueue *operationQueue;

@end


@implementation ITSITunesSearchServiceImplementation

@synthesize networkClient = _networkClient, store = _store;

- (instancetype)initWithNetworkClient:(id <ITSNetworking>)networkClient store:(ITSCoreDataStore *)store {
	self = [super init];
	if (self) {
		_networkClient = networkClient;
		_store = store;

		self.operationQueue = [[NSOperationQueue alloc] init];
	}

	return self;
}


#pragma mark - Search Queries

- (SearchQuery *)getLastQuery {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchQuery"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryDate" ascending:NO]];
	request.fetchLimit = 1;

	NSArray *result = [self.store.managedObjectContext executeFetchRequest:request error:nil];
	if (result) {
		return result.firstObject;
	}

	return nil;
}

- (SearchQuery *)addQueryWithTerm:(NSString *)term {
	if (!term) {
		return nil;
	}

	// check if query with such term already exists
	SearchQuery *searchQuery = [self getQueryWithTerm:term];

	if (searchQuery == nil) {
		searchQuery = [[SearchQuery alloc] initWithEntity:[NSEntityDescription entityForName:@"SearchQuery" inManagedObjectContext:self.store.managedObjectContext]
						   insertIntoManagedObjectContext:self.store.managedObjectContext];
		searchQuery.term = term;

		[self.store saveContext];
	}

	return searchQuery;
}

- (SearchQuery *)getQueryWithTerm:(NSString *)term {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchQuery"];
	request.predicate = [NSPredicate predicateWithFormat:@"term = %@", term];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryDate" ascending:NO]];
	request.fetchLimit = 1;

	NSArray *result = [self.store.managedObjectContext executeFetchRequest:request error:nil];
	if (result.count > 0) {
		return result.firstObject;
	}

	return nil;
}

- (NSArray *)getRecentQueriesWithTerm:(NSString *)term {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchQuery"];
	if (term.length > 0) {
		request.predicate = [NSPredicate predicateWithFormat:@"term CONTAINS[cd] %@", term];
	}
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"queryDate" ascending:NO]];

	return [self.store.managedObjectContext executeFetchRequest:request error:nil];
}


#pragma mark - Tracks

- (NSFetchedResultsController *)fetchedResultsControllerWithQuery:(SearchQuery *)searchQuery delegate:(id <NSFetchedResultsControllerDelegate>)delegate {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ITunesEntity"];
	request.predicate = [NSPredicate predicateWithFormat:@"searchQueries CONTAINS %@", searchQuery];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"trackName" ascending:YES]];
	request.fetchBatchSize = 50;

	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																							   managedObjectContext:self.store.managedObjectContext
																								 sectionNameKeyPath:nil
																										  cacheName:nil];
	fetchedResultsController.delegate = delegate;

	[fetchedResultsController performFetch:nil];

	return fetchedResultsController;
}

- (void)searchTrackWithQuery:(SearchQuery *)searchQuery {

	[self.operationQueue cancelAllOperations];

	ITSTrackSearchOperation *searchTrackOperation = [[ITSTrackSearchOperation alloc] initWithNetworkClient:self.networkClient
																							   searchQuery:searchQuery];
	searchTrackOperation.delegate = self;

	[self.operationQueue addOperation:searchTrackOperation];
}


#pragma mark - ITSTrackSearchOperationDelegate

- (void)didSearchQuery:(SearchQuery *)query withResults:(NSArray *)results {

	query.queryDate = [NSDate date];
	[self.store saveContext];

#ifdef DEBUG
	NSLog(@"Got results: %d", results.count);
#endif

	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";

	[self.store.managedObjectContext performBlock:^{
		for (id item in results) {
			if (![item isKindOfClass:[NSDictionary class]]) {
				continue;
			}
			NSDictionary *resultItem = item;

			if (![@"song" isEqualToString:resultItem[@"kind"]]
					|| ![resultItem[@"trackId"] isKindOfClass:[NSNumber class]]) {
				continue;
			}

			NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ITunesEntity"];
			request.predicate = [NSPredicate predicateWithFormat:@"trackId = %@", resultItem[@"trackId"]];
			request.fetchLimit = 1;

			NSArray *result = [self.store.managedObjectContext executeFetchRequest:request error:nil];
			if (!result) {
				continue;
			}

			BOOL isNew = NO;
			ITunesEntity *entity;
			if (result.count > 0) {
				entity = result.firstObject;
			} else {
				entity = [[ITunesEntity alloc] initWithEntity:[NSEntityDescription entityForName:@"ITunesEntity" inManagedObjectContext:self.store.managedObjectContext]
							   insertIntoManagedObjectContext:self.store.managedObjectContext];
				entity.trackId = resultItem[@"trackId"];
				isNew = YES;
			}

			entity.wrapperType = resultItem[@"wrapperType"];
			entity.kind = resultItem[@"kind"];
			entity.trackName = resultItem[@"trackName"];
			entity.artistName = resultItem[@"artistName"];
			entity.collectionName = resultItem[@"collectionName"];
			entity.artworkUrl100 = resultItem[@"artworkUrl100"];
			entity.artworkUrl60 = resultItem[@"artworkUrl60"];
			entity.collectionId = resultItem[@"collectionId"];
			entity.artistId = resultItem[@"artistId"];
			entity.releaseDate = [dateFormatter dateFromString:resultItem[@"releaseDate"]];
			entity.primaryGenreName = resultItem[@"primaryGenreName"];

			if (isNew) {
				if (![entity validateForInsert:nil]) {
					[self.store.managedObjectContext deleteObject:entity];
					continue;
				}
			} else {
				if (![entity validateForUpdate:nil]) {
					[self.store.managedObjectContext refreshObject:entity mergeChanges:NO];
					continue;
				}
			}

			[entity addSearchQueriesObject:query];
			[query addEntitiesObject:entity];
		}

		[self.store saveContext];
	}];
}

- (void)didSearchQuery:(SearchQuery *)query failedWithError:(NSError *)error {
#ifdef DEBUG
	NSLog(@"Got error: %@", error);
#endif
}

@end
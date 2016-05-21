//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "TracksManager.h"
#import "SearchQuery.h"
#import "TrackSearchOperation.h"
#import "Manager.h"
#import "ITunesEntity.h"

@interface TracksManager () <TrackSearchOperationDelegate>

@end


@implementation TracksManager {
	NSOperationQueue *_queue;
	NSManagedObjectContext *_storeContext;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_queue = [NSOperationQueue new];
		_storeContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		_storeContext.parentContext = [[Manager sharedManager] managedObjectContext];
	}

	return self;
}

- (BOOL)isLoading {
	return _queue.operationCount > 0;
}

- (void)searchTrackWithQuery:(SearchQuery *)query {
	[_queue cancelAllOperations];

	TrackSearchOperation *searchOperation = [[TrackSearchOperation alloc] initWithQuery:query];
	searchOperation.delegate = self;
	[_queue addOperation:searchOperation];
}


#pragma mark - TrackSearchOperationDelegate

- (void)didSearchQuery:(SearchQuery *)query withResults:(NSArray *)results {
	query.queryDate = [NSDate date];
	[[Manager sharedManager] saveContext];

	NSLog(@"Got results: %d", results.count);

	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";

	[_storeContext performBlock:^{
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

			NSArray *result = [_storeContext executeFetchRequest:request error:nil];
			if (!result) {
				continue;
			}

			BOOL isNew = NO;
			ITunesEntity *entity;
			if (result.count > 0) {
				entity = result.firstObject;
			} else {
				entity = [[ITunesEntity alloc] initWithEntity:[NSEntityDescription entityForName:@"ITunesEntity" inManagedObjectContext:_storeContext]
							   insertIntoManagedObjectContext:_storeContext];
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
					[_storeContext deleteObject:entity];
					continue;
				}
			} else {
				if (![entity validateForUpdate:nil]) {
					[_storeContext refreshObject:entity mergeChanges:NO];
					continue;
				}
			}

			[entity addSearchQueriesObject:query];
			[query addEntitiesObject:entity];
		}

		if (_storeContext.hasChanges && [_storeContext save:nil]) {
			[[Manager sharedManager] saveContext];
		}
	}];
}

- (void)didSearchQuery:(SearchQuery *)query failedWithError:(NSError *)error {
	NSLog(@"Got error: %@", error);
}

@end
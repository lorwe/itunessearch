//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "TracksManager.h"
#import "SearchQuery.h"
#import "TrackSearchOperation.h"

@interface TracksManager () <TrackSearchOperationDelegate>

@end


@implementation TracksManager {
	NSOperationQueue *_queue;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_queue = [NSOperationQueue new];
	}

	return self;
}

- (void)searchTrackWithQuery:(SearchQuery *)query {
	[_queue cancelAllOperations];

	TrackSearchOperation *searchOperation = [[TrackSearchOperation alloc] initWithQuery:query];
	[_queue addOperation:searchOperation];
}


#pragma mark - TrackSearchOperationDelegate

- (void)didSearchQuery:(SearchQuery *)query withResults:(NSArray *)results {
	NSLog(@"Got results: %@", results);
}

- (void)didSearchQuery:(SearchQuery *)query failedWithError:(NSError *)error {
	NSLog(@"Got error: %@", error);
}

@end
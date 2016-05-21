//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "TrackSearchOperation.h"
#import "ApiITunesSearch.h"
#import "SearchQuery.h"


@implementation TrackSearchOperation {
	__weak ApiITunesSearch *_apiSearch;
	SearchQuery *_query;
	NSURLSessionDataTask *_dataTask;
}

- (instancetype)initWithQuery:(SearchQuery *)query {
	self = [super init];
	if (self) {
		_query = query;
	}

	return self;
}

- (void)cancel {
	[super cancel];
	[_dataTask cancel];
}

- (void)main {
	_apiSearch = [ApiITunesSearch sharedInstance];
	_dataTask = [_apiSearch searchTracksWithTerm:_query.term

										 success:^(NSURLSessionDataTask *task, id responseObject) {
											 if (self.isCancelled) {
												 return;
											 }

											 // check if response is valid
											 NSError *error = nil;
											 if (![responseObject isKindOfClass:[NSDictionary class]]
													 || ![responseObject[@"results"] isKindOfClass:[NSArray class]]) {
												 error = [NSError errorWithDomain:APP_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey : @"Invalid response"}];
											 }

											 if (error) {
												 if ([self.delegate respondsToSelector:@selector(didSearchQuery:failedWithError:)]) {
													 [self.delegate didSearchQuery:_query failedWithError:error];
												 }
												 return;
											 }

											 if ([self.delegate respondsToSelector:@selector(didSearchQuery: withResults:)]) {
												 [self.delegate didSearchQuery:_query withResults:responseObject[@"results"]];
											 }
										 }

										 failure:^(NSURLSessionDataTask *task, NSError *error) {
											 if ([self.delegate respondsToSelector:@selector(didSearchQuery:failedWithError:)]) {
												 [self.delegate didSearchQuery:_query failedWithError:error];
											 }
										 }];
}

@end
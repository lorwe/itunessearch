//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "ITSTrackSearchOperation.h"
#import "ITSITunesSearchServiceConstants.h"
#import "ITSNetworking.h"
#import "SearchQuery.h"

@interface ITSTrackSearchOperation ()

@property(nonatomic, strong) SearchQuery *searchQuery;
@property(nonatomic, strong) NSURLSessionDataTask *dataTask;

@end


@implementation ITSTrackSearchOperation

- (instancetype)initWithNetworkClient:(id <ITSNetworking>)networkClient searchQuery:(SearchQuery *)searchQuery {
	self = [super initWithNetworkClient:networkClient];
	if (self) {
		_searchQuery = searchQuery;
	}

	return self;
}

- (void)cancel {
	[super cancel];
	[self.dataTask cancel];
}

- (void)main {
	NSDictionary *parameters = @{
			@"term"  : self.searchQuery.term,
			@"media" : kITunseMediaTypeMusic,
			@"entity": kITunseEntityTypeMusicTrack,
			@"limit" : @(kITunesSearchLimit)
	};

	self.dataTask = [self.networkClient GET:kITunesApiSearchUrl
								 parameters:parameters

									success:^(NSURLSessionDataTask *operation, id responseObject) {
										if (self.isCancelled) {
											return;
										}
										[self finish];

										// check if response is valid
										NSError *error = nil;
										if (![responseObject isKindOfClass:[NSDictionary class]]
												|| ![responseObject[@"results"] isKindOfClass:[NSArray class]]) {
											error = [NSError errorWithDomain:APP_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey: @"Invalid response"}];
										}

										if (error) {
											if ([self.delegate respondsToSelector:@selector(didSearchQuery:failedWithError:)]) {
												[self.delegate didSearchQuery:self.searchQuery failedWithError:error];
											}
											return;
										}

										if ([self.delegate respondsToSelector:@selector(didSearchQuery: withResults:)]) {
											[self.delegate didSearchQuery:self.searchQuery withResults:responseObject[@"results"]];
										}
									}

									failure:^(NSURLSessionDataTask *operation, NSError *error) {
										if ([self.delegate respondsToSelector:@selector(didSearchQuery:failedWithError:)]) {
											[self.delegate didSearchQuery:self.searchQuery failedWithError:error];
										}
										[self failWithError:error];
									}];
}

@end
//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "ApiITunesSearch.h"

const NSUInteger kITunesSearchLimit = 50;


@implementation ApiITunesSearch {

}

- (NSURLSessionDataTask *)searchTracksWithTerm:(NSString *)term
									   success:(void (^)(NSURLSessionDataTask *_Nonnull, id _Nullable responseObject))success
									   failure:(void (^)(NSURLSessionDataTask *_Nullable, NSError *_Nonnull))failure {

	NSDictionary *parameters = @{
			@"term"   : term,
			@"media"  : kITunseMediaTypeMusic,
			@"entity" : kITunseEntityTypeMusicTrack,
			@"limit"  : @(kITunesSearchLimit)
	};

	return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
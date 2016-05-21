//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiITunes.h"

extern const NSUInteger kITunesSearchLimit;


/**
 * Search request implementation
 */
@interface ApiITunesSearch : ApiITunes

- (nullable NSURLSessionDataTask *)searchTracksWithTerm:(nullable NSString *)term
												success:(nullable void (^)(NSURLSessionDataTask *_Nonnull, id _Nullable responseObject))success
												failure:(nullable void (^)(NSURLSessionDataTask *_Nullable, NSError *_Nonnull))failure;

@end
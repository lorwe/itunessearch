//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchQuery;


@interface TracksManager : NSObject

/**
 * Returns YES if search operations are in progress
 */
- (BOOL)isLoading;

/**
 * Performs search request
 */
- (void)searchTrackWithQuery:(SearchQuery *)query;

@end
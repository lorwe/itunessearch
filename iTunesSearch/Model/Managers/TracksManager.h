//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchQuery;


@interface TracksManager : NSObject

/**
 * Performs search request
 */
- (void)searchTrackWithQuery:(SearchQuery *)query;

@end
//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchQuery;


@interface QueriesManager : NSObject

/**
 * Returns the latest query
 */
- (nullable SearchQuery *)lastQuery;

/**
 * Returns query with given term
 */
- (nullable SearchQuery *)queryWithTerm:(nullable NSString *)term;

/**
 * Returns array of recent searches with terms matching the string given
 */
- (nonnull NSArray *)recentQueriesWithTerm:(nullable NSString *)term;

@end
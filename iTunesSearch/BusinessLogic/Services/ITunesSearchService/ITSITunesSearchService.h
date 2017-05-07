//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITSNetworking;
@class ITSCoreDataStore;
@class SearchQuery;

NS_ASSUME_NONNULL_BEGIN

@protocol ITSITunesSearchService <NSObject>

@property(nonatomic, strong) id <ITSNetworking> networkClient;
@property(nonatomic, strong) ITSCoreDataStore *store;

- (instancetype)initWithNetworkClient:(id <ITSNetworking>)networkClient
								store:(ITSCoreDataStore *)store;

/**
 * Returns the latest query
 */
- (nullable SearchQuery *)getLastQuery;

/**
 * Adds new query with given term
 */
- (SearchQuery *)addQueryWithTerm:(NSString *)term;

/**
 * Returns existing query with given term
 */
- (nullable SearchQuery *)getQueryWithTerm:(NSString *)term;

/**
 * Returns array of recent searches with terms matching the string given
 */
- (nonnull NSArray *)getRecentQueriesWithTerm:(NSString *)term;

/**
 * Creates fetched results cintroller with given query
 * @param searchQuery Search query
 * @param delegate Delegate
 * @return (NSFetchedResultsController *)
 */
- (NSFetchedResultsController *)fetchedResultsControllerWithQuery:(SearchQuery *)searchQuery delegate:(id <NSFetchedResultsControllerDelegate>)delegate;

/**
 * Performs search request
 */
- (void)searchTrackWithQuery:(SearchQuery *)searchQuery;

@end

NS_ASSUME_NONNULL_END;
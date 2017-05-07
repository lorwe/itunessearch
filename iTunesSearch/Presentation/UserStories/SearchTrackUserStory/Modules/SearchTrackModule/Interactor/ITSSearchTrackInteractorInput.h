//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSSearchQueryObject;
@class ITSTrackObject;


@protocol ITSSearchTrackInteractorInput <NSObject>

- (ITSSearchQueryObject *)addQueryWithTerm:(NSString *)term;

- (NSArray<ITSSearchQueryObject *> *)getRecentQueriesWithTerm:(NSString *)term;

- (NSArray<ITSTrackObject *> *)searchQuery:(ITSSearchQueryObject *)searchQuery;

- (ITSTrackObject *)trackObjectAtIndex:(NSUInteger)index;

@end
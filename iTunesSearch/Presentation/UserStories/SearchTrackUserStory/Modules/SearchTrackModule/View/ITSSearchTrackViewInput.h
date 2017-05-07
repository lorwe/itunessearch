//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSSearchQueryObject;
@class ITSTrackObject;


@protocol ITSSearchTrackViewInput <NSObject>

- (void)setRecentQueries:(NSArray<ITSSearchQueryObject *> *)recentQueries;

- (void)setTracks:(NSArray<ITSTrackObject *> *)tracks;

- (void)setSearchActive:(BOOL)active;

- (void)setSearchText:(NSString *)text;

- (void)beginUpdates;

- (void)insertTrack:(ITSTrackObject *)trackObject atIndex:(NSUInteger)index;

- (void)deleteTrackAtIndex:(NSUInteger)index;

- (void)updateTrack:(ITSTrackObject *)trackObject atIndex:(NSUInteger)index;

- (void)endUpdates;

@end
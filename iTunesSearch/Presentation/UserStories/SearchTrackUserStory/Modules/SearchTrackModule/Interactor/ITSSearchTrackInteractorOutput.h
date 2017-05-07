//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSTrackObject;


@protocol ITSSearchTrackInteractorOutput <NSObject>

- (void)willChangeContent;

- (void)didInsertTrack:(ITSTrackObject *)track atIndex:(NSUInteger)index;

- (void)didDeleteTrackAtIndex:(NSUInteger)index;

- (void)didUpdateTrack:(ITSTrackObject *)track atIndex:(NSUInteger)index;

- (void)didChangeContent;

@end
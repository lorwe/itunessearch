//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSTrackObject;
@class ITSSearchQueryObject;


@protocol ITSSearchTrackViewOutput <NSObject>

- (void)viewWillAppear;

- (void)didChangeSearchTerm:(NSString *)term;

- (void)didSearchButtonTouchWithTerm:(NSString *)term;

- (void)didSelectTrackAtIndex:(NSUInteger)index;

- (void)didSelectQueryAtIndex:(NSUInteger)index;

@end
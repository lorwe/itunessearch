//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSTrackObject;


@protocol ITSSearchTrackRouterInput <NSObject>

- (void)openTrackDetailsModuleWithTrackObject:(ITSTrackObject *)trackObject;

@end
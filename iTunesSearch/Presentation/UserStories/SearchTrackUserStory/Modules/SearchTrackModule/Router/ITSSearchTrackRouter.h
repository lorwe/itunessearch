//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSSearchTrackRouterInput.h"


@interface ITSSearchTrackRouter : NSObject <ITSSearchTrackRouterInput>

@property(nonatomic, weak) UIViewController *transitionCoordinator;

@end
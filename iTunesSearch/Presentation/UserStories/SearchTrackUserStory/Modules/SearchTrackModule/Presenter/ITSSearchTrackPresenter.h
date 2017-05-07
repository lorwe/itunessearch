//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSSearchTrackInteractorOutput.h"
#import "ITSSearchTrackViewOutput.h"

@protocol ITSSearchTrackInteractorInput;
@protocol ITSSearchTrackViewInput;
@protocol ITSSearchTrackRouterInput;


@interface ITSSearchTrackPresenter : NSObject <ITSSearchTrackInteractorOutput, ITSSearchTrackViewOutput>

@property(nonatomic, weak) id <ITSSearchTrackViewInput> view;
@property(nonatomic, strong) id <ITSSearchTrackInteractorInput> interactor;
@property(nonatomic, strong) id <ITSSearchTrackRouterInput> router;

@end
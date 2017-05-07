//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSTrackDetailsModuleInput.h"
#import "ITSTrackDetailsViewOutput.h"

@protocol ITSTrackDetailsViewInput;


@interface ITSTrackDetailsPresenter : NSObject <ITSTrackDetailsModuleInput, ITSTrackDetailsViewOutput>

@property(nonatomic, weak) id <ITSTrackDetailsViewInput> view;

@end
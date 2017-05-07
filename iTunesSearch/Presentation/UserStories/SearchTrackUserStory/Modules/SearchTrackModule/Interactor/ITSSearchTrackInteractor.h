//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSSearchTrackInteractorInput.h"

@protocol ITSITunesSearchService;
@protocol ITSSearchTrackInteractorOutput;


@interface ITSSearchTrackInteractor : NSObject <ITSSearchTrackInteractorInput>

@property(nonatomic, weak) id <ITSSearchTrackInteractorOutput> output;
@property(nonatomic, strong) id <ITSITunesSearchService> searchService;

@end
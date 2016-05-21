//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequestOperation.h"

@class SearchQuery;


@protocol TrackSearchOperationDelegate <NSObject>

- (void)didSearchQuery:(SearchQuery *)query withResults:(NSArray *)results;

- (void)didSearchQuery:(SearchQuery *)query failedWithError:(NSError *)error;

@end


@interface TrackSearchOperation : ApiRequestOperation

@property(nonatomic, weak) id <TrackSearchOperationDelegate> delegate;

- (instancetype)initWithQuery:(SearchQuery *)query;

@end
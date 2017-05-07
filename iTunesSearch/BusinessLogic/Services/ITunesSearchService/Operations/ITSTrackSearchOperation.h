//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITSRequestOperation.h"

@protocol ITSNetworking;
@class SearchQuery;


@protocol ITSTrackSearchOperationDelegate <NSObject>

- (void)didSearchQuery:(SearchQuery *)query withResults:(NSArray *)results;

- (void)didSearchQuery:(SearchQuery *)query failedWithError:(NSError *)error;

@end


@interface ITSTrackSearchOperation : ITSRequestOperation

@property(nonatomic, weak) id <ITSTrackSearchOperationDelegate> delegate;

- (instancetype)initWithNetworkClient:(id <ITSNetworking>)networkClient
						  searchQuery:(SearchQuery *)searchQuery;

@end
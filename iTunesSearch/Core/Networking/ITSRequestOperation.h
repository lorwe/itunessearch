//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ITSRequestOperationStateReady,
	ITSRequestOperationStateExecuting,
	ITSRequestOperationStateFinished,
	ITSRequestOperationStateFailed,
	ITSRequestOperationStateCancelled
} ITSRequestOperationState;


@protocol ITSNetworking;


@interface ITSRequestOperation : NSOperation

@property(nonatomic) ITSRequestOperationState state;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, weak) id <ITSNetworking> networkClient;

- (instancetype)initWithNetworkClient:(id <ITSNetworking>)networkClient NS_DESIGNATED_INITIALIZER;

- (void)finish;

- (void)failWithError:(NSError *)error;

@end
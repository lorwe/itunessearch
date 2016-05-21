//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ApiRequestOperationReady,
	ApiRequestOperationExecuting,
	ApiRequestOperationFinished,
	ApiRequestOperationFailed,
	ApiRequestOperationCancelled
} ApiRequestOperationState;


@interface ApiRequestOperation : NSOperation

@property(nonatomic) ApiRequestOperationState state;

@property(nonatomic, strong) NSError *error;

- (void)finish;

- (void)failWithError:(NSError *)error;

@end
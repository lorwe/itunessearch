//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "ApiRequestOperation.h"


@implementation ApiRequestOperation
- (instancetype)init {
	self = [super init];
	if (self) {
		_error = nil;
		_state = ApiRequestOperationReady;
	}

	return self;
}

- (void)finish {
	self.state = ApiRequestOperationFinished;
}

- (void)failWithError:(NSError *)error {
	_error = error;
	self.state = ApiRequestOperationFailed;
}


#pragma mark - KVO

static inline NSString *KeyPathFromOperationState(ApiRequestOperationState state) {
	switch (state) {
		case ApiRequestOperationReady:
			return @"isReady";
		case ApiRequestOperationExecuting:
			return @"isExecuting";
		case ApiRequestOperationFinished:
			return @"isFinished";
		case ApiRequestOperationFailed:
			return @"isFinished";
		case ApiRequestOperationCancelled:
			return @"isCancelled";
		default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
			return @"state";
#pragma clang diagnostic pop
		}
	}
}

- (void)setState:(ApiRequestOperationState)state {
	NSString *oldStateKey = KeyPathFromOperationState(self.state);
	NSString *newStateKey = KeyPathFromOperationState(state);
	[self willChangeValueForKey:newStateKey];
	[self willChangeValueForKey:oldStateKey];
	_state = state;
	[self didChangeValueForKey:oldStateKey];
	[self didChangeValueForKey:newStateKey];
}


#pragma mark - NSOperation

- (void)start {
	self.state = ApiRequestOperationExecuting;
	[self main];
}

- (void)cancel {
	[super cancel];
	self.state = ApiRequestOperationCancelled;
}

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isAsynchronous {
	return YES;
}

- (BOOL)isExecuting {
	return self.state == ApiRequestOperationExecuting;
}

- (BOOL)isFinished {
	return self.state == ApiRequestOperationFinished || self.state == ApiRequestOperationFailed;
}


- (BOOL)isCancelled {
	return self.state == ApiRequestOperationCancelled;
}
@end
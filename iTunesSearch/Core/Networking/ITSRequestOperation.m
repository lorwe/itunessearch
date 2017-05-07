//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "ITSRequestOperation.h"
#import "ITSNetworking.h"


@implementation ITSRequestOperation

- (instancetype)init {
	self = [self initWithNetworkClient:nil];
	if (self) {
		_error = nil;
		_state = ITSRequestOperationStateReady;
	}

	return self;
}

- (instancetype)initWithNetworkClient:(id <ITSNetworking>)networkClient {
	self = [super init];
	if (self) {
		_networkClient = networkClient;
		_error = nil;
		_state = ITSRequestOperationStateReady;
	}

	return self;
}

- (void)finish {
	self.state = ITSRequestOperationStateFinished;
}

- (void)failWithError:(NSError *)error {
	_error = error;
	self.state = ITSRequestOperationStateFailed;
}


#pragma mark - KVO

static inline NSString *KeyPathFromOperationState(ITSRequestOperationState state) {
	switch (state) {
		case ITSRequestOperationStateReady:
			return @"isReady";
		case ITSRequestOperationStateExecuting:
			return @"isExecuting";
		case ITSRequestOperationStateFinished:
			return @"isFinished";
		case ITSRequestOperationStateFailed:
			return @"isFinished";
		case ITSRequestOperationStateCancelled:
			return @"isCancelled";
		default:
			return @"state";
	}
}

- (void)setState:(ITSRequestOperationState)state {
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
	self.state = ITSRequestOperationStateExecuting;
	[self main];
}

- (void)cancel {
	[super cancel];
	self.state = ITSRequestOperationStateCancelled;
}

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isAsynchronous {
	return YES;
}

- (BOOL)isExecuting {
	return self.state == ITSRequestOperationStateExecuting;
}

- (BOOL)isFinished {
	return self.state == ITSRequestOperationStateFinished || self.state == ITSRequestOperationStateFailed;
}


- (BOOL)isCancelled {
	return self.state == ITSRequestOperationStateCancelled;
}

@end
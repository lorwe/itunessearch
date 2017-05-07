//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ITSNetworkClient.h"


@interface ITSNetworkClient ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation ITSNetworkClient {
	NSURL *_baseUrl;
}

@synthesize timeoutInterval = _timeoutInterval;


- (instancetype)initWithBaseUrl:(NSURL *)baseUrl {
	self = [super init];
	if (self) {
		_baseUrl = baseUrl;
	}
	return self;
}


#pragma mark - Properties

- (NSURL *)baseUrl {
	return _baseUrl;
}

- (void)setBaseUrl:(NSURL *)baseUrl {
	_baseUrl = baseUrl;
	_sessionManager = nil;
}

- (AFHTTPSessionManager *)sessionManager {
	if (_sessionManager) {
		return _sessionManager;
	}

	_sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseUrl];

	return _sessionManager;
}


#pragma mark - Networking

- (void)setRequestSerializerDefaults {
	self.sessionManager.requestSerializer.timeoutInterval = self.timeoutInterval;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
				   parameters:(NSDictionary *)parameters
					  success:(ITSNetworkClientSuccessBlock)success
					  failure:(ITSNetworkClientFailureBlock)failure {

	[self setRequestSerializerDefaults];

	NSURLSessionDataTask *task = [self.sessionManager GET:URLString
											   parameters:parameters
												 progress:nil
												  success:success
												  failure:failure];


#ifdef DEBUG
	NSLog(@"[API] GET %@", task.currentRequest.URL.absoluteString);
#endif

	return task;
}

@end
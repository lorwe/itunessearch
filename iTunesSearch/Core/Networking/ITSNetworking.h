//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^__nullable ITSNetworkClientSuccessBlock)(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject);

typedef void (^__nullable ITSNetworkClientFailureBlock)(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error);


NS_ASSUME_NONNULL_BEGIN

/**
 * @protocol ITSNetworkClient
 *
 * Network client protocol
 */
@protocol ITSNetworking <NSObject>

/**
 * Base URL
 */
@property(nonatomic, strong) NSURL *baseUrl;

/**
 * Request timeout
 */
@property(nonatomic) NSTimeInterval timeoutInterval;

/**
 * Initializer
 *
 * @param baseUrl Base URL

 * @return id<ITSNetworkClient>
 */
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl;

/**
 * Performs GET-request to the specified relative URL
 *
 * @param URLString relative URL string.
 * @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 * @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
				   parameters:(NSDictionary *)parameters
					  success:(ITSNetworkClientSuccessBlock)success
					  failure:(ITSNetworkClientFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
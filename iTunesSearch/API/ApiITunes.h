//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *__nonnull const kITunesApiBaseUrl;

/**
 * iTunes Media Types
 */
extern NSString *__nonnull const kITunseMediaTypeMovie;
extern NSString *__nonnull const kITunseMediaTypePodcast;
extern NSString *__nonnull const kITunseMediaTypeMusic;
extern NSString *__nonnull const kITunseMediaTypeMusicVideo;
extern NSString *__nonnull const kITunseMediaTypeAudioBook;
extern NSString *__nonnull const kITunseMediaTypeShortFilm;
extern NSString *__nonnull const kITunseMediaTypeTVShow;
extern NSString *__nonnull const kITunseMediaTypeSoftware;
extern NSString *__nonnull const kITunseMediaTypeEBook;
extern NSString *__nonnull const kITunseMediaTypeAll;


/**
 * iTunes Entity Types
 */
extern NSString *__nonnull const kITunseEntityTypeMusicArtist;
extern NSString *__nonnull const kITunseEntityTypeMusicTrack;
extern NSString *__nonnull const kITunseEntityTypeMusicAlbum;
extern NSString *__nonnull const kITunseEntityTypeMusicVideo;
extern NSString *__nonnull const kITunseEntityTypeMusicMix;
extern NSString *__nonnull const kITunseEntityTypeMusicSong;
// no need to implement others



@interface ApiITunes : NSObject

/**
 * Singleton
 * @return The shared instance
 */
+ (nonnull instancetype)sharedInstance;

/**
 * Performs GET-request to the specified relative URL
 * @param URLString relative URL string.
 * @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 * @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 * @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 */
- (nullable NSURLSessionDataTask *)GET:(nullable NSString *)URLString
							parameters:(nullable NSDictionary *)parameters
							   success:(nullable void (^)(NSURLSessionDataTask *_Nonnull, id _Nullable responseObject))success
							   failure:(nullable void (^)(NSURLSessionDataTask *_Nullable, NSError *_Nonnull))failure;

@end
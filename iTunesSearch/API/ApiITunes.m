//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ApiITunes.h"


NSString *const kITunesApiBaseUrl = @"https://itunes.apple.com";

NSString *const kITunseMediaTypeMovie = @"movie";
NSString *const kITunseMediaTypePodcast = @"podcast";
NSString *const kITunseMediaTypeMusic = @"music";
NSString *const kITunseMediaTypeMusicVideo = @"musicVideo";
NSString *const kITunseMediaTypeAudioBook = @"audiobook";
NSString *const kITunseMediaTypeShortFilm = @"shortFilm";
NSString *const kITunseMediaTypeTVShow = @"tvShow";
NSString *const kITunseMediaTypeSoftware = @"software";
NSString *const kITunseMediaTypeEBook = @"ebook";
NSString *const kITunseMediaTypeAll = @"all";


NSString *const kITunseEntityTypeMusicArtist = @"musicArtist";
NSString *const kITunseEntityTypeMusicTrack = @"musicTrack";
NSString *const kITunseEntityTypeMusicAlbum = @"album";
NSString *const kITunseEntityTypeMusicVideo = @"musicVideo";
NSString *const kITunseEntityTypeMusicMix = @"mix";
NSString *const kITunseEntityTypeMusicSong = @"song";


@implementation ApiITunes

static NSMutableDictionary *_instance = nil;

+ (instancetype)sharedInstance {

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [NSMutableDictionary dictionary];
	});

	id sharedInstance;

	@synchronized (self) {
		NSString *className = NSStringFromClass(self);
		sharedInstance = _instance[className];
		if (!sharedInstance) {
			sharedInstance = [self new];
			_instance[className] = sharedInstance;
		}
	}

	return sharedInstance;
}

- (instancetype)init {
	self = [super init];
	if (self) {

	}

	return self;
}

- (AFHTTPSessionManager *)sessionManager {
	static AFHTTPSessionManager *sessionManager = nil;
	if (!sessionManager) {
		sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kITunesApiBaseUrl]];
	}
	return sessionManager;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
				   parameters:(NSDictionary *)parameters
					  success:(void (^)(NSURLSessionDataTask *_Nonnull, id _Nullable responseObject))success
					  failure:(void (^)(NSURLSessionDataTask *_Nullable, NSError *_Nonnull))failure {

	NSError *error;

	NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"GET"
																				  URLString:[[NSURL URLWithString:URLString relativeToURL:self.sessionManager.baseURL] absoluteString]
																				 parameters:parameters
																					  error:&error];

	[request setTimeoutInterval:10.0];
	// Set additional headers if it is necessary

	[[UIApplication sharedApplication] setNetworkActivity:YES];

	NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request
															completionHandler:^(NSURLResponse *response, id responseObject, NSError *_error) {
																[[UIApplication sharedApplication] setNetworkActivity:NO];
																if (_error) {
																	failure(dataTask, _error);
																}
																success(dataTask, responseObject);
															}];

#ifdef DEBUG
	NSLog(@"[API] %@", request.URL);
#endif

	[dataTask resume];

	return dataTask;
}

@end
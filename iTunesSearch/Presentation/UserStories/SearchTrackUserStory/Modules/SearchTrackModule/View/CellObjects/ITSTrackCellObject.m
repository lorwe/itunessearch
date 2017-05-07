//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSTrackCellObject.h"
#import "ITSTrackObject.h"


@implementation ITSTrackCellObject

- (instancetype)initWithTrackObject:(ITSTrackObject *)trackObject forSacle:(CGFloat)scale {
	self = [self init];
	if (self) {
		_title = trackObject.trackName;
		_details = [self detailsTextWithObject:trackObject];
		_imageURL = [self artworkImageUrlWithObject:trackObject forSacle:scale];
	}

	return self;
}

- (NSString *)detailsTextWithObject:(ITSTrackObject *)trackObject {
	NSString *artistName = trackObject.artistName.length > 0 ? trackObject.artistName : @"Неизвестый артист";
	NSString *collectionName = trackObject.collectionName.length > 0 ? trackObject.collectionName : @"Неизвестый альбом";
	return [NSString stringWithFormat:@"%@ – %@", artistName, collectionName];
}

- (NSURL *)artworkImageUrlWithObject:(ITSTrackObject *)trackObject forSacle:(CGFloat)scale {
	CGFloat size;
	if (scale >= 3.0) {
		size = 180;
	} else if (scale >= 2.0) {
		size = 120;
	} else {
		size = 60;
	}
	NSURL *result = nil;
	if (trackObject.artworkUrl100.length > 0) {
		result = [NSURL URLWithString:[trackObject.artworkUrl100 stringByReplacingOccurrencesOfString:@"100x100" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	} else if (trackObject.artworkUrl60.length > 0) {
		result = [NSURL URLWithString:[trackObject.artworkUrl60 stringByReplacingOccurrencesOfString:@"60x60" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	}
	return result;
}

@end
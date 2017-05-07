//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSTrackDetailsPresenter.h"
#import "ITSTrackDetailsViewInput.h"
#import "ITSTrackObject.h"


@implementation ITSTrackDetailsPresenter {
	NSDateFormatter *_releaseDateFormatter;
}

- (NSDateFormatter *)releaseDateFormatter {
	if (!_releaseDateFormatter) {
		_releaseDateFormatter = [NSDateFormatter new];
		_releaseDateFormatter.dateFormat = @"dd/MM/yyyy";
	}
	return _releaseDateFormatter;
}

- (NSURL *)artworkImageUrlForTrackObject:(ITSTrackObject *)trackObject forWidth:(CGFloat)width scale:(CGFloat)scale {
	CGFloat size;
	if (scale >= 3) {
		size = width * 3;
	} else if (scale == 2) {
		size = width * 2;
	} else {
		size = width;
	}
	NSURL *result = nil;
	if (trackObject.artworkUrl100.length > 0) {
		result = [NSURL URLWithString:[trackObject.artworkUrl100 stringByReplacingOccurrencesOfString:@"100x100" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	} else if (trackObject.artworkUrl60.length > 0) {
		result = [NSURL URLWithString:[trackObject.artworkUrl60 stringByReplacingOccurrencesOfString:@"60x60" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	}
	return result;
}


#pragma mark - ModuleInput

- (void)configureWithTrack:(ITSTrackObject *)trackObject {
	[self.view setTitle:trackObject.trackName];
	[self.view setArtist:trackObject.artistName];
	[self.view setAlbumTitle:trackObject.collectionName];
	[self.view setGenre:trackObject.primaryGenreName];
	[self.view setReleaseDateText:[self.releaseDateFormatter stringFromDate:trackObject.releaseDate]];
	[self.view setArtworkImageURL:[self artworkImageUrlForTrackObject:trackObject
															 forWidth:self.view.width
																scale:self.view.scale]];
}

@end
//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSTrackObject.h"
#import "ITunesEntity.h"


@implementation ITSTrackObject

- (instancetype)initWithEntity:(ITunesEntity *)entity {
	self = [self init];
	if (self) {
		_wrapperType = entity.wrapperType;
		_kind = entity.kind;
		_trackName = entity.trackName;
		_artistName = entity.artistName;
		_collectionName = entity.collectionName;
		_artworkUrl100 = entity.artworkUrl100;
		_artworkUrl60 = entity.artworkUrl60;
		_primaryGenreName = entity.primaryGenreName;
		_trackId = entity.trackId;
		_collectionId = entity.collectionId;
		_artistId = entity.artistId;
		_releaseDate = entity.releaseDate;
	}

	return self;
}

@end
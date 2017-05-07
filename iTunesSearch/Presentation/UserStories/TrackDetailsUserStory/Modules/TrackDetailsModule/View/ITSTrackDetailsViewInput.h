//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSTrackObject;


@protocol ITSTrackDetailsViewInput <NSObject>

- (void)setTitle:(NSString *)title;

- (void)setArtist:(NSString *)artist;

- (void)setAlbumTitle:(NSString *)albumTitle;

- (void)setGenre:(NSString *)genre;

- (void)setArtworkImageURL:(NSURL *)url;

- (void)setReleaseDateText:(NSString *)releaseDate;

- (CGFloat)width;

- (CGFloat)scale;

@end
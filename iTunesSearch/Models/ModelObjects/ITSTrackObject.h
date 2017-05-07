//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITunesEntity;

NS_ASSUME_NONNULL_BEGIN

@interface ITSTrackObject : NSObject

@property(nullable, nonatomic, retain) NSString *wrapperType;
@property(nullable, nonatomic, retain) NSString *kind;
@property(nullable, nonatomic, retain) NSString *trackName;
@property(nullable, nonatomic, retain) NSString *artistName;
@property(nullable, nonatomic, retain) NSString *collectionName;
@property(nullable, nonatomic, retain) NSString *artworkUrl100;
@property(nullable, nonatomic, retain) NSString *artworkUrl60;
@property(nullable, nonatomic, retain) NSString *primaryGenreName;
@property(nullable, nonatomic, retain) NSNumber *trackId;
@property(nullable, nonatomic, retain) NSNumber *collectionId;
@property(nullable, nonatomic, retain) NSNumber *artistId;
@property(nullable, nonatomic, retain) NSDate *releaseDate;

- (instancetype)initWithEntity:(ITunesEntity *)entity;

@end

NS_ASSUME_NONNULL_END
//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSTrackObject;


@interface ITSTrackCellObject : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *details;
@property(nonatomic, strong) NSURL *imageURL;

- (instancetype)initWithTrackObject:(ITSTrackObject *)trackObject forSacle:(CGFloat)scale;

@end
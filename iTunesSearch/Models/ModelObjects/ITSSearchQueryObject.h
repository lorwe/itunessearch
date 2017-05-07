//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchQuery;

NS_ASSUME_NONNULL_BEGIN

@interface ITSSearchQueryObject : NSObject

@property(nullable, nonatomic, retain) NSString *term;
@property(nullable, nonatomic, retain) NSDate *queryDate;

- (instancetype)initWithEntity:(SearchQuery *)entity;

@end

NS_ASSUME_NONNULL_END
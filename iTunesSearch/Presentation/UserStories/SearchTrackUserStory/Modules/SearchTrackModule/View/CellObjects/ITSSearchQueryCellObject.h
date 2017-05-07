//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSSearchQueryObject;


@interface ITSSearchQueryCellObject : NSObject

@property(nonatomic, strong) NSString *title;

- (instancetype)initWithQueryObject:(ITSSearchQueryObject *)queryObject;

@end
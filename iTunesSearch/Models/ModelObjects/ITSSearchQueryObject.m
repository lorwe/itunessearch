//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSSearchQueryObject.h"
#import "SearchQuery.h"


@implementation ITSSearchQueryObject

- (instancetype)initWithEntity:(SearchQuery *)entity {
	self = [self init];
	if (self) {
		_term = entity.term;
		_queryDate = entity.queryDate;
	}

	return self;
}

@end
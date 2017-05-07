//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSSearchQueryCellObject.h"
#import "ITSSearchQueryObject.h"


@implementation ITSSearchQueryCellObject

- (instancetype)initWithQueryObject:(ITSSearchQueryObject *)queryObject {
	self = [self init];
	if (self) {
		_title = queryObject.term;
	}

	return self;
}

@end
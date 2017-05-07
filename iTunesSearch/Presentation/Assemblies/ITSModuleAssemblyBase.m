//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSModuleAssemblyBase.h"
#import "ITSServiceComponents.h"
#import "ITSServiceComponentsAssembly.h"


@implementation ITSModuleAssemblyBase

static ITSServiceComponentsAssembly *_serviceComponents;

- (id <ITSServiceComponents>)serviceComponents {
	if (_serviceComponents == nil) {
		_serviceComponents = [[ITSServiceComponentsAssembly alloc] init];
	}
	return _serviceComponents;
}

@end
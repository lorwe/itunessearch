//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITSServiceComponents;


@interface ITSModuleAssemblyBase : NSObject

- (id <ITSServiceComponents>)serviceComponents;

@end
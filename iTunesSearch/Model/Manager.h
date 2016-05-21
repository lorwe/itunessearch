//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "QueriesManager.h"


/**
 * Business logic implementation and Core Data stack
 */
@interface Manager : NSObject

/**
 * Queries Manager
 */
@property(nonatomic, readonly) QueriesManager *queries;

/**
 * Singleton
 * @return The shared instance
 */
+ (instancetype)sharedManager;


#pragma mark - Core Data Stack

/**
 * UI context
 */
@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;

- (void)saveContext:(void (^)())completion;

@end
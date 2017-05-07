//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * Core Data stack
 */
@interface ITSCoreDataStore : NSObject

/**
 * UI context
 */
- (NSManagedObjectContext *)managedObjectContext;

/**
 * Saving
 */
- (void)saveContext;

- (void)saveContext:(void (^)())completion;

@end
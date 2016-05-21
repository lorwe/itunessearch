//
//  SearchQuery+CoreDataProperties.h
//  
//
//  Created by Farid on 21.05.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SearchQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchQuery (CoreDataProperties)

@property(nullable, nonatomic, retain) NSString *term;
@property(nullable, nonatomic, retain) NSDate *queryDate;
@property(nullable, nonatomic, retain) NSSet<NSManagedObject *> *entities;

@end

@interface SearchQuery (CoreDataGeneratedAccessors)

- (void)addEntitiesObject:(NSManagedObject *)value;

- (void)removeEntitiesObject:(NSManagedObject *)value;

- (void)addEntities:(NSSet<NSManagedObject *> *)values;

- (void)removeEntities:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END

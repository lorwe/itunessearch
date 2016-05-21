//
//  ITunesEntity+CoreDataProperties.h
//  
//
//  Created by Farid on 21.05.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ITunesEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ITunesEntity (CoreDataProperties)

@property(nullable, nonatomic, retain) NSString *wrapperType;
@property(nullable, nonatomic, retain) NSString *kind;
@property(nullable, nonatomic, retain) NSString *trackName;
@property(nullable, nonatomic, retain) NSString *artistName;
@property(nullable, nonatomic, retain) NSString *collectionName;
@property(nullable, nonatomic, retain) NSString *artworkUrl100;
@property(nullable, nonatomic, retain) NSString *artworkUrl60;
@property(nullable, nonatomic, retain) NSNumber *trackId;
@property(nullable, nonatomic, retain) NSNumber *collectionId;
@property(nullable, nonatomic, retain) NSNumber *artistId;
@property(nullable, nonatomic, retain) NSDate *releaseDate;
@property(nullable, nonatomic, retain) NSSet<SearchQuery *> *searchQueries;

@end

@interface ITunesEntity (CoreDataGeneratedAccessors)

- (void)addSearchQueriesObject:(SearchQuery *)value;

- (void)removeSearchQueriesObject:(SearchQuery *)value;

- (void)addSearchQueries:(NSSet<SearchQuery *> *)values;

- (void)removeSearchQueries:(NSSet<SearchQuery *> *)values;

@end

NS_ASSUME_NONNULL_END

//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSSearchTrackPresenter.h"
#import "ITSSearchTrackInteractorInput.h"
#import "ITSSearchTrackViewInput.h"
#import "ITSSearchTrackRouterInput.h"
#import "ITSSearchQueryObject.h"

@interface ITSSearchTrackPresenter ()

@property(nonatomic, strong) NSMutableArray<ITSSearchQueryObject *> *recentQueries;

@end


@implementation ITSSearchTrackPresenter

- (void)searchTerm:(NSString *)term {
	ITSSearchQueryObject *queryObject = [self.interactor addQueryWithTerm:term];
	[self searchQuery:queryObject];
}

- (void)searchQuery:(ITSSearchQueryObject *)searchQuery {
	[self.view setSearchActive:NO];

	NSArray *tracks = [self.interactor searchQuery:searchQuery];
	[self.view setTracks:tracks];
}


#pragma mark - ViewOutput

- (void)viewWillAppear {
	self.recentQueries = [NSMutableArray array];
}

- (void)didChangeSearchTerm:(NSString *)term {
	self.recentQueries = [[self.interactor getRecentQueriesWithTerm:term] mutableCopy];
	[self.view setRecentQueries:self.recentQueries];
}

- (void)didSearchButtonTouchWithTerm:(NSString *)term {
	[self searchTerm:term];
}

- (void)didSelectTrackAtIndex:(NSUInteger)index {
	ITSTrackObject *trackObject = [self.interactor trackObjectAtIndex:index];
	[self.router openTrackDetailsModuleWithTrackObject:trackObject];
}

- (void)didSelectQueryAtIndex:(NSUInteger)index {
	ITSSearchQueryObject *searchQuery = self.recentQueries[index];
	[self.view setSearchText:searchQuery.term];
	[self searchQuery:searchQuery];
}


#pragma mark - InteractorOutput

- (void)willChangeContent {
	[self.view beginUpdates];
}

- (void)didInsertTrack:(ITSTrackObject *)trackObject atIndex:(NSUInteger)index {
	[self.view insertTrack:trackObject atIndex:index];
}

- (void)didDeleteTrackAtIndex:(NSUInteger)index {
	[self.view deleteTrackAtIndex:index];
}

- (void)didUpdateTrack:(ITSTrackObject *)trackObject atIndex:(NSUInteger)index {
	[self.view updateTrack:trackObject atIndex:index];
}

- (void)didChangeContent {
	[self.view endUpdates];
}

@end
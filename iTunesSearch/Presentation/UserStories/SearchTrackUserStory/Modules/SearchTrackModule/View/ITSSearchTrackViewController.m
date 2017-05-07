//
//  ITSSearchTrackViewController.m
//  iTunesSearch
//
//  Created by Farid on 21.05.16.
//  Copyright © 2016 Farid. All rights reserved.
//

#import "ITSSearchTrackViewController.h"
#import "ITSSearchTrackViewOutput.h"
#import "ITSTrackCellObject.h"
#import "ITSSearchQueryCellObject.h"
#import "ITSITSTrackCell.h"

const CGFloat kSearchQueryRowHeight = 44.0f;


@interface ITSSearchTrackViewController () <UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property(nonatomic, strong) UISearchController *searchController;

@property(nonatomic, strong) NSMutableArray *queryCells;
@property(nonatomic, strong) NSMutableArray *trackCells;

@end


@implementation ITSSearchTrackViewController

#pragma mark - UIViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		_queryCells = [NSMutableArray array];
		_trackCells = [NSMutableArray array];
	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Search controller
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.definesPresentationContext = YES;
	self.searchController.hidesNavigationBarDuringPresentation = YES;
	self.searchController.searchBar.delegate = self;
	self.tableView.tableHeaderView = self.searchController.searchBar;

	// Table View Controller
	self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self.output viewWillAppear];
}


#pragma mark - ViewInput

- (void)setRecentQueries:(NSArray<ITSSearchQueryObject *> *)recentQueries {
	self.queryCells = [NSMutableArray array];
	for (ITSSearchQueryObject *queryObject in recentQueries) {
		[self.queryCells addObject:[[ITSSearchQueryCellObject alloc] initWithQueryObject:queryObject]];
	}

	if (self.searchController.isActive) {
		[self.tableView reloadData];
	}
}

- (void)setTracks:(NSArray<ITSTrackObject *> *)tracks {
	self.trackCells = [NSMutableArray array];
	for (ITSTrackObject *trackObject in tracks) {
		[self.trackCells addObject:[[ITSTrackCellObject alloc] initWithTrackObject:trackObject
																		  forSacle:[[UIScreen mainScreen] scale]]];
	}

	if (!self.searchController.isActive) {
		[self.tableView reloadData];
	}
}


- (void)setSearchActive:(BOOL)active {
	self.searchController.active = active;
	[self.tableView reloadData];
}

- (void)setSearchText:(NSString *)text {
	self.searchController.searchBar.text = text;
}

- (void)beginUpdates {
	[self.tableView beginUpdates];
}

- (void)insertTrack:(ITSTrackObject *)trackObject atIndex:(NSUInteger)index {

	ITSTrackCellObject *cellObject = [[ITSTrackCellObject alloc] initWithTrackObject:trackObject
																			forSacle:[[UIScreen mainScreen] scale]];

	if (index >= self.trackCells.count) {
		[self.trackCells addObject:cellObject];
	} else {
		[self.trackCells insertObject:cellObject
							  atIndex:index];
	}

	if (!self.searchController.isActive) {
		[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
							  withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

- (void)deleteTrackAtIndex:(NSUInteger)index {

	[self.trackCells removeObjectAtIndex:index];

	if (!self.searchController.isActive) {
		[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
							  withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

- (void)updateTrack:(ITSTrackObject *)trackObject atIndex:(NSUInteger)index {

	self.trackCells[index] = [[ITSTrackCellObject alloc] initWithTrackObject:trackObject
																	forSacle:[[UIScreen mainScreen] scale]];

	if (!self.searchController.isActive) {
		[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
							  withRowAnimation:UITableViewRowAnimationNone];
	}
}

- (void)endUpdates {
	[self.tableView endUpdates];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.searchController.isActive) {
		return self.queryCells.count;
	} else {
		return self.trackCells.count;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.searchController.isActive) {
		return kSearchQueryRowHeight;
	}

	ITSTrackCellObject *cellObject = self.trackCells[(NSUInteger) indexPath.row];

	return [ITSITSTrackCell heightWithCellObject:cellObject tableView:tableView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell;

	if (self.searchController.isActive) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"SearchQuery" forIndexPath:indexPath];

		ITSSearchQueryCellObject *cellObject = self.queryCells[(NSUInteger) indexPath.row];

		cell.textLabel.text = cellObject.title;

	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"Entity" forIndexPath:indexPath];

		ITSTrackCellObject *cellObject = self.trackCells[(NSUInteger) indexPath.row];

		[(ITSITSTrackCell *) cell configureWithCellObject:cellObject];
	}

	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.searchController.isActive) {
		[self.output didSelectQueryAtIndex:(NSUInteger) indexPath.row];
	} else {
		[self.output didSelectTrackAtIndex:(NSUInteger) indexPath.row];
	}
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	[self.output didChangeSearchTerm:searchController.searchBar.text];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.output didSearchButtonTouchWithTerm:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self.tableView reloadData];
}

@end

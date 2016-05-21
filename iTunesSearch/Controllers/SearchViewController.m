//
//  SearchViewController.m
//  iTunesSearch
//
//  Created by Farid on 21.05.16.
//  Copyright © 2016 Farid. All rights reserved.
//

#import "SearchViewController.h"
#import "Manager.h"
#import "SearchQuery+CoreDataProperties.h"
#import "ITunesEntity.h"
#import "UIImageView+AFNetworking.h"
#import "NSParagraphStyle+ByWordWrapping.h"
#import "TrackDetailsViewController.h"

@interface SearchViewController () <UISearchResultsUpdating, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@end


@implementation SearchViewController {
	__weak Manager *_manager;

	UISearchController *_searchController;
	NSArray *_recentQueries;
	SearchQuery *_searchQuery;
	NSFetchedResultsController *_fetchedResultsController;
}

- (void)searchTerm:(NSString *)term {
	_searchQuery = [_manager.queries queryWithTerm:term];
	[self search];
}

- (void)search {
	if (!_searchQuery) {
		return;
	}
	_searchController.active = NO;
	_fetchedResultsController = nil;

	[_manager.tracks searchTrackWithQuery:_searchQuery];

	[self.tableView reloadData];
}

- (NSString *)detailsTextForEntity:(ITunesEntity *)entity {
	NSString *artistName = entity.artistName.length > 0 ? entity.artistName : @"Неизвестый артист";
	NSString *collectionName = entity.collectionName.length > 0 ? entity.collectionName : @"Неизвестый альбом";
	return [NSString stringWithFormat:@"%@ – %@", artistName, collectionName];
}

- (NSURL *)artworkImageUrlForEntity:(ITunesEntity *)entity {
	CGFloat size;
	if ([[UIScreen mainScreen] scale] >= 3) {
		size = 180;
	} else if ([[UIScreen mainScreen] scale] == 2) {
		size = 120;
	} else {
		size = 60;
	}
	NSURL *result = nil;
	if (entity.artworkUrl100.length > 0) {
		result = [NSURL URLWithString:[entity.artworkUrl100 stringByReplacingOccurrencesOfString:@"100x100" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	} else if (entity.artworkUrl60.length > 0) {
		result = [NSURL URLWithString:[entity.artworkUrl60 stringByReplacingOccurrencesOfString:@"60x60" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	}
	return result;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	_manager = [Manager sharedManager];

	// Search controller
	_searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	_searchController.searchResultsUpdater = self;
	_searchController.dimsBackgroundDuringPresentation = NO;
	_searchController.definesPresentationContext = YES;
	_searchController.hidesNavigationBarDuringPresentation = YES;
	_searchController.searchBar.delegate = self;
	self.tableView.tableHeaderView = _searchController.searchBar;

	// Table View Controller
	self.tableView.tableFooterView = [UIView new];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	ITunesEntity *entity = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
	TrackDetailsViewController *trackDetailsViewController = segue.destinationViewController;
	trackDetailsViewController.entity = entity;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (_searchController.isActive) {
		return _recentQueries.count;
	} else {
		return self.fetchedResultsController.fetchedObjects.count;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_searchController.isActive) {
		return 44.0;
	}

	ITunesEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];

	CGSize maxSize = CGSizeMake(tableView.frame.size.width - 16 - 60 - 8, CGFLOAT_MAX);

	CGSize trackNameSize = [entity.trackName boundingRectWithSize:maxSize
														  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
													   attributes:@{
															   NSFontAttributeName           : [UIFont systemFontOfSize:17],
															   NSParagraphStyleAttributeName : [NSParagraphStyle paragraphStyleWithByWordWrapping]
													   } context:nil].size;
	CGSize detailsSize = [[self detailsTextForEntity:entity] boundingRectWithSize:maxSize
																		  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
																	   attributes:@{
																			   NSFontAttributeName           : [UIFont systemFontOfSize:15],
																			   NSParagraphStyleAttributeName : [NSParagraphStyle paragraphStyleWithByWordWrapping]
																	   } context:nil].size;

	return MAX(10 + 60 + 10, 10 + trackNameSize.height + 4 + detailsSize.height + 10);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	if (_searchController.isActive) {
		SearchQuery *searchQuery = _recentQueries[(NSUInteger) indexPath.row];
		cell = [tableView dequeueReusableCellWithIdentifier:@"SearchQuery" forIndexPath:indexPath];
		cell.textLabel.text = searchQuery.term;
	} else {

		cell = [tableView dequeueReusableCellWithIdentifier:@"Entity" forIndexPath:indexPath];

		UIImageView *artWorkView = [cell.contentView viewWithTag:1];
		UILabel *trackTitleLabel = [cell.contentView viewWithTag:2];
		UILabel *trackDetailsLabel = [cell.contentView viewWithTag:3];

		ITunesEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];

		// ArtWork
		NSURL *artWorkUrl = [self artworkImageUrlForEntity:entity];
		if (artWorkUrl) {
			NSMutableURLRequest *artWorkRequest = [NSMutableURLRequest requestWithURL:artWorkUrl];
			[artWorkRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
			artWorkView.alpha = 0;
			artWorkView.hidden = NO;
			__weak UIImageView *weakArtWorkView = artWorkView;
			[artWorkView setImageWithURLRequest:artWorkRequest
							   placeholderImage:nil
										success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
											weakArtWorkView.image = image;
											[UIView animateWithDuration:0.2 animations:^{
												weakArtWorkView.alpha = 1;
											}];
										}
										failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
											weakArtWorkView.hidden = YES;
										}];
		}

		// Track title
		trackTitleLabel.text = entity.trackName;

		// Details text
		trackDetailsLabel.text = [self detailsTextForEntity:entity];
	}

	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (_searchController.isActive) {
		_searchQuery = _recentQueries[(NSUInteger) indexPath.row];
		_searchController.searchBar.text = _searchQuery.term;
		[self search];
	} else {

	}
}


#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
	if (!_fetchedResultsController) {
		if (_searchQuery) {
			NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ITunesEntity"];
			request.predicate = [NSPredicate predicateWithFormat:@"searchQueries CONTAINS %@", _searchQuery];
			request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"trackName" ascending:YES]];
			request.fetchBatchSize = 50;

			_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																			managedObjectContext:_manager.managedObjectContext
																			  sectionNameKeyPath:nil
																					   cacheName:nil];
			_fetchedResultsController.delegate = self;
			[_fetchedResultsController performFetch:nil];
		}
	} else if (!_searchQuery) {
		_fetchedResultsController = nil;
	}
	return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeMove:
			break;
		case NSFetchedResultsChangeUpdate:
			[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	_recentQueries = [_manager.queries recentQueriesWithTerm:searchController.searchBar.text];
	[self.tableView reloadData];
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self searchTerm:searchBar.text];
}

@end

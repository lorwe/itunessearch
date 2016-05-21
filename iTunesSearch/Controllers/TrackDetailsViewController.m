//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TrackDetailsViewController.h"
#import "ITunesEntity.h"


@implementation TrackDetailsViewController


- (NSURL *)artworkImageUrlForEntity:(ITunesEntity *)entity {
	CGFloat size;
	if ([[UIScreen mainScreen] scale] >= 3) {
		size = self.view.frame.size.width * 3;
	} else if ([[UIScreen mainScreen] scale] == 2) {
		size = self.view.frame.size.width * 2;
	} else {
		size = self.view.frame.size.width;
	}
	NSURL *result = nil;
	if (entity.artworkUrl100.length > 0) {
		result = [NSURL URLWithString:[entity.artworkUrl100 stringByReplacingOccurrencesOfString:@"100x100" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	} else if (entity.artworkUrl60.length > 0) {
		result = [NSURL URLWithString:[entity.artworkUrl60 stringByReplacingOccurrencesOfString:@"60x60" withString:[NSString stringWithFormat:@"%.0fx%.0f", size, size]]];
	}
	return result;
}

- (void)showEntity {
	self.lblTitle.text = _entity.trackName;
	self.lblArtist.text = _entity.artistName;
	self.lblAlbum.text = _entity.collectionName;
	self.lblGenre.text = _entity.primaryGenreName;

	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.dateFormat = @"dd/MM/yyyy";
	self.lblReleaseDate.text = [dateFormatter stringFromDate:_entity.releaseDate];

	NSURL *artWorkUrl = [self artworkImageUrlForEntity:_entity];
	if (artWorkUrl) {
		NSMutableURLRequest *artWorkRequest = [NSMutableURLRequest requestWithURL:artWorkUrl];
		[artWorkRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
		self.imgArtWork.alpha = 0;
		self.imgArtWork.hidden = NO;
		__weak UIImageView *weakArtWorkView = self.imgArtWork;
		__weak UITableView *tableView = self.tableView;
		[self.imgArtWork setImageWithURLRequest:artWorkRequest
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
}


#pragma mark - Properties

- (void)setEntity:(ITunesEntity *)entity {
	_entity = entity;
	[self showEntity];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.tableFooterView = [UIView new];

	[self showEntity];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return MIN (self.view.frame.size.width, self.view.frame.size.height);
	}
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat translation = (scrollView.contentInset.top + scrollView.contentOffset.y) / 2;
	self.imgArtWork.transform = CGAffineTransformMakeTranslation(0, MAX(translation, 0));
}

@end
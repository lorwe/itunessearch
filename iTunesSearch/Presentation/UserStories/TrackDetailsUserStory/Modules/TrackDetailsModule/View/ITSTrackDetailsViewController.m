//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ITSTrackDetailsViewController.h"


@implementation ITSTrackDetailsViewController


#pragma mark - ViewInput

- (void)setTitle:(NSString *)title {
	self.lblTitle.text = title;
}

- (void)setArtist:(NSString *)artist {
	self.lblArtist.text = artist;
}

- (void)setAlbumTitle:(NSString *)albumTitle {
	self.lblAlbum.text = albumTitle;
}

- (void)setGenre:(NSString *)genre {
	self.lblGenre.text = genre;
}

- (void)setArtworkImageURL:(NSURL *)url {
	if (url) {
		NSMutableURLRequest *artWorkRequest = [NSMutableURLRequest requestWithURL:url];
		[artWorkRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
		self.imgArtWork.alpha = 0;
		self.imgArtWork.hidden = NO;
		__weak UIImageView *weakArtWorkView = self.imgArtWork;
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
	} else {
		self.imgArtWork.image = nil;
	}
}

- (void)setReleaseDateText:(NSString *)releaseDate {
	self.lblReleaseDate.text = releaseDate;
}

- (CGFloat)width {
	return self.view.frame.size.width;
}

- (CGFloat)scale {
	return [[UIScreen mainScreen] scale];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.tableFooterView = [UIView new];
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
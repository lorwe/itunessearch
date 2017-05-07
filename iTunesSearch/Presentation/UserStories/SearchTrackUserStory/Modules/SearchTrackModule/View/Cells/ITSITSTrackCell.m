//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <AFNetworking/UIKit+AFNetworking.h>
#import "ITSITSTrackCell.h"
#import "ITSTrackCellObject.h"
#import "NSParagraphStyle+ByWordWrapping.h"


@implementation ITSITSTrackCell

+ (CGFloat)heightWithCellObject:(ITSTrackCellObject *)cellObject tableView:(UITableView *)tableView {
	CGSize maxSize = CGSizeMake(tableView.frame.size.width - 16 - 60 - 8, CGFLOAT_MAX);

	CGSize trackNameSize = [cellObject.title boundingRectWithSize:maxSize
														  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
													   attributes:@{
															   NSFontAttributeName          : [UIFont systemFontOfSize:17],
															   NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithByWordWrapping]
													   } context:nil].size;
	CGSize detailsSize = [cellObject.details boundingRectWithSize:maxSize
														  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
													   attributes:@{
															   NSFontAttributeName          : [UIFont systemFontOfSize:15],
															   NSParagraphStyleAttributeName: [NSParagraphStyle paragraphStyleWithByWordWrapping]
													   } context:nil].size;

	return MAX(10 + 60 + 10, 10 + trackNameSize.height + 4 + detailsSize.height + 10);
}

- (void)configureWithCellObject:(ITSTrackCellObject *)cellObject {
	self.trackTitleLabel.text = cellObject.title;
	self.trackDetailsLabel.text = cellObject.details;

	if (cellObject.imageURL) {
		NSMutableURLRequest *artWorkRequest = [NSMutableURLRequest requestWithURL:cellObject.imageURL];
		[artWorkRequest addValue:@"image/*" forHTTPHeaderField:@"Accept"];
		self.artWorkView.alpha = 0;
		self.artWorkView.hidden = NO;

		__weak UIImageView *weakArtWorkView = self.artWorkView;
		[self.artWorkView setImageWithURLRequest:artWorkRequest
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
		self.artWorkView.image = nil;
	}
}

@end
//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITSTrackCellObject;


@interface ITSITSTrackCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *artWorkView;
@property(nonatomic, weak) IBOutlet UILabel *trackTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *trackDetailsLabel;

+ (CGFloat)heightWithCellObject:(ITSTrackCellObject *)cellObject tableView:(UITableView *)tableView;

- (void)configureWithCellObject:(ITSTrackCellObject *)cellObject;

@end
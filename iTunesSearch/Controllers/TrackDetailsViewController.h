//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ITunesEntity;


@interface TrackDetailsViewController : UITableViewController

@property(nonatomic, strong) ITunesEntity *entity;

@property(nonatomic, strong) IBOutlet UILabel *lblTitle;
@property(nonatomic, strong) IBOutlet UILabel *lblArtist;
@property(nonatomic, strong) IBOutlet UILabel *lblAlbum;
@property(nonatomic, strong) IBOutlet UILabel *lblGenre;
@property(nonatomic, strong) IBOutlet UILabel *lblReleaseDate;
@property(nonatomic, strong) IBOutlet UIImageView *imgArtWork;

@end
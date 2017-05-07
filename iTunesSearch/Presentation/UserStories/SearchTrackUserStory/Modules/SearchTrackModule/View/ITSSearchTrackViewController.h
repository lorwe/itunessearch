//
//  ITSSearchTrackViewController.h
//  iTunesSearch
//
//  Created by Farid on 21.05.16.
//  Copyright © 2016 Farid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITSSearchTrackViewInput.h"

extern const CGFloat kSearchQueryRowHeight;

@protocol ITSSearchTrackViewOutput;


@interface ITSSearchTrackViewController : UITableViewController <ITSSearchTrackViewInput>

@property(nonatomic, strong) id <ITSSearchTrackViewOutput> output;

@end


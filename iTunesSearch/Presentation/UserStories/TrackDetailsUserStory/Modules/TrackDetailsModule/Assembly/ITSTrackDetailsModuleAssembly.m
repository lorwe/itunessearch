//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSTrackDetailsModuleAssembly.h"
#import "ITSTrackDetailsViewController.h"
#import "ITSTrackDetailsPresenter.h"


@implementation ITSTrackDetailsModuleAssembly {
	UIStoryboard *_storyboard;

	ITSTrackDetailsViewController *_view;
	ITSTrackDetailsPresenter *_presenter;
}


- (UIStoryboard *)storyboard {
	if (!_storyboard) {
		_storyboard = [UIStoryboard storyboardWithName:@"TrackDetails" bundle:nil];
	}
	return _storyboard;
}

- (ITSTrackDetailsViewController *)viewTrackDetails {
	if (!_view) {
		_view = [self.storyboard instantiateInitialViewController];
		_view.output = self.presenterTrackDetails;
	}
	return _view;
}

- (ITSTrackDetailsPresenter *)presenterTrackDetails {
	if (!_presenter) {
		_presenter = [[ITSTrackDetailsPresenter alloc] init];
		_presenter.view = self.viewTrackDetails;
	}
	return _presenter;
}

@end
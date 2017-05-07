//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSSearchTrackModuleAssembly.h"
#import "ITSSearchTrackViewController.h"
#import "ITSSearchTrackInteractor.h"
#import "ITSSearchTrackPresenter.h"
#import "ITSSearchTrackRouter.h"
#import "ITSServiceComponents.h"


@implementation ITSSearchTrackModuleAssembly {
	UIStoryboard *_storyboard;

	ITSSearchTrackViewController *_view;
	ITSSearchTrackInteractor *_interactor;
	ITSSearchTrackPresenter *_presenter;
	ITSSearchTrackRouter *_router;

	UINavigationController *_navigationController;
}

- (UIStoryboard *)storyboard {
	if (!_storyboard) {
		_storyboard = [UIStoryboard storyboardWithName:@"SearchTrack" bundle:nil];
	}
	return _storyboard;
}

- (ITSSearchTrackViewController *)viewSearchTrack {
	if (!_view) {
		_navigationController = [self.storyboard instantiateInitialViewController];
		_view = (ITSSearchTrackViewController *) [_navigationController topViewController];
		_view.output = self.presenterSearchTrack;
	}
	return _view;
}

- (ITSSearchTrackInteractor *)interactorSearchTrack {
	if (!_interactor) {
		_interactor = [[ITSSearchTrackInteractor alloc] init];
		_interactor.searchService = [self.serviceComponents iTunesSearchService];
		_interactor.output = self.presenterSearchTrack;
	}
	return _interactor;
}

- (ITSSearchTrackPresenter *)presenterSearchTrack {
	if (!_presenter) {
		_presenter = [[ITSSearchTrackPresenter alloc] init];
		_presenter.view = self.viewSearchTrack;
		_presenter.interactor = self.interactorSearchTrack;
		_presenter.router = self.routerSearchTrack;
	}
	return _presenter;
}

- (ITSSearchTrackRouter *)routerSearchTrack {
	if (!_router) {
		_router = [[ITSSearchTrackRouter alloc] init];
		_router.transitionCoordinator = self.viewSearchTrack;
	}
	return _router;
}

@end
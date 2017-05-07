//
// Created by Farid on 07.05.17.
// Copyright (c) 2017 Farid. All rights reserved.
//

#import "ITSSearchTrackRouter.h"
#import "ITSTrackObject.h"
#import "ITSTrackDetailsModuleAssembly.h"
#import "ITSTrackDetailsViewController.h"
#import "ITSTrackDetailsModuleInput.h"


@implementation ITSSearchTrackRouter

- (void)openTrackDetailsModuleWithTrackObject:(ITSTrackObject *)trackObject {
	ITSTrackDetailsModuleAssembly *moduleAssembly = [[ITSTrackDetailsModuleAssembly alloc] init];

	ITSTrackDetailsViewController *view = moduleAssembly.viewTrackDetails;
	[self.transitionCoordinator.navigationController pushViewController:view
															   animated:YES];

	dispatch_async(dispatch_get_main_queue(), ^{
		id<ITSTrackDetailsModuleInput> moduleInput = (id <ITSTrackDetailsModuleInput>) view.output;
		[moduleInput configureWithTrack:trackObject];
	});
}

@end
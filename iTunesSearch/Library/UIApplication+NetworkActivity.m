/**
 * UIApplication+NetworkActivity.m
 *
 * Created by Farid on 15.04.13.
 * Copyright (c) 2013 Rugion. All rights reserved.
 */

@implementation UIApplication (NetworkActivity)

- (void)setNetworkActivity:(BOOL)networkActivity {
	static NSInteger activitiesCount = 0;
	if (networkActivity) {
		activitiesCount++;
	} else {
		activitiesCount--;
		if (activitiesCount < 0) {
			activitiesCount = 0;
		}
	}
	[self setNetworkActivityIndicatorVisible:(activitiesCount > 0)];
}

@end

/**
 * UIApplication+NetworkActivity.h
 *
 * Created by Farid on 15.04.13.
 * Copyright (c) 2013 Rugion. All rights reserved.
 */

@interface UIApplication (NetworkActivity)

/*!
	Управление индикатором сетевой активности
	@param networkActivity Флаг активности
 */
- (void)setNetworkActivity:(BOOL)networkActivity;

@end

//
// Created by Farid on 21.05.16.
// Copyright (c) 2016 Farid. All rights reserved.
//

#import "NSParagraphStyle+ByWordWrapping.h"


@implementation NSParagraphStyle (ByWordWrapping)

+ (NSParagraphStyle *)paragraphStyleWithByWordWrapping {
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	return paragraphStyle;
}

@end
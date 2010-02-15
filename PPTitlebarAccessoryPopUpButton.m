//
//  PPTitlebarAccessoryPopUpButton.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPTitlebarAccessoryPopUpButton.h"


@implementation PPTitlebarAccessoryPopUpButton

-(void)drawRect:(NSRect)rect{
	NSLog(@"Whee drawing pop up - %@", [[self selectedItem] title]);
	[super drawRect:rect];
}

@end

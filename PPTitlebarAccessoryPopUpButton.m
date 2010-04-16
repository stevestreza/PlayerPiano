//
//  PPTitlebarAccessoryPopUpButton.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/LICENSE.md
//

#import "PPTitlebarAccessoryPopUpButton.h"


@implementation PPTitlebarAccessoryPopUpButton

-(void)drawRect:(NSRect)rect{
	NSLog(@"Whee drawing pop up - %@", [[self selectedItem] title]);
	[super drawRect:rect];
}

@end

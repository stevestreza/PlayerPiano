//
//  PPITunesButtonCell.m
//  PlayerPiano
//
//  Created by Matt Ball on 5/12/10.
//  Copyright 2010.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PPITunesButtonCell.h"


@implementation PPITunesButtonCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSColor *color = [NSColor colorWithCalibratedWhite:1.0f alpha:0.6f];
	if ([self isHighlighted]) {
		color = [NSColor colorWithCalibratedWhite:1.0f alpha:0.8f];
	}
	
	NSImage *image = [[NSImage alloc] initWithSize:cellFrame.size];
	[image lockFocus];
	[color set];
	NSRectFill(NSMakeRect(0,0,cellFrame.size.width,cellFrame.size.height));
	[[NSImage imageNamed:@"NSFollowLinkFreestandingTemplate"] drawInRect:NSMakeRect(0,0,cellFrame.size.width,cellFrame.size.height) fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1.0];
	
	[image unlockFocus];
	[image drawInRect:cellFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	[image release];
}

@end

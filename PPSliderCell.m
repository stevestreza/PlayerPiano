//
//  PPSliderCell.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/15/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PPSliderCell.h"

@implementation PPSliderCell

- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped
{
	NSRect trackRect = aRect;
	trackRect.size.height = 3.0f;
	trackRect.origin.x += 1.0f;
	trackRect.size.width -= 2.0f;
	trackRect.origin.y = aRect.origin.y + (aRect.size.height - trackRect.size.height)/2.0f;
	
	NSBezierPath *insetPath = [NSBezierPath bezierPathWithRoundedRect:NSOffsetRect(trackRect, 0, 1.0f) xRadius:trackRect.size.height/2.0f yRadius:trackRect.size.height/2.0f];
	[[NSColor colorWithCalibratedWhite:0.6f alpha:0.6f] set];
	[insetPath setLineWidth:2.0f];
	[insetPath stroke];
	
	NSBezierPath *trackPath = [NSBezierPath bezierPathWithRoundedRect:trackRect xRadius:trackRect.size.height/2.0f yRadius:trackRect.size.height/2.0f];
	[[NSColor colorWithCalibratedWhite:0.278f alpha:1.0f] set];
	[trackPath setLineWidth:2.0f];
	[trackPath stroke];
	NSGradient *trackGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.4f alpha:1.0f] endingColor:[NSColor colorWithCalibratedWhite:0.514f alpha:1.0f]];
	[trackGradient drawInBezierPath:trackPath angle:90.0f];
	[trackGradient release];
}

-(void)drawKnob:(NSRect)knobRect{
	NSRect circleRect = NSInsetRect(knobRect, 2.0f, 2.0f);
	
	NSBezierPath *shadowPath = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(knobRect, 1.0f, 1.0f)];
	[[NSColor colorWithCalibratedWhite:0.1f alpha:0.4f] set];
	[shadowPath fill];
	
	NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:circleRect];
	NSGradient *bgGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.541 alpha:1.0]];
	[bgGradient drawInBezierPath:path angle:90.0f];
	
	// Draw the dimple
	NSRect thumbRect = NSMakeRect(0,0,4.0f,4.0f);
	thumbRect.origin.x = circleRect.origin.x + (circleRect.size.width - thumbRect.size.width)/2.0f;
	thumbRect.origin.y = circleRect.origin.y + (circleRect.size.height - thumbRect.size.height)/2.0f;
	
	NSBezierPath *thumbInsetPath = [NSBezierPath bezierPathWithOvalInRect:NSOffsetRect(thumbRect, 0, 1.0f)];
	[[NSColor whiteColor] set];
	[thumbInsetPath fill];
	
	NSBezierPath *thumbPath = [NSBezierPath bezierPathWithOvalInRect:thumbRect];
	NSGradient *thumbGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.247 alpha:1.0] endingColor:[NSColor colorWithCalibratedWhite:0.459 alpha:1.0]];
	[thumbGradient drawInBezierPath:thumbPath angle:90.0f];
}

@end

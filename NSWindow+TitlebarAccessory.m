//
//  NSWindow+TitlebarAccessory.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 Villainware. All rights reserved.
//

#import "NSWindow+TitlebarAccessory.h"
#import <objc/runtime.h>

#define kPPNSWindowTitlebarAccessoryAssociatedObjectKey @"com.villainware.playerpiano.nswindow.titlebarAccessoryView"

@implementation NSWindow (TitlebarAccessory)

-(NSView *)PP_themeFrame{
	return [[self contentView] superview];
}

-(void)PP_setTitlebarAccessoryView:(NSView *)accessoryView{
	NSView *themeFrame = [self PP_themeFrame];
	NSView *oldAccessoryView = [self PP_titlebarAccessoryView];
	
	NSRect c = [themeFrame frame];  // c for "container"
	NSRect aV = [accessoryView frame];      // aV for "accessory view"
	NSRect newFrame = NSMakeRect(
								 c.size.width - aV.size.width,   // x position
								 c.size.height - aV.size.height, // y position
								 aV.size.width,  // width
								 aV.size.height);        // height
	[accessoryView setFrame:newFrame];	
	[accessoryView setAutoresizingMask:NSViewMaxYMargin | NSViewMinXMargin];
	
	[self willChangeValueForKey:@"PP_titlebarAccessoryView"];
	
	objc_setAssociatedObject(self, kPPNSWindowTitlebarAccessoryAssociatedObjectKey, accessoryView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	[oldAccessoryView removeFromSuperview];
	[themeFrame addSubview:accessoryView];
	
	[self  didChangeValueForKey:@"PP_titlebarAccessoryView"];
}

-(NSView *)PP_titlebarAccessoryView{
	NSView *view = objc_getAssociatedObject(self, kPPNSWindowTitlebarAccessoryAssociatedObjectKey);
	return view;
}

@end

//
//  PPStyleView.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PPStyleView.h"

@interface PPStyleView (Private)

-(void)_awake;

@end



@implementation PPStyleView

@synthesize styleName, styleSheet;

-(id)initWithCoder:(NSCoder *)aDecoder{
	if(self = [super initWithCoder:aDecoder]){
		[self _awake];
	}
	return self;
}

-(id)initWithFrame:(NSRect)frameRect{
	if(self = [super initWithFrame:frameRect]){
		[self _awake];
	}
	return self;
}

-(BOOL)isFlipped{
	return YES;
}

-(void)_awake{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:VSStyleSheetChangedNotification object:nil];
}

-(void)setNeedsDisplay{
	[self setNeedsDisplay:YES];
}

-(void)setStyleName:(NSString *)name{
	[self willChangeValueForKey:@"styleName"];
	[styleName autorelease];
	styleName = [name copy];
	[self  didChangeValueForKey:@"styleName"];
	
	[self setNeedsDisplay];
}

-(void)setStyleSheet:(VSStyleSheet *)sheet{
	[self willChangeValueForKey:@"styleSheet"];
	[styleSheet autorelease];
	styleSheet = [sheet retain];
	[self  didChangeValueForKey:@"styleSheet"];
	
	[self setNeedsDisplay];
}

-(void)viewWillMoveToWindow:(NSWindow *)window{
	if([self window]){
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResignMainNotification object:[self window]];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidBecomeMainNotification object:[self window]];
	}
	
	if(window){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:NSWindowDidResignMainNotification object:window];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:NSWindowDidBecomeMainNotification object:window];
	}
}

-(void)drawRect:(NSRect)dirtyRect{
	VSStyleSheet *sheet = self.styleSheet;
	if(!sheet) sheet = [VSStyleSheet globalStyleSheet];
	
	NSString *name = self.styleName;
	if(![[self window] isMainWindow]){
		name = [name stringByAppendingString:@"Inactive"];
	}
	
	VSStyle *style = [sheet styleWithSelector:name];
	
	VSStyleContext *context = [[[VSStyleContext alloc] init] autorelease];
	context.frame = self.bounds;
	context.contentFrame = self.bounds;
	
	[style draw:context];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:VSStyleSheetChangedNotification object:nil];
	
	[styleName release], styleName = nil;
	[styleSheet release], styleSheet = nil;
	
	[super dealloc];
}

@end

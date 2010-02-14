//
//  PPStyleView.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPStyleView.h"

@interface PPStyleView (Private)

-(void)_awake;

@end



@implementation PPStyleView

@synthesize styleName, styleSheet;

//-(void)initWithCoder:(NSCoder *)aDecoder{
//	if(self = [super initWithCoder:aDecoder]){
//		[self _awake];
//	}
//	return self;
//}

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

-(void)drawRect:(NSRect)dirtyRect{
	VSStyleSheet *sheet = self.styleSheet;
	if(!sheet) sheet = [VSStyleSheet globalStyleSheet];
	
	VSStyle *style = [sheet styleWithSelector:self.styleName];
	
	VSStyleContext *context = [[[VSStyleContext alloc] init] autorelease];
	context.frame = self.bounds;
	
	[style draw:context];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:VSStyleSheetChangedNotification object:nil];
	
	[styleName release], styleName = nil;
	[styleSheet release], styleSheet = nil;
	
	[super dealloc];
}

@end

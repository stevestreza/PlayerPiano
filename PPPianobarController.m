//
//  PPPianobarController.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPPianobarController.h"


@implementation PPPianobarController

@synthesize delegate;

-(id)init{
	if(self = [super init]){
		[self setupTask];
	}
	return self;
}

-(void)dealloc{
	[pianobarTask terminate];
	[pianobarTask release];
	pianobarTask = nil;
	
	[super dealloc];
}

-(void)setupTask{
	pianobarTask = [[NSTask alloc] init];
	[pianobarTask setLaunchPath:[[NSBundle mainBundle] pathForResource:@"pianobar" ofType:nil]];
	
	NSPipe *pipe = [NSPipe pipe];
	[pianobarTask setStandardOutput:pipe];
	pianobarReadHandle = [[pipe fileHandleForReading] retain];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleDataAvailableNotification object:pianobarReadHandle];
	
	pipe = [NSPipe pipe];
	[pianobarTask setStandardInput:pipe];
	pianobarWriteHandle = [[pipe fileHandleForWriting] retain];
}

-(void)start{
	[pianobarTask launch];
	[pianobarReadHandle waitForDataInBackgroundAndNotify];
}

-(void)dataAvailable:(NSNotification *)notif{
	NSData *data = [pianobarReadHandle availableData];
	NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"Data available! \n%@\n%@", dataString, data);
	
	[pianobarReadHandle waitForDataInBackgroundAndNotify];
}

@end

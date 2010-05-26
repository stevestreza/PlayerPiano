//
//  PPTempFileWriter.m
//  PlayerPiano
//
//  Created by Steve Streza on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPTempFileWriter.h"
#import <PianoBar/PPPianobarController.h>
#import <PianoBar/PPTrack.h>


@implementation PPTempFileWriter

@synthesize path=_path;

-(id)init{
	if(self = [super init]){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFile:) name:PPPianobarControllerDidBeginPlayingTrackNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFile:) name:NSApplicationWillTerminateNotification object:nil];
	}
	return self;
}

-(void)deleteFile:(NSNotification *)notification{
	if(self.path){
		[[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
	}
}

-(void)updateFile:(NSNotification *)notification{
	if(self.path){
		PPTrack *track = [[notification userInfo] objectForKey:@"track"];
		NSString *content = [NSString stringWithFormat:@"%@\t%@\t%@\n",[track title], [track artist], [track album]];
		
		[[NSFileManager defaultManager] createFileAtPath:_path contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
	}
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:PPPianobarControllerDidBeginPlayingTrackNotification object:nil];
	[_path release], _path = nil;
	
	[super dealloc];
}

@end

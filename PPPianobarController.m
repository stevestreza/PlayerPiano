//
//  PPPianobarController.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPPianobarController.h"


@implementation PPPianobarController

@synthesize delegate, stations, selectedStation, nowPlaying;

-(id)initWithUsername:(NSString *)aUsername password:(NSString *)aPassword{
	if(self = [super init]){
		username = [aUsername copy];
		password = [aPassword copy];
		
		stations = [[NSMutableArray array] retain];
		
		[self setupTask];
	}
	return self;
}

-(void)dealloc{
	[pianobarTask terminate];
	[pianobarTask release];
	pianobarTask = nil;
	
	[username release], username = nil;
	[password release], password = nil;
	
	[super dealloc];
}

-(void)setupParsers{
	pianobarParser = [[PPLineParser alloc] init];
	stationParser = [[PPLineParser alloc] init];
	playbackParser = [[PPLineParser alloc] init];
	
	[stationParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return YES;
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		NSDictionary *station = [NSDictionary dictionaryWithObjectsAndKeys:
								 [line substringFromIndex: 15], @"name",
								 [NSNumber numberWithInt:[[line substringToIndex:9] intValue]], @"id",
								 nil];
		
		[self willChangeValueForKey:@"stations"];
		[(NSMutableArray *)stations addObject:station];
		[self  didChangeValueForKey:@"stations"];
		
		// if this is the last line, and there is an input waiting
		if(![pianobarReadLineBuffer bufferHasUnprocessedLines] && [[pianobarReadLineBuffer bufferContents] rangeOfString:@"[?]"].location != NSNotFound){
			NSLog(@"Done with stations, yo %@", stations);
			pianobarReadLineBuffer.target = pianobarParser;
			
//			[self writeStringToPianobar:@"2\n"];
		}
	} copy] autorelease]]];
	
	// detect "Welcome to pianobar", send username
	[pianobarParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"Welcome to pianobar!"].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		[self writeStringToPianobar:[username stringByAppendingString:@"\n"]];
	} copy] autorelease]]];
	
	// detect username, send password
	[pianobarParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"[?] Username: "].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		[self writeStringToPianobar:[password stringByAppendingString:@"\n"]];
	} copy] autorelease]]];
	
	// detect login error
	[pianobarParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"(i) Login... Error"].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		NSString *error = [line stringByReplacingOccurrencesOfString:@"(i) Login... Error: " withString:@""];
		NSLog(@"Could not login! %@",error);
	} copy] autorelease]]];
	
	// detect station selection
	[pianobarParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"[?] Select station: "].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		NSLog(@"Switching to playback mode");
		pianobarReadLineBuffer.target = playbackParser;
	} copy] autorelease]]];
	
	// detect playback station
	[playbackParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"|>  Station "].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		NSLog(@"Got station name from %@",[[line componentsSeparatedByString:@"\""] objectAtIndex:1]);
	} copy] autorelease]]];
	
	// detect playback song
	[playbackParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"|>  \""].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		NSArray *songComponents = [line componentsSeparatedByString:@"\""];
		NSString *songTitle = [songComponents objectAtIndex:1];
		NSString *songArtist = [songComponents objectAtIndex:3];
		NSString *songAlbum = [songComponents objectAtIndex:5];
		
		self.nowPlaying = [NSDictionary dictionaryWithObjectsAndKeys:
						   songTitle, @"songTitle",
						   songArtist, @"songArtist",
						   songAlbum, @"songAlbum",
						   nil];
		
		NSLog(@"Now playing! %@",self.nowPlaying);
	} copy] autorelease]]];
	
	// detect stations
	[pianobarParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"(i) Get stations... Ok."].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){
		pianobarReadLineBuffer.target = stationParser;
	} copy] autorelease]]];
	
}

-(void)playStationWithID:(NSString *)stationID{
	if([self isInPlaybackMode]){
		[self writeStringToPianobar:@"s]"];
	}
	
	[self writeStringToPianobar:stationID];
	[self writeStringToPianobar:@"\n"];
}

-(BOOL)isInPlaybackMode{
	return ([pianobarReadLineBuffer target] == playbackParser);
}

-(BOOL)isPaused{
	return [self isInPlaybackMode] && paused;
}

-(IBAction)thumbsUpCurrentSong:(id)sender{
	if([self isInPlaybackMode]){
		[self writeStringToPianobar:@"+"];
	}
}

-(IBAction)thumbsDownCurrentSong:(id)sender{
	if([self isInPlaybackMode]){
		[self writeStringToPianobar:@"-"];
	}
}

-(IBAction)playPauseCurrentSong:(id)sender{
	if([self isInPlaybackMode]){
		[self writeStringToPianobar:@"p"];		
	}
}

-(IBAction)playNextSong:(id)sender{
	if([self isInPlaybackMode]){
		[self writeStringToPianobar:@"n"];
	}
}	

-(void)writeStringToPianobar:(NSString *)string{
//	NSLog(@"Writing: %@",string);
	[pianobarWriteHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)setupTask{
	pianobarTask = [[NSTask alloc] init];
	[pianobarTask setLaunchPath:[[NSBundle mainBundle] pathForResource:@"pianobar" ofType:nil]];
	
	[self setupParsers];
	NSString *configPath = [self setupConfigFile];

	NSMutableDictionary *environment = [[[pianobarTask environment] mutableCopy] autorelease];
	if(!environment){
		environment = [NSMutableDictionary dictionary];
	}
	[environment setObject:[configPath stringByDeletingLastPathComponent] forKey:@"XDG_CONFIG_HOME"];
	NSLog(@"Environment: %@",environment);
	[pianobarTask setEnvironment:environment];
	
	NSPipe *pipe = [[NSPipe pipe] retain];
	[pianobarTask setStandardOutput:pipe];
	pianobarReadHandle = [[pipe fileHandleForReading] retain];
	
	pianobarReadLineBuffer = [[PPFileHandleLineBuffer alloc] initWithFileHandle:pianobarReadHandle];
	pianobarReadLineBuffer.target = pianobarParser;
	pianobarReadLineBuffer.action = @selector(parseLine:);
	
/*	pipe = [[NSPipe pipe] retain];
	[pianobarTask setStandardError:pipe];
	pianobarErrorHandle = [[pipe fileHandleForReading] retain];
	
	pianobarReadErrorBuffer = [[PPFileHandleLineBuffer alloc] initWithFileHandle:pianobarErrorHandle];
	pianobarReadErrorBuffer.target = pianobarParser;
	pianobarReadErrorBuffer.action = @selector(parseLine:);
*/	
	pipe = [[NSPipe pipe] retain];
	[pianobarTask setStandardInput:pipe];
	pianobarWriteHandle = [[pipe fileHandleForWriting] retain];
}

-(NSString *)setupConfigFile{
	NSString *configPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"config"];
	
	NSString *configContents = [NSString stringWithFormat:@"user = %@\npassword = %@\n",username, password];
	[[NSFileManager defaultManager] createFileAtPath:configPath contents:[configContents dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
	
	return configPath;
}

-(void)start{
	[pianobarTask launch];
}

@end

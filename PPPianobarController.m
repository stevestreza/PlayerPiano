//
//  PPPianobarController.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PPPianobarController.h"
#import "NSString+TimeParsing.h"

@implementation PPPianobarController

@synthesize delegate, stations, selectedStation, nowPlaying, paused;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
	if([key isEqualToString:@"paused"]){
		return [NSSet setWithObjects:
				@"isInPlaybackMode", @"isPlaying", @"isPaused",
				nil];
	}else if([key isEqualToString:@"nowPlaying"]){
		return [NSSet setWithObjects:
				@"nowPlayingAttributedDescription",
				nil];
	}else{
		return [super keyPathsForValuesAffectingValueForKey:key];
	}
}

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
//			NSLog(@"Done with stations, yo %@", stations);
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
	
		if([delegate respondsToSelector:@selector(pianobar:didBeginPlayingChannel:)]){
			NSString *channelName = [[line componentsSeparatedByString:@"\""] objectAtIndex:1];
			[delegate pianobar:self didBeginPlayingChannel:channelName];
		}

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
		
//		NSLog(@"Now playing! %@",self.nowPlaying);

	} copy] autorelease]]];
	
	// detect stations
	[pianobarParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"(i) Get stations... Ok."].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){

		pianobarReadLineBuffer.target = stationParser;

	} copy] autorelease]]];
	
	//detect playback state
	[playbackParser addLineRecognizer:[PPLineRecognizer recognizerWithRecognizerBlock:[[^BOOL(NSString *line){
		return ([line rangeOfString:@"#  "].location != NSNotFound);
	} copy] autorelease] performingActionBlock:[[^(NSString *line){

		NSArray *components = [[[line componentsSeparatedByString:@"-"] objectAtIndex:1] componentsSeparatedByString:@"/"];
		NSString *timeLeft  = [components objectAtIndex:0];
		NSString *timeTotal = [components objectAtIndex:1];
		
		NSTimeInterval timeLeftInterval  = [timeLeft  pp_timeIntervalValue];
		NSTimeInterval timeTotalInterval = [timeTotal pp_timeIntervalValue];
		
		NSMutableDictionary *dict = [[self.nowPlaying mutableCopy] autorelease];
		[dict setObject:[NSNumber numberWithDouble:timeTotalInterval-timeLeftInterval] forKey:@"timeSoFar"];
		[dict setObject:[NSNumber numberWithDouble:timeTotalInterval] forKey:@"timeTotal"];
		[dict setObject:[NSNumber numberWithDouble:timeLeftInterval ] forKey:@"timeLeft" ];
		self.nowPlaying = dict;
			
//		NSLog(@"Got %g seconds left", (timeLeftInterval));

	} copy] autorelease]]];
}

-(void)setNowPlaying:(NSDictionary *)aDict{
	[self willChangeValueForKey:@"nowPlaying"];
	[self willChangeValueForKey:@"nowPlayingAttributedDescription"];
	[nowPlaying autorelease];
	nowPlaying = [aDict copy];
	[self didChangeValueForKey:@"nowPlayingAttributedDescription"];
	[self didChangeValueForKey:@"nowPlaying"];
}

-(void)playStationWithID:(NSString *)stationID{
	if([self isInPlaybackMode]){
		[self writeStringToPianobar:@"s"];
	}
	
	[self writeStringToPianobar:stationID];
	[self writeStringToPianobar:@"\n"];
}

-(BOOL)isInPlaybackMode{
	return ([pianobarReadLineBuffer target] == playbackParser);
}

-(BOOL)isPlaying{
	return [self isInPlaybackMode] && !paused;
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
		
		[self willChangeValueForKey:@"isPlaying"];
		self.paused = !self.paused;
		[self  didChangeValueForKey:@"isPlaying"];
	}
}

-(IBAction)playNextSong:(id)sender{
	if([self isInPlaybackMode]){
		[self writeStringToPianobar:@"n"];
	}
}	

-(void)writeStringToPianobar:(NSString *)string{
	NSLog(@"Writing: %@",string);
	[pianobarWriteHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)setupTask{
	pianobarTask = [[NSTask alloc] init];
	[pianobarTask setLaunchPath:[[NSBundle mainBundle] pathForResource:@"pianobar" ofType:nil]];
	
	[self setupParsers];
	
	NSPipe *pipe = [[NSPipe pipe] retain];
	[pianobarTask setStandardOutput:pipe];
	pianobarReadHandle = [[pipe fileHandleForReading] retain];
	
	pianobarReadLineBuffer = [[PPFileHandleLineBuffer alloc] initWithFileHandle:pianobarReadHandle];
	pianobarReadLineBuffer.target = pianobarParser;
	pianobarReadLineBuffer.action = @selector(parseLine:);
	
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
	if(!pianobarTask){
		[self setupTask];
	}
	[pianobarTask launch];
}

-(void)stop{
	[pianobarTask terminate];
	[pianobarTask waitUntilExit];
	
	[pianobarTask release];
	pianobarTask = nil;
}

-(NSAttributedString *)nowPlayingAttributedDescription{
	NSMutableAttributedString *description = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
	NSDictionary *playing = self.nowPlaying;
	if(playing){
		NSFont *titleFont = [[NSFontManager sharedFontManager] convertFont: [NSFont fontWithName:@"Helvetica" size:18.0]
															   toHaveTrait:NSBoldFontMask];
		NSFont *restFont = [NSFont fontWithName:@"Helvetica Neue Light" size:16.0];
		
		NSColor *titleColor = [NSColor colorWithCalibratedWhite:0.8 alpha:1.0];
		NSColor *restColor  = [NSColor colorWithCalibratedWhite:0.6 alpha:1.0];
		
		NSAttributedString *newline = [[[NSAttributedString alloc] initWithString:@"\n"] autorelease];
		
		NSAttributedString *title = [[[NSAttributedString alloc] initWithString:[playing objectForKey:@"songTitle"]
																	 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																				 titleFont, NSFontAttributeName,
																				 titleColor, NSForegroundColorAttributeName,
																				 nil]] autorelease];
		NSAttributedString *artist = [[[NSAttributedString alloc] initWithString:[@"by " stringByAppendingString:[playing objectForKey:@"songArtist"]]
																	 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																				 restFont, NSFontAttributeName,
																				 restColor, NSForegroundColorAttributeName,
																				 nil]] autorelease];
		NSAttributedString *album = [[[NSAttributedString alloc] initWithString:[@"on " stringByAppendingString:[playing objectForKey:@"songAlbum"]]
																	 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																				 restFont, NSFontAttributeName,
																				 restColor, NSForegroundColorAttributeName,
																				 nil]] autorelease];
		[description appendAttributedString:title];
		[description appendAttributedString:newline];
		[description appendAttributedString:artist];
		[description appendAttributedString:newline];
		[description appendAttributedString:album];
	}
	
//	NSLog(@"Now playing attributed description! %@ -> %@",description, attributedDescription);
	
	return [[description copy] autorelease];
}

@end

//
//  PlayerPianoAppDelegate.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PlayerPianoAppDelegate.h"
#import "PPStyleSheet.h"
#import "NSWindow+TitlebarAccessory.h"
#import "PPTimeIntervalTransformer.h"

@implementation PlayerPianoAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[PPStyleSheet class];
	[PPTimeIntervalTransformer class];
	
	backgroundView = [[PPStyleView alloc] initWithFrame:backgroundContainer.bounds];
	[backgroundContainer addSubview:backgroundView];
	backgroundView.styleName = @"backgroundStyle";
	[backgroundView setNeedsDisplay];
	
	progressBar = [[PPStyleView alloc] initWithFrame:progressBarContainer.bounds];
	[progressBarContainer addSubview:progressBar];
	progressBar.styleName = @"progressBarStyle";
	[progressBar setNeedsDisplay];
	
	NSString *pandoraEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"pandoraEmail"];
	NSString *pandoraPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"pandoraPassword"];
	
	[self willChangeValueForKey:@"pianobar"];
	pianobar = [[PPPianobarController alloc] initWithUsername:pandoraEmail andPassword:pandoraPassword];
	[pianobar login];
    [pianobar loadStations];
	[self  didChangeValueForKey:@"pianobar"];
	
	[pianobar addObserver:self forKeyPath:@"selectedStation" options:0 context:@"stationController.selection"];
	[pianobar addObserver:self forKeyPath:@"isPlaying" options:0 context:@"stationController.isPlaying"];
	
	[window PP_setTitlebarAccessoryView:titlebarAccessory];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"stationController.selection") {
		NSDictionary *selectedStation = [pianobar selectedStation];
		NSNumber *stationID = [selectedStation objectForKey:@"id"];
		
		[pianobar playStationWithID:[stationID stringValue]];
	}else if(context == @"stationController.isPlaying"){
		[playPauseNextSegmentedControl setImage:[NSImage imageNamed:([pianobar isPlaying] ? @"pause" : @"play")]
									 forSegment:0];
	}else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


-(PPPianobarController *)pianobar{
	return pianobar;
}

-(void)applicationWillTerminate:(NSApplication *)app{
	[pianobar release];
	pianobar = nil;
}

-(IBAction)thumbsUpCurrentSong:(id)sender{
	[pianobar thumbsUpCurrentSong:sender];
}

-(IBAction)thumbsDownCurrentSong:(id)sender{
	[pianobar thumbsDownCurrentSong:sender];
}

-(IBAction)playPauseCurrentSong:(id)sender{
	[pianobar playPauseCurrentSong:sender];
}

-(IBAction)playNextSong:(id)sender{
	[pianobar playNextSong:sender];
}

-(IBAction)handleThumbSegmentedControl:(id)sender{
	NSInteger segment = [(NSSegmentedControl *)sender selectedSegment];
	if(segment == 0){
		[self thumbsDownCurrentSong:sender];
	}else if(segment == 1){
		[self thumbsUpCurrentSong:sender];
	}
}

-(IBAction)handlePlaybackSegmentedControl:(id)sender{
	NSInteger segment = [(NSSegmentedControl *)sender selectedSegment];
	if(segment == 0){
		[self playPauseCurrentSong:sender];
	}else if(segment == 1){
		[self playNextSong:sender];
	}
}

-(IBAction)quit:(id)sender{
	[pianobar stop];
	[pianobar release];
	
	[NSApp terminate:sender];
}

@end

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
#import "PPGrowingTextField.h"
#import <PianoBar/PPStation.h>
#import <PianoBar/PPTrack.h>
#import <Growl/Growl.h>
#import "MBPreferencesController.h"
#import "PPAccountPreferencesViewController.h"

@implementation PlayerPianoAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [GrowlApplicationBridge setGrowlDelegate:self];
    
	[PPStyleSheet class];
	[PPTimeIntervalTransformer class];
	
	backgroundContainer.styleName = @"backgroundStyle";
	[backgroundContainer setNeedsDisplay];
	
	titleField.maxWidth = [titleField frame].size.width;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleFrameDidChange:) name:NSViewFrameDidChangeNotification object:titleField];
	
	[[elapsedField cell] setBackgroundStyle:NSBackgroundStyleRaised];
	[[remainingField cell] setBackgroundStyle:NSBackgroundStyleRaised];
	
	NSString *pandoraEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"pandoraEmail"];
	NSString *pandoraPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"pandoraPassword"];
	
	[self setupPianobarControllerWithEmail:pandoraEmail password:pandoraPassword];
	
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.pandoraEmail" options:0 context:@"defaults.pandoraEmail"];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.pandoraPassword" options:0 context:@"defaults.pandoraPassword"];
	
	[window PP_setTitlebarAccessoryView:titlebarAccessory];
	
	// Setup preference panes
	PPAccountPreferencesViewController *accountsController = [[PPAccountPreferencesViewController alloc] initWithNibName:@"AccountPreferences" bundle:nil];
	[MBPreferencesController sharedController].modules = [NSArray arrayWithObjects:accountsController, nil];
	[accountsController release];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"stationController.selection") {
		PPStation *selectedStation = [pianobar selectedStation];
		
		[pianobar playStationWithID:[[selectedStation stationID] stringValue]];
	}else if(context == @"stationController.isPlaying"){
		NSLog(@"change: %i", [pianobar isInPlaybackMode]);
		[playPauseNextSegmentedControl setImage:[NSImage imageNamed:([pianobar isPlaying] ? @"NSPause" : @"play")]
									 forSegment:0];
	}else if (context == @"defaults.pandoraEmail" || context == @"defaults.pandoraPassword"){
		NSString *pandoraEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"pandoraEmail"];
		NSString *pandoraPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"pandoraPassword"];
		
		[self setupPianobarControllerWithEmail:pandoraEmail password:pandoraPassword];
	}else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

-(void)setupPianobarControllerWithEmail:(NSString *)pandoraEmail password:(NSString *)pandoraPassword{
	if (pianobar) {
		[self willChangeValueForKey:@"pianobar"];
		[pianobar removeObserver:self forKeyPath:@"selectedStation"];
		[pianobar removeObserver:self forKeyPath:@"isPlaying"];
		[pianobar stop];
		[pianobar release];
		pianobar = nil;
		[self  didChangeValueForKey:@"pianobar"];
	}
	
	if (pandoraEmail && pandoraPassword) {
		[self willChangeValueForKey:@"pianobar"];

		pianobar = [[PPPianobarController alloc] initWithUsername:pandoraEmail andPassword:pandoraPassword];
		[pianobar setDelegate:self];

		if([pianobar login]){
			[pianobar addObserver:self forKeyPath:@"selectedStation" options:0 context:@"stationController.selection"];
			[pianobar addObserver:self forKeyPath:@"isPlaying" options:0 context:@"stationController.isPlaying"];
			[pianobar loadStations];
		}else{
			[pianobar release];
			pianobar = nil;
		}
		
		[self  didChangeValueForKey:@"pianobar"];
	}
}


-(PPPianobarController *)pianobar{
	return pianobar;
}

-(void)applicationWillTerminate:(NSNotification *)app{
	[pianobar release];
	pianobar = nil;
}

- (void)titleFrameDidChange:(NSNotification *)notification
{
	NSPoint origin = [iTunesButton frame].origin;
	origin.x = NSMaxX([titleField frame]) + 8.0f;
	[iTunesButton setFrameOrigin:origin];
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

-(void)pianobarWillLogin:(PPPianobarController *)pianobar;
{
    NSLog(@"Will log in");
}

-(void)pianobarDidLogin:(PPPianobarController *)pianobar;
{
    NSLog(@"Logged in");
}

-(void)pianobar:(PPPianobarController *)pianobar didBeginPlayingSong:(PPTrack *)song;
{
    [GrowlApplicationBridge notifyWithTitle:[song title]
                                description:[song artist]
                           notificationName:@"PlaySong"
                                   iconData:nil
                                   priority:0
                                   isSticky:NO
                               clickContext:nil];
    NSLog(@"Playing song: %@", song);
}

-(void)pianobar:(PPPianobarController *)pianobar didBeginPlayingChannel:(PPStation *)channel;
{
    NSLog(@"Playing station: %@", channel);
}


-(IBAction)openInStore:(id)sender{
	[pianobar openInStore:self];
}

-(IBAction)quit:(id)sender{
	[pianobar stop];
	[pianobar release];
	
	[NSApp terminate:sender];
}

-(IBAction)showPreferences:(id)sender{
	[[MBPreferencesController sharedController] showWindow:self];
}

@end

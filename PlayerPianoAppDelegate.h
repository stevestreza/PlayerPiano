//
//  PlayerPianoAppDelegate.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import <Cocoa/Cocoa.h>
#import <PianoBar/PPPianobarController.h>
#import <Growl/Growl.h>
#import "PPStyleView.h"

@class PPGrowingTextField;

@interface PlayerPianoAppDelegate : NSObject <NSApplicationDelegate, PPPianobarDelegate, GrowlApplicationBridgeDelegate> {
    NSWindow *window;
	
	PPPianobarController *pianobar;
	
	IBOutlet NSArrayController *stationController;
	IBOutlet NSSegmentedControl *playPauseNextSegmentedControl;

	IBOutlet PPStyleView *backgroundContainer;
	
	IBOutlet PPGrowingTextField *titleField;
	IBOutlet NSButton *iTunesButton;
	
	IBOutlet NSView *titlebarAccessory;
	
	IBOutlet NSTextField *elapsedField;
	IBOutlet NSTextField *remainingField;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)thumbsUpCurrentSong:(id)sender;
-(IBAction)thumbsDownCurrentSong:(id)sender;
-(IBAction)playPauseCurrentSong:(id)sender;
-(IBAction)playNextSong:(id)sender;
-(IBAction)openInStore:(id)sender;

-(IBAction)handleThumbSegmentedControl:(id)sender;
-(IBAction)handlePlaybackSegmentedControl:(id)sender;
-(IBAction)quit:(id)sender;
-(IBAction)showPreferences:(id)sender;
-(IBAction)newStation:(id)sender;
@end

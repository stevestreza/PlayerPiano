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
#import "PPStyleView.h"

@interface PlayerPianoAppDelegate : NSObject <NSApplicationDelegate, PPPianobarDelegate> {
    NSWindow *window;
	
	PPPianobarController *pianobar;
	
	IBOutlet NSArrayController *stationController;
	IBOutlet NSSegmentedControl *playPauseNextSegmentedControl;

	IBOutlet NSView *backgroundContainer;
	IBOutlet NSView *progressBarContainer;
	PPStyleView *backgroundView;
	PPStyleView *progressBar;
	
	IBOutlet NSView *titlebarAccessory;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)thumbsUpCurrentSong:(id)sender;
-(IBAction)thumbsDownCurrentSong:(id)sender;
-(IBAction)playPauseCurrentSong:(id)sender;
-(IBAction)playNextSong:(id)sender;

-(IBAction)handleThumbSegmentedControl:(id)sender;
-(IBAction)handlePlaybackSegmentedControl:(id)sender;
-(IBAction)quit:(id)sender;
@end

//
//  PlayerPianoAppDelegate.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PPPianobarController.h"
#import "PPStyleView.h"

@interface PlayerPianoAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	PPPianobarController *pianobar;
	
	IBOutlet NSArrayController *stationController;

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

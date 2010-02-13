//
//  PlayerPianoAppDelegate.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PPPianobarController.h"

@interface PlayerPianoAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	
	PPPianobarController *pianobar;
}

@property (assign) IBOutlet NSWindow *window;

@end

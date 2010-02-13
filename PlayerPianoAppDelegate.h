//
//  PlayerPianoAppDelegate.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayerPianoAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end

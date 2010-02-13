//
//  PPPianobarController.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPFileHandleLineBuffer.h"

@class PPPianobarController;

@protocol PPPianobarDelegate

@optional
-(void)pianobarWillLogin:(PPPianobarController *)pianobar;
-(void)pianobarDidLogin:(PPPianobarController *)pianobar;

-(void)pianobar:(PPPianobarController *)pianobar didBeginPlayingSong:(NSDictionary *)song;

@end


@interface PPPianobarController : NSObject {
	NSTask *pianobarTask;
	
	PPFileHandleLineBuffer *pianobarReadLineBuffer;
	NSFileHandle *pianobarReadHandle;
	NSFileHandle *pianobarWriteHandle;
	
	id<PPPianobarDelegate> delegate;
}

@property (nonatomic, assign) id<PPPianobarDelegate> delegate;

@end

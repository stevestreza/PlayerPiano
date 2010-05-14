//
//  PPPianobarController.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import <Foundation/Foundation.h>
#import "PPFileHandleLineBuffer.h"
#import "PPLineParser.h"

@class PPPianobarController;

@protocol PPPianobarDelegate

@optional
-(void)pianobarWillLogin:(PPPianobarController *)pianobar;
-(void)pianobarDidLogin:(PPPianobarController *)pianobar;

-(void)pianobar:(PPPianobarController *)pianobar didBeginPlayingSong:(NSDictionary *)song;
-(void)pianobar:(PPPianobarController *)pianobar didBeginPlayingChannel:(NSString *)channel;

@end

@interface PPPianobarController : NSObject {
	NSTask *pianobarTask;
	
	NSString *username;
	NSString *password;
	
	PPFileHandleLineBuffer *pianobarReadLineBuffer;

	PPLineParser *pianobarParser;
	PPLineParser *stationParser;
	PPLineParser *playbackParser;
	
	NSArray *stations;

	PPStation *selectedStation;
	NSDictionary *nowPlaying;
	
	BOOL paused;
	
	NSFileHandle *pianobarReadHandle;
	NSFileHandle *pianobarWriteHandle;
	
	id<PPPianobarDelegate> delegate;
}

@property (nonatomic, retain) PPStation *selectedStation;
@property (nonatomic, retain) NSDictionary *nowPlaying;

@property (nonatomic, retain) NSArray *stations;
@property (nonatomic, assign) id<PPPianobarDelegate> delegate;

@property (nonatomic, assign) BOOL paused;

-(void)playStationWithID:(NSString *)stationID;

-(BOOL)isInPlaybackMode;
-(BOOL)isPlaying;
-(BOOL)isPaused;

-(IBAction)thumbsUpCurrentSong:(id)sender;
-(IBAction)thumbsDownCurrentSong:(id)sender;
-(IBAction)playPauseCurrentSong:(id)sender;
-(IBAction)playNextSong:(id)sender;

-(NSAttributedString *)nowPlayingAttributedDescription;

-(void)start;
-(void)stop;

-(id)initWithUsername:(NSString *)aUsername password:(NSString *)aPassword;

@end

//
//  NSWindow+TitlebarAccessory.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import <Cocoa/Cocoa.h>


@interface NSWindow (TitlebarAccessory)

-(void)PP_setTitlebarAccessoryView:(NSView *)accessoryView;
-(NSView *)PP_titlebarAccessoryView;

@property (nonatomic, retain, setter=PP_setTitlebarAccessoryView) NSView *PP_titlebarAccessoryView;

@end

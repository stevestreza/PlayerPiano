//
//  PPStyleView.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 Villainware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <VillainousStyle/VillainousStyle.h>

@interface PPStyleView : NSView {
	NSString *styleName;
	VSStyleSheet *styleSheet;
}

@property (nonatomic, copy) NSString *styleName;

// can be nil, will use the global stylesheet if so
@property (nonatomic, retain) VSStyleSheet *styleSheet;
-(void)setNeedsDisplay;
@end

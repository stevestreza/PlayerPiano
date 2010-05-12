//
//  PPGrowingTextField.h
//  PlayerPiano
//
//  Created by Matt Ball on 5/12/10.
//  Copyright 2010.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import <Cocoa/Cocoa.h>


@interface PPGrowingTextField : NSTextField {
	float maxWidth;
}

@property (nonatomic, assign) float maxWidth;

@end

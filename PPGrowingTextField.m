//
//  PPGrowingTextField.m
//  PlayerPiano
//
//  Created by Matt Ball on 5/12/10.
//  Copyright 2010.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PPGrowingTextField.h"

@implementation PPGrowingTextField

@synthesize maxWidth;

- (void)setObjectValue:(id <NSCopying>)obj
{
	[super setObjectValue:obj];
	
	[super sizeToFit];
	NSRect frame = [self frame];
	frame.size.width = fmin(frame.size.width, self.maxWidth);
	[self setFrame:frame];
}

- (float)maxWidth
{
	if (maxWidth <= 0.0f) {
		return FLT_MAX;
	}
	return maxWidth;
}

@end

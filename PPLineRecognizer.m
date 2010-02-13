//
//  PPLineRecognizer.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPLineRecognizer.h"


@implementation PPLineRecognizer

@synthesize recognizerBlock, actionBlock;

+(id)recognizerWithRecognizerBlock:(PPLineRecognizerBlock)recognizer performingActionBlock:(PPLineActionBlock)action{
	PPLineRecognizer *newRecognizer = [[[PPLineRecognizer alloc] init] autorelease];
	newRecognizer.recognizerBlock = recognizer;
	newRecognizer.actionBlock = action;
	return newRecognizer;
}

-(BOOL)testLine:(NSString *)line{
	if(self.recognizerBlock(line)){
		self.actionBlock(line);
		return YES;
	}else{
		return NO;
	}
}

@end

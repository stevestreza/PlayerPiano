//
//  PPLineParser.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPLineParser.h"


@implementation PPLineParser

-(void)addLineRecognizer:(PPLineRecognizer *)recognizer{
	NSMutableArray *recognizers = (NSMutableArray *)lineRecognizers;
	if(!recognizers){
		recognizers = [NSMutableArray array];
		lineRecognizers = [recognizers retain];
	}
	
	[recognizers addObject:recognizer];
}

-(void)parseLine:(NSString *)line{
	BOOL win = NO;
	for(PPLineRecognizer *recognizer in lineRecognizers){
		if([recognizer testLine:line]){
			win = YES;
			break;
		}
	}
	if(!win){
 		NSLog(@"Received unparsed line %@",line);
	}
}

@end

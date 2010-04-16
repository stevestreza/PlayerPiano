//
//  PPLineParser.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 Villainware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPLineRecognizer.h"

@interface PPLineParser : NSObject {
	NSMutableArray *lineRecognizers;
}

-(void)addLineRecognizer:(PPLineRecognizer *)recognizer;

-(void)parseLine:(NSString *)line;

@end

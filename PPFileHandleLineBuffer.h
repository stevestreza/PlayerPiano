//
//  PPFileHandleLineBuffer.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import <Foundation/Foundation.h>


@interface PPFileHandleLineBuffer : NSObject {
	NSFileHandle *fileHandle;
	NSMutableString *buffer;
	
	id target;
	SEL action;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

-(NSString *)bufferContents;
-(BOOL)bufferHasUnprocessedLines;

@end

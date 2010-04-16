//
//  PPFileHandleLineBuffer.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 Villainware. All rights reserved.
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

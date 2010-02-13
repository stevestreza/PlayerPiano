//
//  PPFileHandleLineBuffer.h
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PPFileHandleLineBuffer : NSObject {
	NSFileHandle *fileHandle;
	
	NSMutableData *buffer;
}

@end

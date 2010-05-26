//
//  PPTempFileWriter.h
//  PlayerPiano
//
//  Created by Steve Streza on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PPTempFileWriter : NSObject {
	NSString *_path;
}
@property (nonatomic, copy) NSString *path;

@end

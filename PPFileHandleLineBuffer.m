//
//  PPFileHandleLineBuffer.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPFileHandleLineBuffer.h"


@implementation PPFileHandleLineBuffer

@synthesize target, action;

-(id)initWithFileHandle:(NSFileHandle *)handle{
	if(self = [super init]){
		buffer = [[NSMutableString stringWithCapacity:256] retain];
		
		fileHandle = [handle retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleDataAvailableNotification object:fileHandle];

		[fileHandle waitForDataInBackgroundAndNotify];
	}
	return self;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleDataAvailableNotification object:fileHandle];
	[fileHandle release], fileHandle = nil;
	
	[super dealloc];
}

-(void)dataAvailable:(NSNotification *)notif{
	NSData *data = [fileHandle availableData];
	if(data && [data length] > 0){
		[buffer appendString:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]];
		
		NSRange newlineRange = NSMakeRange(0, 0);
		do{
			newlineRange = [buffer rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
			if(newlineRange.location != NSNotFound){
				NSString *line = [buffer substringWithRange:NSMakeRange(0, newlineRange.location)];
				[buffer setString:[buffer substringWithRange:NSMakeRange(newlineRange.location+1, buffer.length - newlineRange.location-1)]];

//				NSLog(@"We gots a line! '%@'", line);
				[self _sendLine:line];
			}
			
		}while(newlineRange.location != NSNotFound);
	}
	[fileHandle waitForDataInBackgroundAndNotify];
}

-(NSString *)bufferContents{
//	return [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
	return buffer;
}

-(BOOL)bufferHasUnprocessedLines{
	return [[self bufferContents] rangeOfString:@"\n"].location != NSNotFound;
}

-(void)_sendLine:(NSString *)line{
	if(line && target && action){
		if([target respondsToSelector:action]){
			[target performSelector:action withObject:line];
		}
	}
}

@end

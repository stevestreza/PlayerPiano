//
//  NSString+TimeParsing.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+TimeParsing.h"


@implementation NSString (TimeParsing)

-(NSTimeInterval)pp_timeIntervalValue{
	NSArray *components = [[[self componentsSeparatedByString:@":"] reverseObjectEnumerator] allObjects];
	
	NSUInteger units = 1;
	NSTimeInterval timeInterval = 0.;
	
	for(NSString *component in components){
		NSUInteger unit = [component intValue];
		timeInterval += unit * units;
		
		units = units * 60;
	}
	
	return timeInterval;
}

@end

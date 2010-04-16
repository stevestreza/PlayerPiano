//
//  PPTimeIntervalTransformer.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/15/10.
//  Copyright 2010 Villainware.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PPTimeIntervalTransformer.h"


@implementation PPTimeIntervalTransformer

+(void)initialize{
	if(self == [PPTimeIntervalTransformer class]){
		PPTimeIntervalTransformer *transformer = [[PPTimeIntervalTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"PPTimeIntervalTransformer"];
		[transformer release];
	}
}

-(id)transformedValue:(id)value{
	NSNumber *number = (NSNumber *)value;
	if(!number) return nil;
	
	NSTimeInterval timeInterval = (NSTimeInterval)([number doubleValue]);
	
	double seconds = (double)((int)(timeInterval) % 60);
	double minutes = (double)((timeInterval - seconds) / 60);
	double hours = (timeInterval - (minutes * 60) - seconds);
	
#define MakeStringNamedForItem(__name, __unit) NSString *__name = [NSString stringWithFormat:@"%@%d", (__unit >= 10 ? @"" : @"0"), (int)__unit]
	MakeStringNamedForItem(hourString, hours);
	MakeStringNamedForItem(minuteString, minutes);
	MakeStringNamedForItem(secondString, seconds);

	if(hours > 0){ // hours
		return [NSString stringWithFormat:@"%@:%@:%@",hourString, minuteString, secondString];
	}else if(minutes > 0){ // minutes
		return [NSString stringWithFormat:@"%@:%@",minuteString, secondString];
	}else{
		return [NSString stringWithFormat:@"0:%@",secondString];
	}
}

@end

//
//  PPStyleSheet.m
//  PlayerPiano
//
//  Created by Steve Streza on 2/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PPStyleSheet.h"
#import <VillainousStyle/VSShapes.h>
#import <VillainousStyle/VSStyles.h>

@implementation PPStyleSheet

-(VSStyle *)backgroundStyle{
	return 
	[VSFourBorderStyle styleWithTop:[NSColor blackColor] 
							  right:[NSColor blackColor] 
							 bottom:[NSColor colorWithCalibratedWhite:1.0 alpha:0.5]
							   left:[NSColor blackColor]
							  width:1.0 next:
	 [VSLinearGradientFillStyle styleWithColor1:[NSColor colorWithCalibratedWhite:0.20 alpha:1.0]
										 color2:[NSColor colorWithCalibratedWhite:0.02 alpha:1.0]
										   next:
	  nil
	  ]
	 ]
	;
}

@end

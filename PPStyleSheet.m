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
	 [VSLinearGradientFillStyle styleWithColor1:[NSColor colorWithCalibratedWhite:0.16	 alpha:1.0]
										 color2:[NSColor colorWithCalibratedWhite:0.02 alpha:1.0]
										   next:
	  nil
	  ]
	 ]
	;
}

-(VSStyle *)backgroundStyleInactive{
	return 
	[VSFourBorderStyle styleWithTop:[NSColor blackColor] 
							  right:[NSColor blackColor] 
							 bottom:[NSColor colorWithCalibratedWhite:1.0 alpha:0.5]
							   left:[NSColor blackColor]
							  width:1.0 next:
	 [VSLinearGradientFillStyle styleWithColor1:[NSColor colorWithCalibratedWhite:0.26	 alpha:1.0]
										 color2:[NSColor colorWithCalibratedWhite:0.19 alpha:1.0]
										   next:
	  nil
	  ]
	 ]
	;
}

-(VSStyle *)progressBarStyle{
	return 
	[VSShadowStyle styleWithColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.25]
							 blur:1.0
						   offset:CGSizeMake(0,1)
							 next:
	 [VSShapeStyle styleWithShape:[VSRoundedRectangleShape shapeWithRadius:3.] next:
	  [VSSolidBorderStyle styleWithColor:[NSColor colorWithCalibratedWhite:0.20 alpha:1.0] width:1.0 next:
	   [VSInnerShadowStyle styleWithColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.7] 
									 blur:3.
								   offset:CGSizeMake(0,0)
									 next:
		[VSSolidFillStyle styleWithColor:[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] next:
		nil
		 ]
		]
	   ]
	  ]
	 ]
	;
}

-(VSStyle *)progressBarStyleInactive{
	return 
	[VSShadowStyle styleWithColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.15]
							 blur:1.0
						   offset:CGSizeMake(0,1)
							 next:
	 [VSShapeStyle styleWithShape:[VSRoundedRectangleShape shapeWithRadius:3.] next:
	  [VSSolidBorderStyle styleWithColor:[NSColor colorWithCalibratedWhite:0.35 alpha:1.0] width:1.0 next:
	   [VSInnerShadowStyle styleWithColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] 
									 blur:3.
								   offset:CGSizeMake(0,0)
									 next:
		[VSSolidFillStyle styleWithColor:[NSColor colorWithCalibratedWhite:0.74 alpha:1.0] next:
		 nil
		 ]
		]
	   ]
	  ]
	 ]
	;
}

-(VSStyle *)knobStyle{
	return
	[VSShadowStyle styleWithColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.75] blur:1.0 offset:CGSizeMake(0, 1) next:
	[VSShapeStyle styleWithShape:[VSRoundedRectangleShape shapeWithRadius:10] next:
	 [VSLinearGradientFillStyle styleWithColor1:[NSColor colorWithCalibratedWhite:0.75 alpha:1.0]
										 color2:[NSColor colorWithCalibratedWhite:0.9 alpha:1.0]
										   next:
	  nil
	  ]
	 ]
	 ]
	;
}

@end

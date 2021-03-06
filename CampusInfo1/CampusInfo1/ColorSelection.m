//
//  ColorSelection.m
//  CampusInfo1
//
//  Created by Ilka Kokemor on 26.08.13.
//
//

#import "ColorSelection.h"

@implementation ColorSelection

@synthesize _zhawOriginalBlue;
@synthesize _zhawWhite;
@synthesize _zhawLightGrey;
@synthesize _zhawLighterBlue;
@synthesize _zhawRed;
@synthesize _zhawLightestBlue;
@synthesize _zhawDarkGrey;
@synthesize _zhawDarkerBlue;
@synthesize _zhawFontGrey;

-(id) init
{
    self = [super init];
    if (self)
    {
        // blue
        self._zhawOriginalBlue  = [UIColor colorWithRed:0.0/255.0 green:100.0/255.0 blue:166.0/255.0 alpha:1.0];
        self._zhawLighterBlue  = [UIColor colorWithRed:91.0/255.0 green:137.0/255.0 blue:199.0/255.0 alpha:1.0];
        self._zhawLightestBlue =  [UIColor colorWithRed:204.0/255.0 green:225.0/255.0 blue:252.0/255.0 alpha:1.0];
        self._zhawDarkerBlue   = [UIColor colorWithRed:0.0/255.0 green:67.0/255.0 blue:103.0/255.0 alpha:1.0];

        
        // white
        self._zhawWhite         = [UIColor whiteColor];
        
        // red
        self._zhawRed           = [UIColor colorWithRed:232.0/255.0 green:63.0/255.0 blue:58.0/255.0 alpha:1.0];

        // grey
        self._zhawLightGrey     = [UIColor colorWithRed:185.0/255.0 green:194.0/255.0 blue:196.0/255.0 alpha:1.0];
        self._zhawDarkGrey      = [UIColor colorWithRed:61.0/255.0 green:77.0/255.0 blue:92.0/255.0 alpha:1.0];
        self._zhawFontGrey      = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
    }
    return self;
}




@end

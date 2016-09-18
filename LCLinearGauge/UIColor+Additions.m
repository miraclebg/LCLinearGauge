//
//  UIColor+Additions.m
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Nimasystems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Additions.h"

@implementation UIColor(Additions)

- (NSDictionary*)rgbComponents
{
    CGFloat r,g,b,a = 0.0;
    
    // < iOS 5
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    r = components[0];
    g = components[1];
    b = components[2];
    a = components[3];
    
    NSDictionary *ret = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithFloat:r], @"red",
                         [NSNumber numberWithFloat:g], @"green",
                         [NSNumber numberWithFloat:b], @"blue",
                         [NSNumber numberWithFloat:a], @"alpha",
                         nil];
    
    return ret;
}

+ (UIColor*)colorWithHex:(long)hexColor
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

@end

//
//  UIColor+Additions.h
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Nimasystems Ltd. All rights reserved.
//

// Color helpers

#define LRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define LRGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 \
alpha:(a)]

@interface UIColor(Additions)

+ (UIColor*)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

- (NSDictionary*)rgbComponents;

@end

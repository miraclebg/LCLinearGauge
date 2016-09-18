//
//  LCLinearGaugeTickView.m
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Openwave. All rights reserved.
//

#import "LCLinearGaugeTickView.h"

@implementation LCLinearGaugeTickView

#pragma mark - Initialization / Finalization

- (void)dealloc {
    self.stepLineColor = nil;
    self.lineColor = nil;
    self.tickLineColor = nil;
    self.lineItemFont = nil;
    self.lineItemTextColor = nil;
}

#pragma mark - Getters / Setters

- (void)setStep:(double)step {
    if (step != _step) {
        _step = step;
        [self setNeedsDisplay];
    }
}

- (void)setMinValue:(double)minValue {
    if (minValue != _minValue) {
        _minValue = minValue;
        [self setNeedsDisplay];
    }
}

- (void)setMaxValue:(double)maxValue {
    if (maxValue != _maxValue) {
        _maxValue = maxValue;
        [self setNeedsDisplay];
    }
}

- (void)setStepGroupTicks:(NSInteger)stepGroupTicks {
    if (stepGroupTicks != _stepGroupTicks) {
        _stepGroupTicks = stepGroupTicks;
        [self setNeedsDisplay];
    }
}

- (void)setStepGroupDividerTickOnEachTick:(NSInteger)stepGroupDividerTickOnEachTick {
    if (stepGroupDividerTickOnEachTick != _stepGroupDividerTickOnEachTick) {
        _stepGroupDividerTickOnEachTick = stepGroupDividerTickOnEachTick;
        [self setNeedsDisplay];
    }
}

- (void)setStepGroupDividerTickOnEachTickShows:(BOOL)stepGroupDividerTickOnEachTickShows {
    if (stepGroupDividerTickOnEachTickShows != _stepGroupDividerTickOnEachTickShows) {
        _stepGroupDividerTickOnEachTickShows = stepGroupDividerTickOnEachTickShows;
        [self setNeedsDisplay];
    }
}

- (void)setTickSpacing:(CGFloat)tickSpacing {
    if (tickSpacing != _tickSpacing) {
        _tickSpacing = tickSpacing;
        [self setNeedsDisplay];
    }
}

- (void)setStepLineColor:(UIColor *)stepLineColor {
    if (stepLineColor != _stepLineColor) {
        _stepLineColor = stepLineColor;
        [self setNeedsDisplay];
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor != _lineColor) {
        _lineColor = lineColor;
        [self setNeedsDisplay];
    }
}

- (void)setLineThickness:(CGFloat)lineThickness {
    if (lineThickness != _lineThickness) {
        _lineThickness = lineThickness;
        [self setNeedsDisplay];
    }
}

- (void)setTickLineColor:(UIColor *)tickLineColor {
    if (tickLineColor != _tickLineColor) {
        _tickLineColor = tickLineColor;
        [self setNeedsDisplay];
    }
}

- (void)setLineItemFont:(UIFont *)lineItemFont {
    if (lineItemFont != _lineItemFont) {
        _lineItemFont = lineItemFont;
        [self setNeedsDisplay];
    }
}

- (void)setLineItemTextColor:(UIColor *)lineItemTextColor {
    if (lineItemTextColor != _lineItemTextColor) {
        _lineItemTextColor = lineItemTextColor;
        [self setNeedsDisplay];
    }
}

- (void)setLineHeightPadding:(CGFloat)lineHeightPadding {
    if (lineHeightPadding != _lineHeightPadding) {
        _lineHeightPadding = lineHeightPadding;
        [self setNeedsDisplay];
    }
}

- (void)setValue:(double)value {
    if (value != _value) {
        _value = value;
        //
    }
}

- (void)setTickViewPadding:(CGFloat)tickViewPadding {
    if (tickViewPadding != _tickViewPadding) {
        _tickViewPadding = tickViewPadding;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (NSInteger)totalTicks {
    return (([self totalPrimaryTicks] + 3) * self.stepGroupTicks) - ([self totalPrimaryTicks] / 2);
}

- (NSInteger)totalPrimaryTicks {
    return (ceil((self.maxValue - self.minValue) + 1) / self.step);
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f);
    CGContextFillRect(context, rect);
    
    NSInteger i,j = 0;
    NSInteger totalTicks = [self totalPrimaryTicks];
    
    if (totalTicks) {
        NSDictionary *attributes = @{NSFontAttributeName:self.lineItemFont};
        CGRect lineTextRect = [@"9999" boundingRectWithSize:CGSizeMake(self.lineHeightPadding * 2, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
        
        CGFloat nextTickX = _tickViewPadding;
        CGFloat txtOffset = roundf(self.tickSpacing / 2 - self.lineThickness / 2);
        CGFloat txtPadding = roundf(self.lineHeightPadding / 2);
        double value = self.minValue;
        NSString *valStr = nil;
        UIColor *lineColor = self.lineColor;
        CGFloat lineY;
        
        CGContextSetLineWidth(context, self.lineThickness);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        for (i = 0; i <= totalTicks - 1; i++) {
            
            // big tick
            lineY = self.bounds.size.height - self.lineHeightPadding - lineTextRect.size.height;
            lineColor = self.lineColor;
            
            // draw text under big ticks
            valStr = [NSString stringWithFormat:@"%d", (int)value];
            [valStr drawAtPoint:CGPointMake(nextTickX - txtOffset, lineY + txtPadding)
                 withAttributes:@{NSFontAttributeName: self.lineItemFont,
                                  NSForegroundColorAttributeName: self.lineItemTextColor
                                  }];
            
            // draw tick
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            CGContextMoveToPoint(context, nextTickX, 0);
            CGContextAddLineToPoint(context, nextTickX, lineY);
            CGContextStrokePath(context);
            
            if (self.stepGroupTicks && i < totalTicks - 1) {
                nextTickX += self.tickSpacing;
                
                for(j = 0; j <= self.stepGroupTicks - 2; j++) {
                    if (self.stepGroupDividerTickOnEachTickShows && self.stepGroupDividerTickOnEachTick == j + 1) {
                        // medium tick
                        lineY = self.bounds.size.height - self.lineHeightPadding * 3;
                        lineColor = self.tickLineColor;
                    } else {
                        // small tick
                        lineY = self.bounds.size.height - self.lineHeightPadding * 4;
                        lineColor = self.stepLineColor;
                    }
                    
                    // draw tick
                    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
                    CGContextMoveToPoint(context, nextTickX, 0);
                    CGContextAddLineToPoint(context, nextTickX, lineY);
                    CGContextStrokePath(context);
                    
                    if (j < self.stepGroupTicks - 2) {
                        nextTickX += self.tickSpacing;
                    }
                }
            }
            
            nextTickX += self.tickSpacing;
            value += self.step;
        }
    }
}

@end

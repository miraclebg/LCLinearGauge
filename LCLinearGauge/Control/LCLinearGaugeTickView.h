//
//  LCLinearGaugeTickView.h
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Openwave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLinearGaugeTickView : UIView

@property (nonatomic, assign) double value;
@property (nonatomic, assign) double step;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;

@property (nonatomic, assign) NSInteger stepGroupTicks;
@property (nonatomic, assign) NSInteger stepGroupDividerTickOnEachTick;
@property (nonatomic, assign) BOOL stepGroupDividerTickOnEachTickShows;

@property (nonatomic, assign) CGFloat tickSpacing;
@property (nonatomic, assign) CGFloat tickViewPadding;
@property (nonatomic, assign) CGFloat lineHeightPadding;

@property (nonatomic, strong) UIColor *stepLineColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *tickLineColor;

@property (nonatomic, assign) CGFloat lineThickness;
@property (nonatomic, strong) UIFont *lineItemFont;
@property (nonatomic, strong) UIColor *lineItemTextColor;

- (NSInteger)totalTicks;

@end

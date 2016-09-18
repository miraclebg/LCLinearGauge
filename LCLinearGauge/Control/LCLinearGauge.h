//
//  LCLinearGauge.h
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Nimasystems Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLinearGaugeHeaderView.h"

@class LCLinearGauge;

typedef NSString * (^LCLinearGaugeSelectedValueFormatter)(double value);

@protocol LCLinearGaugeDelegate <NSObject>

@optional

- (void)linearGauge:(LCLinearGauge*)gauge didChangeValue:(double)value;

@end

@interface LCLinearGauge : UIView

@property (nonatomic, assign) CGFloat topViewHeight;

@property (nonatomic, strong, readonly) LCLinearGaugeHeaderView *topBgView;

@property (nonatomic, assign) BOOL showsInfoHeader;
@property (nonatomic, assign) CGFloat tickViewY;

@property (nonatomic, assign) double value;
@property (nonatomic, assign) double step;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;

@property (nonatomic, assign) NSInteger stepGroupTicks;
@property (nonatomic, assign) NSInteger stepGroupDividerTickOnEachTick;
@property (nonatomic, assign) BOOL stepGroupDividerTickOnEachTickShows;

@property (nonatomic, assign) CGFloat tickViewPadding;
@property (nonatomic, assign) CGFloat tickSpacing;

@property (nonatomic, strong) UIColor *stepLineColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *tickLineColor;

@property (nonatomic, assign) CGFloat lineHeightPadding;

@property (nonatomic, assign) CGFloat lineThickness;
@property (nonatomic, strong) UIFont *lineItemFont;
@property (nonatomic, strong) UIColor *lineItemTextColor;

@property (nonatomic, assign) id<LCLinearGaugeDelegate> delegate;

@property (nonatomic, copy) LCLinearGaugeSelectedValueFormatter valueFormatter;

@end

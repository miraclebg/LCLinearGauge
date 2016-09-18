//
//  LCLinearGauge.m
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Nimasystems Ltd. All rights reserved.
//

#import "LCLinearGauge.h"
#import "UIColor+Additions.h"
#import "LCLinearGaugeTickView.h"

CGFloat const kLCLinearGaugeDefaultTopViewHeight = 80.0f;
CGFloat const kLCLinearGaugeDefaultLineThickness = 1.0f;
CGFloat const kLCLinearGaugeDefaultTickSpacing = 20.0f;
CGFloat const kLCLinearGaugeDefaultLineHeightPadding = 20.0f;
CGFloat const kLCLinearGaugeDefaultTickViewPadding = 20.0f;

@interface LCLinearGauge() <UIScrollViewDelegate>

@property (nonatomic, strong) LCLinearGaugeHeaderView *topBgView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LCLinearGaugeTickView *tickView;

@property (nonatomic, assign) BOOL noScrollUpdate;

@property (nonatomic, strong) NSNumberFormatter *internalValueFormatter;

@end

@implementation LCLinearGauge

#pragma mark - Initialization / Finalization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self init_];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self init_];
    }
    return self;
}

- (void)init_ {
    self.clipsToBounds = YES;
    
    _showsInfoHeader = YES;
    _topViewHeight = kLCLinearGaugeDefaultTopViewHeight;
    
    _minValue = 0;
    _maxValue = 1;
    _step = 0.1f;
    _stepGroupTicks = 10;
    _stepGroupDividerTickOnEachTick = 5;
    _stepGroupDividerTickOnEachTickShows = YES;
    _tickSpacing = kLCLinearGaugeDefaultTickSpacing;
    _tickViewPadding = kLCLinearGaugeDefaultTickViewPadding;
    
    _stepLineColor = [UIColor colorWithHex:0xd4d4d4];
    _lineColor = [UIColor blackColor];
    _lineThickness = kLCLinearGaugeDefaultLineThickness;
    _tickLineColor = [UIColor colorWithHex:0xbebebe];
    
    _lineItemFont = [UIFont systemFontOfSize:16.0f];
    _lineItemTextColor = [UIColor blackColor];
    _lineHeightPadding = kLCLinearGaugeDefaultLineHeightPadding;
    
    self.internalValueFormatter = [[NSNumberFormatter alloc] init];
    self.internalValueFormatter.positiveFormat = @"0.##";
    
    __weak LCLinearGauge *weakSelf = self;
    
    _valueFormatter = ^(double value) {
        NSString* s = [weakSelf.internalValueFormatter stringFromNumber: [NSNumber numberWithDouble:value]];
        return s;
    };
    
    self.topBgView = [[LCLinearGaugeHeaderView alloc] init];
    [self addSubview:self.topBgView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.tickView = [[LCLinearGaugeTickView alloc] init];
    self.tickView.value = self.value;
    self.tickView.minValue = self.minValue;
    self.tickView.maxValue = self.maxValue;
    self.tickView.step = self.step;
    self.tickView.stepGroupTicks = self.stepGroupTicks;
    self.tickView.stepGroupDividerTickOnEachTick = self.stepGroupDividerTickOnEachTick;
    self.tickView.stepGroupDividerTickOnEachTickShows = self.stepGroupDividerTickOnEachTickShows;
    self.tickView.stepLineColor = self.stepLineColor;
    self.tickView.lineColor = self.lineColor;
    self.tickView.lineThickness = self.lineThickness;
    self.tickView.tickLineColor = self.tickLineColor;
    self.tickView.tickSpacing = self.tickSpacing;
    self.tickView.lineHeightPadding = self.lineHeightPadding;
    self.tickView.lineItemFont = self.lineItemFont;
    self.tickView.tickViewPadding = self.tickViewPadding;
    self.tickView.lineItemTextColor = self.lineItemTextColor;
    [self.scrollView addSubview:self.tickView];
    
    [self bringSubviewToFront:self.topBgView];
    
    self.topBgView.gaugeLabel.text = self.valueFormatter(self.value);
}

- (void)dealloc {
    self.topBgView = nil;
    self.scrollView = nil;
    self.tickView = nil;
    self.valueFormatter = nil;
    self.stepLineColor = nil;
    self.lineColor = nil;
    self.tickLineColor = nil;
    self.lineItemFont = nil;
    self.lineItemTextColor = nil;
    self.internalValueFormatter = nil;
}

#pragma mark - Getters / Setters

- (void)setTopViewHeight:(CGFloat)topViewHeight {
    if (topViewHeight != self.topViewHeight) {
        _topViewHeight = topViewHeight;
        [self setNeedsLayout];
    }
}

- (void)setShowsInfoHeader:(BOOL)showsInfoHeader {
    if (showsInfoHeader != _showsInfoHeader) {
        _showsInfoHeader = showsInfoHeader;
        self.topBgView.hidden = !_showsInfoHeader;
        [self setNeedsLayout];
    }
}

- (void)setStep:(double)step {
    if (step != _step) {
        _step = step;
        self.tickView.step = self.step;
        [self setNeedsLayout];
    }
}

- (void)setMinValue:(double)minValue {
    if (minValue != _minValue) {
        _minValue = minValue;
        self.tickView.minValue = self.minValue;
        
        if (self.value < _minValue) {
            self.value = _minValue;
        }
    }
}

- (void)setMaxValue:(double)maxValue {
    if (maxValue != _maxValue) {
        _maxValue = maxValue;
        self.tickView.maxValue = self.maxValue;
        
        if (self.value > _maxValue) {
            self.value = _maxValue;
        }
    }
}

- (void)setStepGroupTicks:(NSInteger)stepGroupTicks {
    if (stepGroupTicks != _stepGroupTicks) {
        _stepGroupTicks = stepGroupTicks;
        self.tickView.stepGroupTicks = self.stepGroupTicks;
    }
}

- (void)setStepGroupDividerTickOnEachTick:(NSInteger)stepGroupDividerTickOnEachTick {
    if (stepGroupDividerTickOnEachTick != _stepGroupDividerTickOnEachTick) {
        _stepGroupDividerTickOnEachTick = stepGroupDividerTickOnEachTick;
        self.tickView.stepGroupDividerTickOnEachTick = self.stepGroupDividerTickOnEachTick;
    }
}

- (void)setStepGroupDividerTickOnEachTickShows:(BOOL)stepGroupDividerTickOnEachTickShows {
    if (stepGroupDividerTickOnEachTickShows != _stepGroupDividerTickOnEachTickShows) {
        _stepGroupDividerTickOnEachTickShows = stepGroupDividerTickOnEachTickShows;
        self.tickView.stepGroupDividerTickOnEachTickShows = self.stepGroupDividerTickOnEachTickShows;
    }
}

- (void)setTickSpacing:(CGFloat)tickSpacing {
    if (tickSpacing != _tickSpacing) {
        _tickSpacing = tickSpacing;
        self.tickView.tickSpacing = self.tickSpacing;
    }
}

- (void)setStepLineColor:(UIColor *)stepLineColor {
    if (stepLineColor != _stepLineColor) {
        _stepLineColor = stepLineColor;
        self.tickView.stepLineColor = self.stepLineColor;
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor != _lineColor) {
        _lineColor = lineColor;
        self.tickView.lineColor = self.lineColor;
    }
}

- (void)setLineThickness:(CGFloat)lineThickness {
    if (lineThickness != _lineThickness) {
        _lineThickness = lineThickness;
        self.tickView.lineThickness = self.lineThickness;
    }
}

- (void)setTickLineColor:(UIColor *)tickLineColor {
    if (tickLineColor != _tickLineColor) {
        _tickLineColor = tickLineColor;
        self.tickView.tickLineColor = self.tickLineColor;
    }
}

- (void)setLineItemFont:(UIFont *)lineItemFont {
    if (lineItemFont != _lineItemFont) {
        _lineItemFont = lineItemFont;
        self.tickView.lineItemFont = self.lineItemFont;
    }
}

- (void)setLineItemTextColor:(UIColor *)lineItemTextColor {
    if (lineItemTextColor != _lineItemTextColor) {
        _lineItemTextColor = lineItemTextColor;
        self.tickView.lineItemTextColor = self.lineItemTextColor;
    }
}

- (void)setLineHeightPadding:(CGFloat)lineHeightPadding {
    if (lineHeightPadding != _lineHeightPadding) {
        _lineHeightPadding = lineHeightPadding;
        self.tickView.lineHeightPadding = self.lineHeightPadding;
    }
}

- (void)setValue:(double)value {
    [self setValueInternal:value scroll:YES];
}

- (void)setValueInternal:(double)value scroll:(BOOL)scroll {
    if (value != _value) {
        _value = value;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(linearGauge:didChangeValue:)]) {
            [self.delegate linearGauge:self didChangeValue:_value];
        }
        
        self.topBgView.gaugeLabel.text = self.valueFormatter(_value);
        
        if (scroll && self.value) {
            [self updateScrollPosition];
        }
    }
}

- (void)setValueFormatter:(LCLinearGaugeSelectedValueFormatter)valueFormatter {
    if (valueFormatter != _valueFormatter) {
        _valueFormatter = (valueFormatter ? valueFormatter : _valueFormatter);
        self.topBgView.gaugeLabel.text = self.valueFormatter(self.value);
    }
}

#pragma mark - Internal

- (double)singleTickValue {
    return (self.stepGroupTicks ? self.step / self.stepGroupTicks : self.step);
}

- (void)updateScrollPosition {
    self.noScrollUpdate = YES;
    CGFloat offset = self.value * self.tickSpacing;
    [self.scrollView setContentOffset:CGPointMake(offset, self.scrollView.contentOffset.y) animated:NO];
    self.noScrollUpdate = NO;
}

#pragma mark - View related

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.showsInfoHeader) {
        self.topBgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.topViewHeight);
    } else {
        self.topBgView.frame = CGRectNull;
    }
    
    CGFloat textTitlePadding = _tickViewPadding * 2; /* text titles get cutoff */
    CGFloat ticksW = (self.tickSpacing + self.lineThickness) * ([self.tickView totalTicks]);
    
    CGFloat th = (self.tickViewY ? self.tickViewY : self.topBgView.frame.size.height);
    
    self.scrollView.frame = CGRectMake(0, th,
                                       self.bounds.size.width, fabs(self.bounds.size.height - th));
    self.tickView.frame = CGRectMake(roundf(self.scrollView.frame.size.width / 2) - _tickViewPadding,
                                     0,
                                     ticksW,
                                     self.scrollView.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.tickView.frame.size.width - textTitlePadding + self.scrollView.frame.size.width, self.tickView.frame.size.height);
    
    [self updateScrollPosition];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.noScrollUpdate && scrollView.contentOffset.x) {
        CGFloat value = (scrollView.contentOffset.x / self.tickSpacing) * [self singleTickValue];
        
        if (value) {
            value = value + self.minValue;
            [self setValueInternal:value scroll:NO];
        }
    }
}

@end

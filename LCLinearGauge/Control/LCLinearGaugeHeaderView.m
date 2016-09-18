//
//  LCLinearGaugeHeaderView.m
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Openwave. All rights reserved.
//

#import "LCLinearGaugeHeaderView.h"

@interface LCLinearGaugeHeaderView()

@property (nonatomic, strong) UILabel *gaugeLabel;

@end

@implementation LCLinearGaugeHeaderView

#pragma mark - Initialization / Finalization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _showsTrianglePointer = YES;
        _bgHeight = 50.0f;
        _triangleShapeSize = 20.0f;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.2;
        self.layer.masksToBounds = NO;
        
        self.gaugeLabel = [[UILabel alloc] init];
        self.gaugeLabel.backgroundColor = [UIColor clearColor];
        self.gaugeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        self.gaugeLabel.textAlignment = NSTextAlignmentCenter;
        self.gaugeLabel.textColor = [UIColor blackColor];
        self.gaugeLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:self.gaugeLabel];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectNull];
}

- (void)dealloc {
    self.gaugeLabel = nil;
}

#pragma mark - Getters / Setters

- (void)setShowsTrianglePointer:(BOOL)showsTrianglePointer {
    if (showsTrianglePointer != _showsTrianglePointer) {
        _showsTrianglePointer = showsTrianglePointer;
        [self setNeedsDisplay];
    }
}

#pragma mark - View related

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gaugeLabel.frame = _showsTrianglePointer ? CGRectMake(0, 0, self.bounds.size.width,
                                                               _bgHeight) : self.bounds;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CGFloat bgHeight = _showsTrianglePointer ? _bgHeight : self.bounds.size.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, rect);
    
    CGContextSetRGBFillColor(ctx, 243/255.0f, 241/255.0f, 243/255.0f, 1.0f);
    CGContextFillRect(ctx, CGRectMake(0, 0, rect.size.width, bgHeight));
    
    if (self.showsTrianglePointer && _triangleShapeSize) {
        // draw triangle like pointer
        
        CGFloat startY = bgHeight; // self.bounds.size.height
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, roundf(self.bounds.size.width / 2 - _triangleShapeSize / 2), startY);  // top left
        CGContextAddLineToPoint(ctx, roundf(self.bounds.size.width / 2), startY + _triangleShapeSize);  // mid right
        CGContextAddLineToPoint(ctx, roundf(self.bounds.size.width / 2 + _triangleShapeSize / 2), startY);  // bottom left
        CGContextClosePath(ctx);
        
        CGContextFillPath(ctx);
    }
}

@end

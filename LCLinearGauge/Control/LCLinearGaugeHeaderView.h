//
//  LCLinearGaugeHeaderView.h
//  LCLinearGauge
//
//  Created by Martin Kovachev on 9.09.16 г..
//  Copyright © 2016 г. Openwave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCLinearGaugeHeaderView : UIView

@property (nonatomic, assign) BOOL showsTrianglePointer;
@property (nonatomic, assign) CGFloat bgHeight;
@property (nonatomic, assign) CGFloat triangleShapeSize;

@property (nonatomic, strong, readonly) UILabel *gaugeLabel;

@end

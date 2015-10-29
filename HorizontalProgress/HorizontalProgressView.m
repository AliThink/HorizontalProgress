//
//  HorizontalProgressView.m
//  HorizontalProgress
//
//  Created by AliThink on 15/10/28.
//  Copyright © 2015年 AliThink. All rights reserved.
//

#import "HorizontalProgressView.h"

#define PROGRESS_PADDING 8
#define PROGRESS_TIPLABEL_HEIGHT 30

@implementation HorizontalProgressView {
    CAShapeLayer *maskLayer;
    CAShapeLayer *moveLayer;
    UIView *aboveView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self intialConfig];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self intialConfig];
    }
    return self;
}

- (void)intialConfig {
    maskLayer = [CAShapeLayer layer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self configElementsOnAbove:NO];
    
    aboveView = [[UIView alloc] initWithFrame:self.bounds];
    aboveView.backgroundColor = [UIColor clearColor];
    maskLayer.frame = aboveView.bounds;
    [self addSubview:aboveView];
    
    [self configElementsOnAbove:YES];
    [self bringSubviewToFront:aboveView];
    [self configMask];
}

- (void)configElementsOnAbove:(BOOL)flag {
    if ([self.progressLevelArray count] == 0) {
        return;
    }
    
    CGFloat idleHeight = self.frame.size.height - 2 * PROGRESS_PADDING;
    CGFloat pointRadius = idleHeight > self.pointMaxRadius * 2 ? self.pointMaxRadius : idleHeight / 2.0;
    CGFloat lineHeight = idleHeight > self.lineMaxHeight ? self.lineMaxHeight : idleHeight;
    CGFloat unitLineWidth = (self.frame.size.width - 2 * PROGRESS_PADDING - 2 * pointRadius) / ([self.progressLevelArray count] - 1);
    
    for (NSInteger index = 0; index < [self.progressLevelArray count]; index++) {
        
        CGRect unitLineRect = CGRectMake(PROGRESS_PADDING + index * unitLineWidth + pointRadius, (self.frame.size.height - lineHeight) / 2.0, unitLineWidth, lineHeight);
        CGRect pointRect = CGRectMake(PROGRESS_PADDING + index * unitLineWidth, self.frame.size.height / 2.0 - pointRadius, 2 * pointRadius, 2 * pointRadius);
        
        CGFloat labelOriginY = self.frame.size.height / 2.0 - PROGRESS_PADDING - PROGRESS_TIPLABEL_HEIGHT - pointRadius;
        if (self.textPosition == bottomPosition) {
            labelOriginY = self.frame.size.height / 2.0 + PROGRESS_PADDING + pointRadius;
        }
        CGRect labelRect = CGRectMake(pointRect.origin.x + pointRadius - unitLineWidth / 2.0, labelOriginY, unitLineWidth, PROGRESS_TIPLABEL_HEIGHT);
        
        if (index != [self.progressLevelArray count] - 1) {
            if (index < self.currentLevel) {
                [self generateUnitLineWithFrame:unitLineRect achieved:YES above:flag];
            } else {
                [self generateUnitLineWithFrame:unitLineRect achieved:NO above:flag];
            }
        }
        
        if (index <= self.currentLevel) {
            [self generatePointWithFrame:pointRect achieved:YES above:flag];
            [self generateTipLabelWithFrame:labelRect
                                   achieved:YES
                                  labelText:[self.progressLevelArray objectAtIndex:index]
                                      above:flag];
        } else {
            [self generatePointWithFrame:pointRect achieved:NO above:flag];
            [self generateTipLabelWithFrame:labelRect
                                   achieved:NO
                                  labelText:[self.progressLevelArray objectAtIndex:index]
                                      above:flag];
        }
    }
}

- (void)generatePointWithFrame:(CGRect)frame
                      achieved:(BOOL)achievedFlag
                         above:(BOOL)aboveFlag {
    UIView *pointView = [[UIView alloc] initWithFrame:frame];
    if (achievedFlag && aboveFlag) {
        pointView.backgroundColor = self.achievedColor ? self.achievedColor : [UIColor orangeColor];
    } else {
        pointView.backgroundColor = self.unachievedColor ? self.unachievedColor : [UIColor lightGrayColor];
    }
    pointView.layer.cornerRadius = frame.size.width / 2.0;
    
    if (aboveFlag) {
        [aboveView addSubview:pointView];
    } else {
        [self addSubview:pointView];
    }
}

- (void)generateUnitLineWithFrame:(CGRect)frame
                         achieved:(BOOL)achievedFlag
                            above:(BOOL)aboveFlag {
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    if (achievedFlag && aboveFlag) {
        lineView.backgroundColor = self.achievedColor ? self.achievedColor : [UIColor orangeColor];
    } else {
        lineView.backgroundColor = self.unachievedColor ? self.unachievedColor : [UIColor lightGrayColor];
    }
    
    if (aboveFlag) {
        [aboveView addSubview:lineView];
    } else {
        [self addSubview:lineView];
    }
}

- (void)generateTipLabelWithFrame:(CGRect)frame
                         achieved:(BOOL)achievedFlag
                        labelText:(NSString *)text
                            above:(BOOL)aboveFlag {
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:frame];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = text;
    tipLabel.adjustsFontSizeToFitWidth = YES;
    tipLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    if (achievedFlag && aboveFlag) {
        tipLabel.textColor = self.achievedColor ? self.achievedColor : [UIColor orangeColor];
    } else {
        tipLabel.textColor = self.unachievedColor ? self.unachievedColor : [UIColor lightGrayColor];
    }
    if (aboveFlag) {
        [aboveView addSubview:tipLabel];
    } else {
        [self addSubview:tipLabel];
    }
}

- (void)configMask {
    moveLayer = [CAShapeLayer layer];
    moveLayer.bounds = aboveView.bounds;
    moveLayer.fillColor = [[UIColor blackColor] CGColor];
    moveLayer.path = [UIBezierPath bezierPathWithRect:aboveView.bounds].CGPath;
    moveLayer.opacity = 0.8;
    moveLayer.position = CGPointMake(-aboveView.bounds.size.width / 2.0, aboveView.bounds.size.height / 2.0);
    [maskLayer addSublayer:moveLayer];
    
    aboveView.layer.mask = maskLayer;
}

- (void)startAnimation {
    moveLayer.position = CGPointMake(aboveView.bounds.size.width / 2.0, aboveView.bounds.size.height / 2.0);
    CABasicAnimation *rightAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    rightAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-aboveView.bounds.size.width / 2.0, aboveView.bounds.size.height / 2.0)];
    rightAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(aboveView.bounds.size.width / 2.0, aboveView.bounds.size.height / 2.0)];
    rightAnimation.duration = self.animationDuration ? self.animationDuration : 5;
    rightAnimation.repeatCount = 0;
    rightAnimation.removedOnCompletion = NO;
    [moveLayer addAnimation:rightAnimation forKey:@"rightAnimation"];
}

@end



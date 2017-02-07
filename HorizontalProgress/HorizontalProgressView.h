//
//  HorizontalProgressView.h
//  HorizontalProgress
//
//  Created by AliThink on 15/10/28.
//  Copyright © 2015年 AliThink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ProgressLevelTextPosition) {
    topPostion,
    bottomPosition
};

@interface HorizontalProgressView : UIView

//Color of progress unachieved
@property(nonatomic, strong) UIColor *unachievedColor;
//Color of progress achieved
@property(nonatomic, strong) UIColor *achievedColor;
//Maximum progress point radius
@property(nonatomic, assign) CGFloat pointMaxRadius;
//Maximum progress line height
@property(nonatomic, assign) NSUInteger lineMaxHeight;
//Current progress level
@property(nonatomic, assign) NSInteger currentLevel;
//Current progress animation duration
@property(nonatomic, assign) CFTimeInterval animationDuration;
//Tip label position relative to progress line
@property(nonatomic, assign) ProgressLevelTextPosition textPosition;

//Array contained strings of progress tip label
@property(nonatomic, strong) NSArray<NSString *> *progressLevelArray;

//Progress fill animation start
- (void)startAnimation;

@end

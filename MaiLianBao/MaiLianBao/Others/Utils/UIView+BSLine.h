//
//  UIView+BSLine.h
//  Sports
//
//  Created by LBS on 8/8/15.
//  Copyright (c) 2015年 LBS. All rights reserved.
//  为UIView添加各种直线

#import <UIKit/UIKit.h>

@interface UIView (Line)

@property (nonatomic, assign) CGFloat lineWith;/**<线宽*/
@property (nonatomic, strong) UIColor *lineColor;/**<线颜色*/

/**为UIView添加底部的直线，距离左边距离left,距离右边距离right*/
- (void)addBottomLineWithLeftPading:(CGFloat)left andRightPading:(CGFloat)right;

/**为UIView添加顶部的直线，距离左边距离left,距离右边距离right*/
- (void)addTopLineWithLeftPading:(CGFloat)left andRightPading:(CGFloat)right;

/**为UIView添加左边的直线，距离顶部距离top,距离底部距离bottom*/
- (void)addLeftLineWithTopPading:(CGFloat)top andBottomPading:(CGFloat)bottom;

/**为UIView添加右边的直线，距离顶部距离top,距离底部距离bottom*/
- (void)addRightLineWithTopPaidng:(CGFloat)top andBottomPading:(CGFloat)bottom;

/**为UIView添加竖直的直线，距离顶部距离top,底部距离bottom,距离左边距离left*/
- (void)addVerLineWithPadingTop:(CGFloat)top
                         bottom:(CGFloat)bottom
                           left:(CGFloat)left;

/**为UIView添加水平的直线，距离顶部距离top,距离左边距离left,距离右边right*/
- (void)addHorLineWithPadingTop:(CGFloat)top
                           left:(CGFloat)left
                          right:(CGFloat)right;

@end

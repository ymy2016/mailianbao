//
//  UIView+BSLine.m
//  Sports
//
//  Created by LBS on 8/8/15.
//  Copyright (c) 2015年 LBS. All rights reserved.
//

#import "UIView+BSLine.h"
#import <objc/runtime.h>

#define KDefaultWidth 0.5//默认线条宽度
#define KDefaultColor  UIColorFromRGB(0xCCCCCC)//默认线条颜色

#define KSelfWidth self.frame.size.width
#define KSelfHeight self.frame.size.height

@implementation UIView (Line)

static char *LineWidthKey = "LineWidthKey";
static char *LineColorKey = "LineColorKey";

- (void)setLineWith:(CGFloat)lineWith
{
    objc_setAssociatedObject(self, LineWidthKey, [NSNumber numberWithFloat:lineWith], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (CGFloat)lineWith
{
    NSNumber *number = objc_getAssociatedObject(self, LineWidthKey);
    return number.floatValue;

}

- (void)setLineColor:(UIColor *)lineColor
{
    objc_setAssociatedObject(self, LineColorKey, lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)lineColor
{
    UIColor *color = objc_getAssociatedObject(self, LineColorKey);
    return color;
}

//为UIView添加底部的直线，距离左边距离left,距离右边距离right
- (void)addBottomLineWithLeftPading:(CGFloat)left andRightPading:(CGFloat)right
{
    CGFloat lineWidth = [self lineWidthDefault];
    UIColor *lineColor = [self lineColorDefault];
    
    UIView *bottomLine = [UIView new];
    [self addSubview:bottomLine];
    bottomLine.backgroundColor = lineColor;
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(lineWidth);
        make.right.equalTo(self).offset(right);
    }];

}

//为UIView添加顶部的直线，距离左边距离left,距离右边距离right
- (void)addTopLineWithLeftPading:(CGFloat)left andRightPading:(CGFloat)right
{
    CGFloat lineWidth = [self lineWidthDefault];
    UIColor *lineColor = [self lineColorDefault];
    
    UIView *topLine = [UIView new];
    [self addSubview:topLine];
    topLine.backgroundColor = lineColor;
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left);
        make.top.equalTo(self);
        make.height.mas_equalTo(lineWidth);
        make.right.equalTo(self).offset(right);
    }];

}

//为UIView添加左边的直线，距离顶部距离top,距离底部距离bottom
- (void)addLeftLineWithTopPading:(CGFloat)top andBottomPading:(CGFloat)bottom
{
    CGFloat lineWidth = [self lineWidthDefault];
    UIColor *lineColor = [self lineColorDefault];

    UIView *leftLine = [UIView new];
    [self addSubview:leftLine];
    leftLine.backgroundColor =  lineColor;
    
    leftLine.frame = CGRectMake(0, top, lineWidth, KSelfHeight-top+bottom);
}

//为UIView添加右边的直线，距离顶部距离top,距离底部距离bottom
- (void)addRightLineWithTopPaidng:(CGFloat)top andBottomPading:(CGFloat)bottom
{
    CGFloat lineWidth = [self lineWidthDefault];
    UIColor *lineColor = [self lineColorDefault];

    UIView *rigthLine = [UIView new];
    [self addSubview:rigthLine];
    rigthLine.backgroundColor = lineColor;
    
    rigthLine.frame = CGRectMake(KSelfWidth-lineWidth, top, lineWidth, KSelfHeight-top+bottom);
}

//为UIView添加竖直的直线，距离顶部距离top,底部距离bottom,距离左边距离left
- (void)addVerLineWithPadingTop:(CGFloat)top
                         bottom:(CGFloat)bottom
                           left:(CGFloat)left
{
    CGFloat lineWidth = [self lineWidthDefault];
    UIColor *lineColor = [self lineColorDefault];
    
    UIView *verLine = [UIView new];
    [self addSubview:verLine];
    verLine.backgroundColor = lineColor;
    
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left);
        make.top.equalTo(self).offset(top);
        make.width.mas_equalTo(lineWidth);
        make.bottom.equalTo(self).offset(-bottom);
    }];
}

//为UIView添加水平的直线，距离顶部距离top,距离左边距离left,距离右边right
- (void)addHorLineWithPadingTop:(CGFloat)top
                           left:(CGFloat)left
                          right:(CGFloat)right
{
    CGFloat lineWidth = [self lineWidthDefault];
    UIColor *lineColor = [self lineColorDefault];
    
    UIView *horLine = [UIView new];
    [self addSubview:horLine];
    horLine.backgroundColor = lineColor;
    
//    horLine.frame = CGRectMake(left, top, KSelfWidth-left+right, lineWidth);
    
    [horLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left);
        make.top.equalTo(self).offset(top);
        make.right.equalTo(self).offset(right);
        make.height.mas_equalTo(lineWidth);
    }];

    
}

//设置线条宽度
- (CGFloat)lineWidthDefault
{
    if (self.lineWith)
    {
        return self.lineWith;
    }
    else
    {
        return KDefaultWidth;
    }
}

//设置线条颜色
- (UIColor *)lineColorDefault
{
    if (self.lineColor)
    {
        return self.lineColor;
    }
    else
    {
        return KDefaultColor;
    }
}

@end

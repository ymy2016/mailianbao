//
//  BSFitdpiUtils.h
//  Sports
//
//  Created by solesson on 30/6/15.
//  Copyright (c) 2015年 com.mykar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IphoneType){
    Ip4s,
    Ip5,
    Ip6,
    Ip6p,
    IpX
};

@interface BSFitdpiUtils : NSObject

// 根据屏幕尺寸判断手机类型
+ (IphoneType)adaptReturnDeviceName;

// 传进来的数字根据屏幕来返回对应的计算值
+ (CGFloat)adaptSizeWithCGFloat:(CGFloat)floatV;

// 按照设备宽度来计算对应的数字(以iphone 5为参照)
+ (CGFloat)adaptWidthWithCGFloat:(CGFloat)floatV;

// 按照设备高度来计算对应的数字(以iphone 5为参照)
+ (CGFloat)adaptHeightWithCGFloat:(CGFloat)floatV;

// 按照设备高度来计算对应的数字(以iphone 5为参照)-为了适配4s
+ (CGFloat)adaptIp4sWithCGFloat:(CGFloat)floatV;

@end

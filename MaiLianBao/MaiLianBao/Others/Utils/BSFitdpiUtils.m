//
//  BSFitdpiUtils.m
//  Sports
//
//  Created by solesson on 30/6/15.
//  Copyright (c) 2015年 com.mykar. All rights reserved.
//

#import "BSFitdpiUtils.h"

@implementation BSFitdpiUtils

+ (IphoneType)adaptReturnDeviceName
{
    // 判断是什么机型的手机
    IphoneType type;
    switch ((int)kScreenH) {
        case 480:
            type = Ip4s;
            break;
        case 568:
            type = Ip5;
            break;
        case 667:
            type = Ip6;
            break;
        case 736:
            type = Ip6p;
            break;
        case 812:
            type = IpX;
            break;
        default:
            type = Ip5;
            break;
    }
    return type;
}

+ (CGFloat)adaptSizeWithCGFloat:(CGFloat)floatV
{
    // 根据传进来的值和4英寸的比较，进行计算
    switch ((int)kScreenH) {
        case 568:
            break;
        case 667:
            floatV = floatV * 1.17;
            break;
        case 736:
            floatV = floatV *1.3;
            break;
        default:
            break;
    }
    return floatV;
}

+ (CGFloat)adaptWidthWithCGFloat:(CGFloat)floatV
{
    /*
     换算原理:
      375 为4.7寸iphone的宽度
      实际需要的宽度/当前设备的宽度 = 依据4.7寸屏幕所设置的宽度/375;
      实际需要的宽度 =（当前设备的宽度*依据4.7寸屏幕所设置的宽度)/375;
    */
    
    // 根据传进来的值和4.7英寸的比较，进行计算
    return floatV * kScreenW/375.0;
}

+ (CGFloat)adaptHeightWithCGFloat:(CGFloat)floatV
{
    // 根据传进来的值和4.7英寸的比较，进行计算
//    if (kScreenH == 480.0) {
//        // 4s不适配高度
//        return floatV;//不适配高度
//    }else{
//        return floatV*kScreenH/667.0;
//    }
    
    return floatV * kScreenH/667.0;
}

+ (CGFloat)adaptIp4sWithCGFloat:(CGFloat)floatV
{
    // 根据传进来的值和4.7英寸的比较，进行计算（即使是4s也要进行高度换算）
    return floatV * kScreenH/667.0;
}

@end

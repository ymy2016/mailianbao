//
//  CommonMacro.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

// 屏幕宽
#define kScreenW  [[UIScreen mainScreen] bounds].size.width
// 屏幕高
#define kScreenH  [[UIScreen mainScreen] bounds].size.height

// 通用颜色设置
#define RGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 弱化self对象，防止block内部循环引用
#define weakSelf(self) __weak typeof(self)weakSelf = self

// 屏幕适配
#import "BSFitdpiUtils.h"
// 宽度等比例缩放
#define AdaptW(floatValue) [BSFitdpiUtils adaptWidthWithCGFloat:(floatValue)]
// 高度等比例缩放
#define AdaptH(floatValue) [BSFitdpiUtils adaptHeightWithCGFloat:(floatValue)]
// 字体比例(以iPhone6的屏幕宽度为基准)
#define AdaptFont(floatValue) (kScreenW / 375.0f * floatValue)

#define Adaptation(value) ((value)/375.0f * [UIScreen mainScreen].bounds.size.width)

#define mWindow [[[UIApplication sharedApplication] windows] lastObject]
#define KeyWindow [UIApplication sharedApplication].keyWindow

//// 状态栏高度
//#define kStatusHeight 20
//// 导航栏高度
//#define kNavigationHeight 44
//// 顶部状态栏＋导航栏
//#define kTopSubHeight (kStatusHeight+kNavigationHeight)
//// tabbar高度
//#define kTabBarHeight 49
#define iPhoneX     (kScreenW == 375.f && kScreenH == 812.f ? YES : NO)

#define kNavigationHeight         44.f
#define kTabBarHeight         (iPhoneX ? (49.f + 34.f) : 49.f)
#define kTopSubHeight         (kNavigationHeight + kStatusHeight)
#define kStatusHeight       (iPhoneX ? 44.f : 20.f)
#define kTabbarSafeBottomMargin (iPhoneX ? 34.f : 0.f)
#define kViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})
// 当前app版本
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 吐司消失时间
#define ToastDisTime 2.0

// 左侧菜单切换用户的通知
#define SwithUserNotice @"SwithUserNotice"

// 扫码入库通知
#define ScanStorageNotice @"ScanStorageNotice"

// 控制打印
#ifdef DEBUG  //调试阶段
#define NSLog(...) NSLog(__VA_ARGS__)
#else         //发布阶段
#define NSLog(...)
#endif

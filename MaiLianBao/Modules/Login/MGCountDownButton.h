//
//  MGCountDownButton.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGCountdownButtonDelegate;

@interface MGCountDownButton : UIButton

@property (nonatomic, assign) NSInteger countdownBeginNumber;
@property (nonatomic, copy) NSString * normalBgImageName;
@property (nonatomic, copy) NSString * selectedBgImageName;
@property (nonatomic, copy) NSString * normalTitle;
@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, weak) id<MGCountdownButtonDelegate> delegate;
// 页面将要进入前台,开启定时器
- (void)distantPastTimer;

// 页面消失,进入后台不显示该页面,关闭定时器
- (void)distantFutureTimer;

- (void)countdownStop;
- (void)countdownBegin;

@end

// 倒计时Btn协议
@protocol MGCountdownButtonDelegate <NSObject>

- (void)countdownBtnClicked:(MGCountDownButton *)btn;

@end

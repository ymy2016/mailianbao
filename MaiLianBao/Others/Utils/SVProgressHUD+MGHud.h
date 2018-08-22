//
//  SVProgressHUD+MGHud.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "SVProgressHUD.h"
#import <objc/runtime.h>

@interface SVProgressHUD (MGHud)

/// 自定义方法，采用统一样式
+ (void)showWithTips:(NSString *)tips;

// 吐司弹窗
+ (void)showWithToast:(NSString *)toast superView:(UIView *)superView;

@end

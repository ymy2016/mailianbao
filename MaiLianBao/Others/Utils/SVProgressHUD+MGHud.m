//
//  SVProgressHUD+MGHud.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "SVProgressHUD+MGHud.h"

// 类别，不能再写拓展，只能给类添加拓展
@interface SVProgressHUD ()

// 吐司Lab
@property(nonatomic,strong)UILabel *toastLab;

@end

static SVProgressHUD *sharedInstance = nil;

static char *ToastLabKey = "ToastLabKey";

@implementation SVProgressHUD (MGHud)

+ (SVProgressHUD *)sharedInstance
{
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        sharedInstance = [[SVProgressHUD alloc] init];
    });
    
    return sharedInstance;
}

+ (void)showWithTips:(NSString *)tips
{
    [SVProgressHUD showWithStatus:tips];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

+ (void)showWithToast:(NSString *)toast superView:(UIView *)superView
{
    SVProgressHUD *svp = [SVProgressHUD sharedInstance];
    [svp makeToast:toast superView:superView];
}

#pragma mark - private
- (void)makeToast:(NSString *)toast superView:(UIView *)superView
{
    if (self.toastLab == nil)
    {
        UILabel *toastLab = [[UILabel alloc] init];
        self.toastLab = toastLab;
        toastLab.alpha = 0.9;
        toastLab.backgroundColor = RGB(0, 0, 1, 0.7);
        toastLab.textAlignment = NSTextAlignmentCenter;
        toastLab.text = toast;
        toastLab.numberOfLines = 0;
        toastLab.textColor = [UIColor whiteColor];
        toastLab.font = [UIFont systemFontOfSize:AdaptFont(14)];
        toastLab.layer.cornerRadius = AdaptW(7);
        toastLab.layer.masksToBounds = YES;
        [superView addSubview:toastLab];
        
        [toastLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(superView);
            make.width.mas_equalTo(AdaptW(150));
            make.height.mas_greaterThanOrEqualTo(AdaptH(45));
        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ToastDisTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 先移除，再置为nil
            [self.toastLab removeFromSuperview];
            self.toastLab = nil;
        });
    }
   
}

- (void)setToastLab:(UILabel *)toastLab
{
   objc_setAssociatedObject(self, ToastLabKey, toastLab, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)toastLab
{
   return objc_getAssociatedObject(self, ToastLabKey);
}

@end

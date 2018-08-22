//
//  MGPlusButtonSubclass.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPlusButtonSubclass.h"
#import "CYLTabBarController.h"
#import "MGQRViewController.h"
#import "MGNavigationController.h"

@implementation MGPlusButtonSubclass

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

// 上下结构的Button
- (void)layoutSubviews
{
    [super layoutSubviews];
}

//+ (NSUInteger)indexOfPlusButtonInTabBar{
//
//    MGUserModel *model = [MGUserDefaultUtil getUserInfo];
//    // 显示首页item,(除扫码item外还有4个item)
//    if (model.isHomeAuth) {
//        return 2;
//    }
//    // 不显示首页item(除扫码item外还有3个item)
//    else{
//        return 0;
//    }
//}

+ (id)plusButton
{
    
    MGPlusButtonSubclass *button = [[MGPlusButtonSubclass alloc] init];
    UIImage *buttonImage = [UIImage imageNamed:@"plus_normal"];
    [button setImage:buttonImage forState:UIControlStateNormal];
    
    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
    //    button.frame = CGRectMake(0.0, 0.0, 250, 100);
    //    button.backgroundColor = [UIColor redColor];
    
    // if you use `+plusChildViewController` , do not addTarget to plusButton.
    [button addTarget:button action:@selector(clickPlusButton) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}

#pragma mark - MGPlusButtonSubclassing
+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight
{
    if (iPhoneX) {
        return 0.3;
    }
    return 0.5;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight
{
    return  0;
}

#pragma mark -
#pragma mark - Event Response

- (void)clickPlusButton
{
//    CYLTabBarController *tabBarController = [self cyl_tabBarController];
//    UIViewController *viewController = tabBarController.selectedViewController;
//
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    MGQRViewController *scanVC = [[MGQRViewController alloc] initWitType:QRTypeInput];
    scanVC.navigationItem.title = @"扫码录入";
    MGNavigationController *nav = [[MGNavigationController alloc] initWithRootViewController:scanVC];
    [window.rootViewController presentViewController:nav animated:YES completion:nil];
}
@end

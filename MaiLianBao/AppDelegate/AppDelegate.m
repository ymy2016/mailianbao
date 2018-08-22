//
//  AppDelegate.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "AppDelegate.h"
#import "MGSerTabbarViewController.h"
#import "MGSerLoginViewController.h"
#import "MGLeftMenuViewController.h"
#import "YTKNetworkConfig.h"
#import "MGUserDefaultUtil.h"
#import "RESideMenu.h"

#import "MGLoginRootViewController.h"
#import "MGPerTabbarController.h"
#import "WXApi.h"
#import "MGPlusButtonSubclass.h"
#import "MGPerModifyAccountViewController.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 崩溃日志发送到邮箱
    // NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    // 创建window
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    // 配置baseURL
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    config.baseUrl = URL_Base;

    // 微信sdk
    [WXApi registerApp:WXAppID withDescription:WXAppSecret];
    
    [self handlePerRootVC];
    
//  [self addNetworkMonitor];
    
//  MGPerTabbarController *perVC = [[MGPerTabbarController alloc] init];
//  [UIApplication sharedApplication].keyWindow.rootViewController = perVC;
    
    return YES;
}

// TODO:处理根控制器
- (void)handleRootVC
{
    MGUserModel *userModel = [MGUserDefaultUtil getUserInfo];
    
    if (userModel == nil)
    {
        MGLoginRootViewController *mgRootVC = [[MGLoginRootViewController alloc] init];
        
        // [UIApplication sharedApplication].key Window.rootViewController = mgRootVC;
        
        self.window.rootViewController = mgRootVC;
    }
    else
    {
        // 逻辑用户一定没有扫码入库功能
        if (userModel.userType ==3)
        {
            [MGPlusButtonSubclass removePlusButton];
        }
        else
        {
            if (userModel.isCanDistribute == 1) {
                // 此时状态才有入库功能
                [MGPlusButtonSubclass registerPlusButton];
            }
            else
            {
                [MGPlusButtonSubclass removePlusButton];
            }
        }
        
        MGSerTabbarViewController *mgTabbarVC = [[MGSerTabbarViewController alloc] init];
        
        MGLeftMenuViewController *mgLeftVC = [[MGLeftMenuViewController alloc] init];
        
        RESideMenu *mgRootVC = [[RESideMenu alloc] initWithContentViewController:mgTabbarVC leftMenuViewController:mgLeftVC rightMenuViewController:nil];
        mgRootVC.contentViewShadowEnabled = YES;
        mgRootVC.contentViewShadowColor = [UIColor blackColor];
        mgRootVC.scaleContentView = YES;
        mgRootVC.contentViewScaleValue = 0.6;
        mgRootVC.backgroundImage = [UIImage imageNamed:@"listBackImg"];
        
        // [UIApplication sharedApplication].keyWindow.rootViewController = mgRootVC;
        self.window.rootViewController = mgRootVC;
    }
}

- (void)handlePerRootVC
{
    MGUserModel *userModel = [MGUserDefaultUtil getUserInfo];
    MGPerUserModel *perUserModel = [MGUserDefaultUtil getPerUserInfo];
    
    if (userModel == nil && perUserModel == nil)
    {
        MGLoginRootViewController *rootVC = [[MGLoginRootViewController alloc] init];
        // [UIApplication sharedApplication].keyWindow.rootViewController = rootVC;
        self.window.rootViewController = rootVC;
    }
    else
    {
        if (userModel)
        {
            NSLog(@"%@, %@", @(userModel.userType), @(userModel.isCanDistribute));
            // 逻辑用户一定没有扫码入库功能
            if (userModel.userType == 3)
            {
                [MGPlusButtonSubclass removePlusButton];
            }
            else
            {
                if (userModel.isCanDistribute == 1) {
                    // 此时状态才有入库功能
                    [MGPlusButtonSubclass registerPlusButton];
                }
                else
                {
                    [MGPlusButtonSubclass removePlusButton];
                }
            }
            
            if (userModel.isHomeAuth == 0) {
                [MGPlusButtonSubclass removePlusButton];
            }
            
            MGSerTabbarViewController *mgTabbarVC = [[MGSerTabbarViewController alloc] init];
            
            MGLeftMenuViewController *mgLeftVC = [[MGLeftMenuViewController alloc] init];
            
            RESideMenu *mgRootVC = [[RESideMenu alloc] initWithContentViewController:mgTabbarVC leftMenuViewController:mgLeftVC rightMenuViewController:nil];
            mgRootVC.contentViewShadowEnabled = YES;
            mgRootVC.contentViewShadowColor = [UIColor blackColor];
            mgRootVC.scaleContentView = YES;
            mgRootVC.contentViewScaleValue = 0.6;
            mgRootVC.backgroundImage = [UIImage imageNamed:@"listBackImg"];
            
            // [UIApplication sharedApplication].keyWindow.rootViewController = mgRootVC;
            self.window.rootViewController = mgRootVC;
            
            mgTabbarVC.selectedIndex = 0;
        }
        
        if (perUserModel)
        {
            MGPerTabbarController *perVC = [[MGPerTabbarController alloc] init];
            // [UIApplication sharedApplication].keyWindow.rootViewController = perVC;
            self.window.rootViewController = perVC;
        }
    }
    
}

// TODO:添加网络监控
- (void)addNetworkMonitor
{
    AFNetworkReachabilityManager *networkMonitor = [AFNetworkReachabilityManager sharedManager];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [networkMonitor setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status){
            case -1:
                [MGAlertUtil mg_alertWithTitle:@"当前网络未知" superController:rootVC sureBtnActionBlock:nil];
                break;
            case 0:
                [MGAlertUtil mg_alertWithTitle:@"当前网络已断开" superController:rootVC sureBtnActionBlock:nil];
                break;
            case 1:
                [MGAlertUtil mg_alertWithTitle:@"当前网络环境为蜂窝数据，\n继续浏览会产生相应流量费用" superController:rootVC sureBtnActionBlock:nil];
                break;
            case 2:
//              [MGAlertUtil mg_alertWithTitle:@"当前网络环境为WIFI" superController:rootVC];
                break;
            default:
                break;
        }
        
    }];
    
    [networkMonitor startMonitoring];
}

void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    
    /**
     *  把异常崩溃信息发送至开发者邮件
     */
    NSMutableString *mailUrl = [NSMutableString string];
    [mailUrl appendString:@"mailto://1137@mapgoo.net"];
    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
    [mailUrl appendFormat:@"&body=%@", content];
    // 打开地址
    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kWXPayResultNotification" object:resp];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [JSPatch sync];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

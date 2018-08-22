//
//  MGViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGViewController.h"
#import "NavButton.h"
#import "MGNavigationController.h"

@interface MGViewController ()

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加上此句，支持自定义左侧返回按钮后，仍旧支持侧滑pop功能
//  self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.backgroundColor = UIColorFromRGB(0xf3f3f3);
    
//  self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNavUI];
}

- (void)initNavUI
{    
    // 适配导航栏title字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:AdaptFont(19)]
                                                                      
                                                                      }];
    
    // 判断视图控制器，的导航控制器是 MGNavigationController类，才进行下一步操作
    if ([self.navigationController isKindOfClass:[MGNavigationController class]])
    {
        // 如果不是导航控制器的根控制器，添加自定义返回按钮
        if (self.navigationController.viewControllers.count != 1)
        {
            // 使用delegate的方式，方便子控制器重写 - (void)back 方法
            self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"back" delegate:self];
        }
        else if (self.presentingViewController)
        {
            weakSelf(self);
            self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"back" btnActionBlock:^{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }
}

/*
 子类实现 - (void)back 方法：
 1、实质上是实现delegate的back方法，因为子类继承父类所遵循的协议
 2、在.h里面开放父类的back方法，实质是为了子类[super back]调用
*/
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 请求成功
- (void)requestFinished:(YTKBaseRequest *)request
{
    [SVProgressHUD dismiss];
}

// 请求失败
- (void)requestFailed:(YTKBaseRequest *)request
{
    [SVProgressHUD dismiss];
    
    NSDictionary *dic = request.responseJSONObject;
    
    if (NetParse.reason(dic).length == 0)
    {
        [SVProgressHUD showWithToast:@"网络连接失败" superView:self.view];
    }
    else
    {
        [SVProgressHUD showWithToast:NetParse.reason(dic) superView:self.view];
    }
}


@end

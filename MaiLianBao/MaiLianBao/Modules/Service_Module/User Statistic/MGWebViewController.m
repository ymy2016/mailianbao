//
//  MGWebViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGWebViewController.h"
#import "MGWebView.h"

@interface MGWebViewController ()
@property (nonatomic,strong)MGWebView *mgWebView;
@property (nonatomic,copy) NSString *urlStr;
@end

@implementation MGWebViewController

- (instancetype)initWihtURL:(NSString *)url
{
    if (self = [super init])
    {
        self.urlStr = url;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWihtURL:(NSString *)url
                      title:(NSString *)title
{
    if (self == [self initWihtURL:url])
    {
        self.navigationItem.title = title;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self handleNavBack];
    
    [self.view addSubview:self.mgWebView];
}

// 处理导航栏返回按钮
- (void)handleNavBack
{
    self.navigationItem.leftBarButtonItem = [[NavButton alloc] initWithBtnImg:@"back" btnActionBlock:^{
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        // push方式进入
        if (viewControllers.count > 1)
        {
//            self.navigationController.navigationBarHidden = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
        // present方式进入
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (MGWebView *)mgWebView
{
    if (_mgWebView == nil)
    {
        _mgWebView = [[MGWebView alloc] initWithFrame:self.view.bounds urlStr:self.urlStr];
    }
    return _mgWebView;
}


@end

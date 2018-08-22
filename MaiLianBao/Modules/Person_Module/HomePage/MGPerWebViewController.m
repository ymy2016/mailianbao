//
//  MGPerWebViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerWebViewController.h"

@interface MGPerWebViewController () <ZLCWebViewDelegate>
@property (nonatomic, strong) ZLCWebView *webView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *closeButton;
// 保存的网址链接
@property (nonatomic, strong) NSURL *URL;
@end

@implementation MGPerWebViewController


- (void)loadWebURL:(NSURL *)URL
{
    self.URL = URL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 加载网络连接
    [self loadWebView];
    
    // 添加导航栏上的按钮
    [self setupNav];
    
    // 添加到主控制器
    [self.view addSubview:self.webView];
}

- (void)setupNav
{
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:self.backView];
    self.navigationItem.leftBarButtonItem = backBar;
}

- (void)loadWebView
{
    NSURLRequest *requstURL = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.webView loadRequest:requstURL];
}

#pragma mark - WebView Delegate
- (void)zlcwebViewDidStartLoad:(ZLCWebView *)webview
{
    NSLog(@"页面开始加载");
}

- (void)zlcwebView:(ZLCWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    NSLog(@"截取到URL：%@",URL);
}
- (void)zlcwebView:(ZLCWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    NSLog(@"页面加载完成");
    
    self.navigationItem.title = [webview title];
    
    [self updateNavigationItems];
}

- (void)zlcwebView:(ZLCWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    NSLog(@"加载出现错误");
    [self updateNavigationItems];
}

#pragma mark - 点击时间

- (void)backButtonClicked:(UIButton *)button
{
    if (self.webView.canGoBack)
    {
        [self.webView goBack];
        self.closeButton.hidden = NO;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateNavigationItems
{
    if (self.webView.canGoBack)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.closeButton.hidden = NO;
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.closeButton.hidden = YES;
    }
}

#pragma mark - 懒加载

- (ZLCWebView *)webView
{
    if (!_webView) {
        _webView = [[ZLCWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopSubHeight)];
        _webView.delegate = self;
        [_webView setProgressTop:0];
        [_webView setTintColor:[UIColor orangeColor]];
    }
    return _webView;
}

- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"nav_per_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
        _closeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _closeButton.frame = CGRectMake(self.backButton.right, 0, 44, 44);
        [_closeButton setImage:[UIImage imageNamed:@"nav_per_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.hidden = YES;
    }
    return _closeButton;
}

- (UIView *)backView
{
    if (!_backView)
    {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
        [_backView addSubview:self.backButton];
        [_backView addSubview:self.closeButton];
    }
    return _backView;
}


@end

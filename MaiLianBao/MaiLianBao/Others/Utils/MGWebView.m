//
//  MGWebView.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/26.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGWebView.h"

@interface MGWebView ()<UIWebViewDelegate>

@end

@implementation MGWebView

- (instancetype)initWithFrame:(CGRect)frame
                       urlStr:(NSString *)urlStr
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
       
        if (urlStr.length != 0)
        {
            NSURL *requestUrl = [NSURL URLWithString:urlStr];
            [self loadRequest:[NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120]];
            NSLog(@"访问的url===>%@",urlStr);
        }
        else
        {
            NSLog(@"传入的urlStr为空");
        }
        
      
    }

    return self;
}

// 加载url
- (void)loadUrlStr:(NSString *)urlStr
{
    if (urlStr.length != 0)
    {
        NSURL *requestUrl = [NSURL URLWithString:urlStr];
        [self loadRequest:[NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120]];
        NSLog(@"访问的url===>%@",urlStr);
    }
    else
    {
        NSLog(@"传入的urlStr为空");
    }

}

#pragma mark - UIWebViewDelegate
// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}
// 加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == NSURLErrorNotConnectedToInternet)
    {
        [SVProgressHUD showInfoWithStatus:@"获取失败,请检查您的网络后重试!"];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"加载失败,请重试"];
    }
}

// js与oc交互协议
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    return YES;
}


- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end

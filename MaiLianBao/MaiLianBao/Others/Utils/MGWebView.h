//
//  MGWebView.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/26.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGWebView : UIWebView

/// 初始化webView同时加载url
- (instancetype)initWithFrame:(CGRect)frame
                   urlStr:(NSString *)urlStr;
/// 加载url
- (void)loadUrlStr:(NSString *)urlStr;

@end

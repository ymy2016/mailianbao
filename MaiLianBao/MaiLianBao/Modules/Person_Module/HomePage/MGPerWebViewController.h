//
//  MGPerWebViewController.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCWebView.h"

@interface MGPerWebViewController : UIViewController

/**
 加载纯外部链接网页

 @param URL地址
 */
- (void)loadWebURL:(NSURL *)URL;

@end

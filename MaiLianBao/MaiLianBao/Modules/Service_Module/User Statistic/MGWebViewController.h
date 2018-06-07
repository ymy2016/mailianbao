//
//  MGWebViewController.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGViewController.h"

@interface MGWebViewController : MGViewController

/// 载入url
- (instancetype)initWihtURL:(NSString *)url;

/// 载入url，设置title
- (instancetype)initWihtURL:(NSString *)url
                      title:(NSString *)title;
@end

//
//  MGViewController.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavButton.h"

@interface MGViewController : UIViewController<NavLeftBtnDelegate,YTKRequestDelegate,YTKBatchRequestDelegate,YTKChainRequestDelegate>

// 导航栏左侧自定义按钮响应方法(便于子类调用)
- (void)back;

@end

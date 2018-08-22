//
//  MGHeaderView.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGHPRebateModel;
@interface MGHeaderView : UIView

@property (nonatomic, strong) MGHPRebateModel *rebateModel;
@property (nonatomic, copy) void(^HeaderBlock)();

@end

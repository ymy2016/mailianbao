//
//  MGFlowCardHeaderView.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCardEnum.h"

@class MGFlowInfoModel;
@interface MGFlowCardHeaderView : UIView
- (instancetype)initWithCardType:(SimCardType)type;

@property (nonatomic, strong) MGFlowInfoModel *infoModel;
@end

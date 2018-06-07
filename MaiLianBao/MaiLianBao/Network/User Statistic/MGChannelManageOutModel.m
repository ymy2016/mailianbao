//
//  MGChannelManageOutModel.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/12.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGChannelManageOutModel.h"

// 渠道管理输出模型
@implementation MGChannelManageOutModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"rptUserGrowthTrendEntity":@"MGGrowthTrendOutModel",
             @"rptUserSynthesisUseEntity":@"MGUserSynthesisUseOutModel",
             @"holdDeviceTypeEntity":@"MGDeviceTypeOutModel"
             };
}

@end

// 用户增长趋势
@implementation MGGrowthTrendOutModel

@end

// 用户综合使用情况汇总
@implementation MGUserSynthesisUseOutModel

- (id)mutableCopyWithZone:(NSZone *)zone{
    
    MGUserSynthesisUseOutModel *model = [[MGUserSynthesisUseOutModel alloc] init];
    model.HoldName = self.HoldName;
    model.TotalCardNum = self.TotalCardNum;
    model.Used = self.Used;
    model.RegisterUser = self.RegisterUser;
    model.RealNameUser = self.RealNameUser;
    model.ActiveUser = self.ActiveUser;
    model.WeChatFollow = self.WeChatFollow;
    model.FirstActivation = self.FirstActivation;
    model.FirstRenew = self.FirstRenew;
    model.Stopped = self.Stopped;
    model.RenewAmount = self.RenewAmount;
    model.RebateAmount = self.RebateAmount;
    model.RenewCount = self.RenewCount;
    model.UsageRate = self.UsageRate;
    model.OutageRate = self.OutageRate;
    model.FollowRate = self.FollowRate;
    model.RealNameRate = self.RealNameRate;
    model.PhoneBindRate = self.PhoneBindRate;
    model.RenewalRate = self.RenewalRate;
    model.maxValue = self.maxValue;
    
    return model;
}

@end

// 用户设备类型
@implementation MGDeviceTypeOutModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.isSel = true;
    }
    
    return self;
}

@end

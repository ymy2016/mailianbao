//
//  MGFlowInfoModel.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowInfoModel.h"

@implementation MGRenewalsOrder
@end

@implementation MGHistoryMonthUsage
@end

@implementation MGUnicomUsage
@end

@implementation MGYDSimBill
@end

@implementation MGFlowInfoModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"renewalsOrderList" : @"MGRenewalsOrder",
             @"historyMonthUsageList" : @"MGHistoryMonthUsage",
             @"ydSimBillList" : @"MGYDSimBill"
             };
}
@end

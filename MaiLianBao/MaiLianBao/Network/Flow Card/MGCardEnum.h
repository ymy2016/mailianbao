//
//  MGCardEnum.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/3.
//  Copyright © 2016年 Twh. All rights reserved.
//


typedef NS_ENUM(NSInteger, SimCardType)
{
    
    SimCardForCMCC = 0, // 中国移动
    SimCardForCUCC,     // 中国联通
    SimCardForCTCC,      // 中国电信
    SimCardForNULL = 99999999
};

typedef NS_ENUM(NSInteger, SimCardStateType)
{
    SimCardStateUnActivation = 1, // 未激活
    SimCardStateNormal,
    SimCardStateStop
};

typedef NS_ENUM(NSInteger, SimGetInfoType)
{
    SimGetWithListType= 0,      // 列表获取
    SimGetWithScanType,         // 扫码获取
};

typedef NS_ENUM(NSInteger, SimDataType)
{
    ThisMonthData = 0,
    LastMonthData,
    AllMonthData
};
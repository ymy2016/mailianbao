//
//  MGFlowInfoRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowInfoRequest.h"
#import "MGCardEnum.h"

@implementation MGFlowInfoRequest
{
    NSInteger _simId;
    NSInteger _key;
    SimGetInfoType _type;
}


- (instancetype)initWithSimId:(NSInteger)simId
{
    self = [super init];
    if (self)
    {
        _simId = simId;
        _type = SimGetWithListType;
    }
    return self;
}

- (instancetype)initWithKey:(NSInteger)key
{
    self = [super init];
    if (self)
    {
        _key = key;
        _type = SimGetWithScanType;
    }
    return self;
}

- (NSString *)requestUrl
{
    if (_type == SimGetWithScanType)
    {
        return URL_SimInfoByScan;
    }
    return URL_SimInfo;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (NSInteger)cacheTimeInSeconds
{
    return 60;
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 30;
}

- (id)requestArgument
{
    if (_type == SimGetWithScanType)
    {
        return @{
                 @"key" : @(_key)
                 };
    }
    return @{
             @"simId" : @(_simId)
             };
}

@end

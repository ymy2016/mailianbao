//
//  MGUnicomUsageRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/9.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGUnicomUsageRequest.h"

@implementation MGUnicomUsageRequest
{
    NSInteger _simId;
}

- (instancetype)initWithSimId:(NSInteger)simId
{
    self = [super init];
    if (self)
    {
        _simId = simId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return URL_UnicomUsage;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (NSInteger)cacheTimeInSeconds
{
    return 60;
}

- (id)requestArgument
{
    return @{
             @"simId" : @(_simId)
             };
}
@end

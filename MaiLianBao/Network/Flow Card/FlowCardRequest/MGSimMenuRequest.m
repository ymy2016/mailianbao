//
//  MGSimMenuRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGSimMenuRequest.h"

@implementation MGSimMenuRequest
{
    NSInteger _holdId;
}

- (instancetype)initWithHoldId:(NSInteger)holdId
{
    self = [super init];
    if (self)
    {
        _holdId = holdId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return URL_SimParamList;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (id)requestArgument
{
    return @{
             @"holdId" : @(_holdId)
             };
}

// 增加了一个3分钟的缓存，3分钟内调用调Api的start方法，实际上并不会发送真正的请求
- (NSInteger)cacheTimeInSeconds
{
    return 60;
}

//- (NSTimeInterval)requestTimeoutInterval
//{
//    return 30;
//}

// 请求的优先级
- (YTKRequestPriority)requestPriority
{
    return YTKRequestPriorityHigh;
}

- (SimCardType)simFromType
{
    NSDictionary *dic = self.responseJSONObject;
    NSArray *array = dic[@"result"][@"simFromTypelist"];
    if (0 != [array count]) {
        return [array[0][@"id"] integerValue];
    }
    return 0;
}
@end

//
//  MGHPDistributeLog.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/6.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGHPDistributeLog.h"

@interface MGHPDistributeLog ()

@property(nonatomic,assign)NSInteger holdId;

@end

@implementation MGHPDistributeLog

- (instancetype)initWithHoldId:(NSInteger)holdId
{
    if (self = [super init])
    {
        _holdId = holdId;
    }
    return self;
}

- (NSString *)requestUrl
{
    return URL_DistributeLog;
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
@end

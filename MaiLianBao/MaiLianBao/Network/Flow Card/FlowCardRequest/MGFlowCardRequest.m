//
//  MGFlowCardRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowCardRequest.h"

@implementation MGFlowCardParams

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.holdId = HoldId;
        self.P = 1;
    }
    return self;
}

+ (instancetype)param
{
    return [[self alloc] init];
}
@end


@implementation MGFlowCardRequest
{
    MGFlowCardParams *_param;
}

- (instancetype)initWithParam:(MGFlowCardParams *)param
{
    self = [super init];
    if (self)
    {
        _param = param;
    }
    return self;
}

- (NSString *)requestUrl
{
    return URL_SimList;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
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
    return [_param mj_keyValues];
}

@end

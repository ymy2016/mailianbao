//
//  MGHPRebateRequest.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGHPRebateRequest.h"

@interface MGHPRebateRequest ()

@property(nonatomic,assign)NSInteger holdId;
@property(nonatomic,assign)NSInteger isSync;

@end

@implementation MGHPRebateRequest

- (instancetype)initWithHoldId:(NSInteger)holdId
                        isSync:(NSInteger)isSync
{
    if (self = [super init])
    {
        _holdId = holdId;
        _isSync = isSync;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return URL_HPRebate;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (id)requestArgument
{
    return @{
             @"isSync":@(_isSync),
             @"holdId":@(_holdId)
             };
}

@end

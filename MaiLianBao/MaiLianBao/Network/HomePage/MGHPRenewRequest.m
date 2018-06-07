//
//  MGHPRenewRequest.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGHPRenewRequest.h"

@interface MGHPRenewRequest ()

@property(nonatomic,assign)NSInteger holdId;

@end

@implementation MGHPRenewRequest

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
    return URL_HPRenew;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (id)requestArgument
{
    return @{
             @"holdId":@(_holdId)
             };
}

@end

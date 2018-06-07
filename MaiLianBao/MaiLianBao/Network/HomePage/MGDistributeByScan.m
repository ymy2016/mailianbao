//
//  MGDistributeByScan.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/6.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGDistributeByScan.h"

@interface MGDistributeByScan ()
@property (nonatomic, assign) NSInteger holdId;
@property (nonatomic, copy) NSString *str;
@property (nonatomic, assign) NSInteger userId;
@end

@implementation MGDistributeByScan

- (instancetype)initWithHoldId:(NSInteger)holdId userId:(NSInteger)userId str:(NSString *)str
{
    if (self = [super init])
    {
        _holdId = holdId;
        _userId = userId;
        _str = str;
    }
    return self;
}

- (NSString *)requestUrl
{
    return URL_DistributeByScan;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{
             @"holdId" : @(_holdId),
             @"str" : _str,
             @"userId" : @(_userId)
             };
}

@end

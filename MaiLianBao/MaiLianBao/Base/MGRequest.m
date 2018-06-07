//
//  MGRequest.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/26.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"

@implementation MGRequest

- (instancetype)init
{
    if (self = [super init])
    {
     
    }

    return self;
}

// 添加请求头，携带token
- (NSDictionary *)requestHeaderFieldValueDictionary
{
    if ([MGUserDefaultUtil getUserToken].length == 0)
    {
        return nil;
    }
   
    return @{
             @"Authorization":[MGUserDefaultUtil getUserToken]
//             @"Authorization":@"CEL7OO7LECQ991QA2RUY9S8FM5SQOG8C"
             };
}

@end

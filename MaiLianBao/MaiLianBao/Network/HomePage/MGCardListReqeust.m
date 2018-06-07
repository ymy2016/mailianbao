//
//  MGCardListReqeust.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/10.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGCardListReqeust.h"

@implementation MGCardListReqeust
{
    NSString *_token;
}


- (instancetype)initWithToken:(NSString *)token
{
    self = [super init];
    if (self) {
        _token = token;
    }
    return self;
}

- (NSString *)requestUrl
{
    return URL_Per_CardList;
}

- (id)requestArgument
{
    return @{
             @"token" : _token
             };
}
@end

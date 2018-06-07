//
//  MGRemoveBindRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/11.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGRemoveBindRequest.h"

@implementation MGRemoveBindRequest
{
    NSString *_token;
    NSString *_simID;
}

- (instancetype)initWithToken:(NSString *)token simID:(NSString *)simID
{
    self = [super init];
    if (self) {
        _token = token;
        _simID = simID;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)requestUrl
{
    return URL_Per_UnBind;
}

- (id)requestArgument
{
    return @{
             @"token" : _token,
             @"simId" : _simID
             };
}
@end

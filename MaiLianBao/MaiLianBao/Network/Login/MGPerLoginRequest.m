//
//  MGPerLoginRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/10.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerLoginRequest.h"

@implementation MGPerLoginRequest
{
    NSString *_mobile;
    NSString *_validcode;
}

- (instancetype)initWithMobile:(NSString *)mobile validcode:(NSString *)validcode
{
    self = [super init];
    if (self) {
        _mobile = mobile;
        _validcode = validcode;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (YTKRequestSerializerType)requestSerializerType
{
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)requestUrl
{
    return URL_Per_Login;
}

- (id)requestArgument
{
    return @{
             @"mobile":_mobile,
             @"validcode":_validcode,
             };
}

@end

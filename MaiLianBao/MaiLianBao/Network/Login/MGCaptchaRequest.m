//
//  MGCaptchaRequest.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/10.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGCaptchaRequest.h"

@implementation MGCaptchaRequest
{
    NSString *_mobile;
}

- (instancetype)initWithMobile:(NSString *)mobile
{
    self = [super init];
    if (self) {
        _mobile = mobile;
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
    return URL_Captcha;
}

- (id)requestArgument
{
    return @{
             @"mobile":_mobile,
             };
}

@end

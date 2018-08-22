//
//  MGCorrectUserInfoRequest.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/11.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerCorrectUserInfoRequest.h"

@interface MGPerCorrectUserInfoRequest ()

@property(nonatomic,strong)NSString *token;

@property(nonatomic,strong)NSString *nickName;

@property(nonatomic,strong)NSString *iconImage;

@end

@implementation MGPerCorrectUserInfoRequest

- (instancetype)initWithToken:(NSString *)token
                     nickName:(NSString *)nickName
                    iconImage:(NSString *)iconImage
                     showTips:(NSString *)showTips
                     delegate:(id<YTKRequestDelegate>)delegate{

    if (self = [super init]) {
        
        _token = token;
        _nickName = nickName;
        _iconImage = iconImage;
        self.delegate = delegate;
        [SVProgressHUD showWithTips:showTips];
        
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return URL_Per_CorrectUserInfo;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGet;
}

- (id)requestArgument
{
    return @{
             @"token":_token,
             @"nickName":_nickName,
             @"iconImage":_iconImage
             };
}

@end

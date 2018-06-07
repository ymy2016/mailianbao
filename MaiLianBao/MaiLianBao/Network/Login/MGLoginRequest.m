//
//  MGLoginRequest.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/26.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGLoginRequest.h"

@interface MGLoginRequest ()

@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *password;

@end

@implementation MGLoginRequest

- (instancetype)initWithUserName:(NSString *)userName
                        password:(NSString *)password
                        showTips:(NSString *)showTips
                        delegate:(id<YTKRequestDelegate>)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
        _userName = userName;
        _password = password;
        
       [SVProgressHUD showWithTips:showTips];
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl
{
    return URL_Login;
}

- (id)requestArgument
{
    return @{
             @"userName":_userName,
             @"password":_password
             };
}

@end

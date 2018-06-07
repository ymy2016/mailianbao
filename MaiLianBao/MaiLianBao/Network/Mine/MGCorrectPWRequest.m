//
//  MGCorrectPWRequest.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGCorrectPWRequest.h"

@interface MGCorrectPWRequest ()

@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString *oldPassword;
@property(nonatomic,strong)NSString *mNewPassword;

@end

@implementation MGCorrectPWRequest

- (instancetype)initWithUserId:(NSInteger)userId
                   OldPassword:(NSString *)oldPassword
                   newPassword:(NSString *)newPassword
                      showTips:(NSString *)showTips
                      delegate:(id<YTKRequestDelegate>)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
        
        _userId = userId;
        _oldPassword = oldPassword;
        _mNewPassword = newPassword;
        
        [SVProgressHUD showWithTips:showTips];
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return URL_CorrectPW;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{
             @"userId":@(_userId),
             @"oldPassword":_oldPassword,
             @"newPassword":_mNewPassword
             };
}

@end

//
//  MGUserModel.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/26.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGUserModel.h"

@implementation MGUserModel

- (NSString *)description
{
    NSString *showStr = [NSString stringWithFormat:@"\n userName = %@\n userId = %zd\n holdId = %zd\n holdName = %@\n token = %@\n isCanDistribute = %zd\n userType = %zd\n",self.userName,self.userId,self.holdId,self.holdName,self.token, self.isCanDistribute, self.userType];
   
    return showStr;
}

- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"_userType"]) {
        _userType = 0;
    }
    else if ([key isEqualToString:@"_isCanDistribute"])
    {
        _isCanDistribute = 0;
    }
    else if ([key isEqualToString:@"_isHomeAuth"])
    {
        _isHomeAuth = 1;
    }
    else if ([key isEqualToString:@"_isStateReport"])
    {
        _isStateReport = 1;
    }
    else
    {
        [super setNilValueForKey:key];
    }
}

@end


@implementation MGPerUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"token" : @"Token"};
}
@end

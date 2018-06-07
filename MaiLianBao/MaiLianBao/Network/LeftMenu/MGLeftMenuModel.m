//
//  MGLeftMenuModel.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGLeftMenuModel.h"

@implementation MGLeftMenuModel

- (NSString *)description
{
    NSString *showStr = [NSString stringWithFormat:@"\n name = %@\n isLogicalUser = %d\n mId = %zd\n",self.name, self.isLogicalUser, self.mId];
    
    return showStr;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"mId" : @"id"};
}

- (BOOL)isLogicalUser
{
    MGUserModel *userModel = [MGUserDefaultUtil getUserInfo];
    if (userModel.userType == 3 && userModel.holdId == HoldId)
    {
        return YES;
    }
    else
        return NO;
}
@end

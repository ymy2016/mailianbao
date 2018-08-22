//
//  MGUserDefaultUtil.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGUserDefaultUtil.h"

#define USERDEFAULTS_USER_INFO  @"userInfo"
#define USERDEFAULTS_MINE_INFO  @"mineInfo"
#define USERDEFAULTS_HOLDID     @"userHoldId"
#define USERDEFAULTS_USERNAME   @"userName"
#define USERDEFAULTS_CURRENT     @"current_user"

#define USERDEFAULTS_PERUSER_INFO @"perUserInfo"
#define USERDEFAULTS_PERUSERNAME   @"perUserName"
#define USERDEFAULTS_PERSELECTICCID @"perSelectICCID"



@implementation MGUserDefaultUtil

/// 保存用户信息
+ (void)saveUserInfo:(MGUserModel *)userInfo
{
    // 归档,保存用户信息model

    NSData *archiveUser = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUser forKey:USERDEFAULTS_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 单独存储用户userName，为了退出登录后，显示最近一次登录的用户
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.userName forKey:USERDEFAULTS_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)savePerUserInfo:(MGPerUserModel *)userInfo
{
    // 归档,保存用户信息model
    NSData *archiveUser = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUser forKey:USERDEFAULTS_PERUSER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 单独存储用户userName，为了退出登录后，显示最近一次登录的用户
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.WxNickName forKey:USERDEFAULTS_PERUSERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获取用户信息
+ (MGUserModel *)getUserInfo
{
    MGUserModel *userInfo = nil;
    NSData *encodedData = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USER_INFO];
    if (encodedData)
    {
       // 解档
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    return userInfo;
}

+ (MGPerUserModel *)getPerUserInfo
{
    MGPerUserModel *userInfo = nil;
    NSData *encodedData = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_PERUSER_INFO];
    if (encodedData)
    {
        // 解档
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    return userInfo;
}

/// 清空用户信息
+ (void)removeUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removePerUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_PERUSER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获取用户token
+ (NSString *)getUserToken
{
    if ([self getUserInfo]) {
        MGUserModel *userModel = [self getUserInfo];
        NSString *tokenStr = userModel.token;
        return tokenStr;
    }
    else if ([self getPerUserInfo]) {
        MGPerUserModel *perUserModel = [self getPerUserInfo];
        NSString *tokenStr = perUserModel.token;
        return tokenStr;
    }
    return nil;
}

/// 获取用户holdId
+ (NSInteger)getUserHoldId
{
    NSNumber *holdIdNum = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_HOLDID];
    NSInteger holdIdInt = [holdIdNum integerValue];
    
    if (holdIdInt == 0)
    {
        MGUserModel *userModel = [self getUserInfo];
        NSInteger holdId = userModel.holdId;
        return holdId;
    }
    else
    {
        return holdIdInt;
    }
}

// 获取当前所选用户
+ (MGLeftMenuModel *)getCurrentUser
{
    MGLeftMenuModel *currentUser = nil;
    NSData *encodedData = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_CURRENT];
    if (encodedData)
    {
        // 解档
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    return currentUser;
}

/// 获取登录用户的HoldId
+ (NSInteger)getLoginHoldId
{
    MGUserModel *userModel = [self getUserInfo];
    NSInteger holdId = userModel.holdId;
    return holdId;
}

/// 保存切换用户后的holdID，注意: 这与登陆时候的holdID不一定相同
+ (void)saveChangedHoldId:(NSInteger)holdId
{
    [[NSUserDefaults standardUserDefaults] setObject:@(holdId) forKey:USERDEFAULTS_HOLDID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 保存当前切换的用户信息模型
+ (void)saveCurrentUser:(MGLeftMenuModel *)menuModel
{
    NSData *archiveUser = [NSKeyedArchiver archivedDataWithRootObject:menuModel];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUser forKey:USERDEFAULTS_CURRENT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 清除改变后的holdId
+ (void)removeChangedHold
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_HOLDID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获取最近一次登录用户的userName
+ (NSString *)getLastLoginUserName
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USERNAME];
    return userName;
}

/// 保存“我的”模块信息
+ (void)saveMineInfo:(MGMineModel *)mineInfo
{
    // 归档
    NSData *archiveUser = [NSKeyedArchiver archivedDataWithRootObject:mineInfo];
    [[NSUserDefaults standardUserDefaults] setObject:archiveUser forKey:USERDEFAULTS_MINE_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获取“我的”模块信息
+ (MGMineModel *)getMineInfo
{
    MGMineModel *mineInfo = nil;
    NSData *encodedData = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_MINE_INFO];
    if (encodedData)
    {
        // 解档
        mineInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    }
    return mineInfo;
}

/// 清空“我的”模块信息
+ (void)removeMineInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_MINE_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 清空本地信息(除上一次登录用户的userName外)
+ (void)removeUserDefaultInfo
{
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self getPerUserInfo])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_PERUSER_INFO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_PERSELECTICCID];
    }
    else if ([self getUserInfo])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_USER_INFO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_MINE_INFO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_HOLDID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_CURRENT];
    }
}

#pragma mark - 当前选中的卡
+ (void)setSelectCard:(NSString *)sCard
{
    [[NSUserDefaults standardUserDefaults] setObject:sCard forKey:USERDEFAULTS_PERSELECTICCID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getSelectCard
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_PERSELECTICCID];
}

+ (BOOL)isLogicalUser
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

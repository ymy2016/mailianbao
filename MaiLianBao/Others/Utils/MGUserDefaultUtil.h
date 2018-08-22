//
//  MGUserDefaultUtil.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGUserModel.h"
#import "MGMineModel.h"
#import "MGLeftMenuModel.h"

/// 获取登录用户的HoldId
#define LoginHoldId [MGUserDefaultUtil getLoginHoldId]

/// 用户HoldId
#define HoldId [MGUserDefaultUtil getUserHoldId]

/// 用户Token
#define Token  [MGUserDefaultUtil getUserToken]

@interface MGUserDefaultUtil : NSObject

/// 保存用户信息
+ (void)saveUserInfo:(MGUserModel *)userInfo;
+ (void)savePerUserInfo:(MGPerUserModel *)userInfo;

/// 获取用户信息
+ (MGUserModel *)getUserInfo;
+ (MGPerUserModel *)getPerUserInfo;

/// 清空用户信息
+ (void)removeUserInfo;
+ (void)removePerUserInfo;

/// 获取用户token
+ (NSString *)getUserToken;

/// 获取用户holdId
+ (NSInteger)getUserHoldId;
+ (MGLeftMenuModel *)getCurrentUser;

/// 获取登录用户的HoldId
+ (NSInteger)getLoginHoldId;

/// 保存切换用户后的holdID，注意: 这与登陆时候的holdID不一定相同
+ (void)saveChangedHoldId:(NSInteger)holdId;

+ (void)saveCurrentUser:(MGLeftMenuModel *)menuModel;

/// 清除改变后的holdId
+ (void)removeChangedHold;

/// 获取最近一次登录用户的userName
+ (NSString *)getLastLoginUserName;

/// 保存“我的”模块信息
+ (void)saveMineInfo:(MGMineModel *)mineInfo;

/// 获取“我的”模块信息
+ (MGMineModel *)getMineInfo;

/// 清空“我的”模块信息
+ (void)removeMineInfo;

/// 清空本地信息(除上一次登录用户的userName外)
+ (void)removeUserDefaultInfo;

// 当前选中的卡
+ (void)setSelectCard:(NSString *)sCard;
+ (NSString *)getSelectCard;

/** 是否是逻辑用户 */
+ (BOOL)isLogicalUser;

@end


//
//  MGUserModel.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/26.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodingObject.h"

/*
    1、归档->序列化
    2、解档->反序列化
    3、继承CodingObject，系统会自动进行 序列化与反序列化
*/

@interface MGUserModel : CodingObject

@property(nonatomic,assign)NSInteger userId;

@property(nonatomic,strong)NSString *userName;

@property(nonatomic,assign)NSInteger holdId;

@property(nonatomic,strong)NSString *holdName;

@property(nonatomic,strong)NSString *token;

/** 入库功能的权限 1标示有权限 */
@property(nonatomic,assign)NSInteger isCanDistribute;
/** 3逻辑用户 */
@property(nonatomic,assign)NSInteger userType;

/** 首页显示权限，1：显示首页、0：不显示首页 */
@property(nonatomic,assign)BOOL isHomeAuth;

/** 首页显示权限，1：允许查看激活统计、0：不允许查看激活统计 */
@property(nonatomic,assign)BOOL isStateReport;

@end

@interface MGPerUserModel : CodingObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *WxNickName;
@property (nonatomic, copy) NSString *IconImage;

@end

//
//  MGSimMenuDB.h
//  MaiLianBao
//
//  Created by MapGoo on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGSimMenuModel.h"
#import "MGCardEnum.h"

#define MGSimMenuDBManager [MGSimMenuDB sharedInstance]

@interface MGSimMenuDB : NSObject

+ (instancetype)sharedInstance;

/// 插入数据
- (void)insertModel:(MGSimMenuModel *)model;

/// 获取该数据库全部数据
- (MGSimMenuModel *)getAllDataFromDB;

/// 删除数据库(退出登录时候使用)
- (void)dropTableFromDB;

@end

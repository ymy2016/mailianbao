//
//  MGDBUtil.h
//  MaiLianBao
//
//  Created by MapGoo on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGDBUtil : NSObject

/// 数组转换成json字符串
+ (__kindof NSString *)jsonStrFromArray:(__kindof NSArray *)array;

/// json字符串转换成数组
+ (__kindof NSArray *)arrayFromJsonStr:(__kindof NSString *)jsonStr;

/// 字典转换成json字符串
+ (__kindof NSString *)jsonStrFromDictionary:(__kindof NSDictionary *)dic;

/// json字符串转换成字典
+ (__kindof NSDictionary *)dictionaryFromJsonStr:(__kindof NSString *)jsonStr;

@end

//
//  MGDBUtil.m
//  MaiLianBao
//
//  Created by MapGoo on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGDBUtil.h"

@implementation MGDBUtil

// 数组转换成json字符串
+ (__kindof NSString *)jsonStrFromArray:(__kindof NSArray *)array
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error)
    {
        NSLog(@"数组转json字符串失败");
        return nil;
    }
    
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

// json字符串转换成数组
+ (__kindof NSArray *)arrayFromJsonStr:(__kindof NSString *)jsonStr
{
    if (jsonStr.length == 0)
    {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error)
    {
        NSLog(@"json字符串转数组失败");
        return nil;
    }
    
    return array;
}

// 字典转换成json字符串
+ (__kindof NSString *)jsonStrFromDictionary:(__kindof NSDictionary *)dic
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error)
    {
        NSLog(@"字典转json字符串失败");
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

// json字符串转换成字典
+ (__kindof NSDictionary *)dictionaryFromJsonStr:(__kindof NSString *)jsonStr
{
    if (jsonStr.length == 0)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error)
    {
        NSLog(@"json字符串转字典失败");
        return nil;
    }
    
    return dic;
}

@end

//
//  MGItemTool.h
//  CheDaiBao
//
//  Created by zzw on 17/2/13.
//  Copyright © 2017年 MG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGItemTool : NSObject

/**
 *获取当前年份
 */
+(NSString *)getCurrentYear;

/**
 *获取当前年月
 */
+(NSString *)getCurrentYearAndMonth;

/**
 *获取当前年月
 */
+(NSString *)getCurrentYearAndMonthOtherType;

/**
 *获取当前年月
 */
+(NSString *)getCurrentYearAndMonthOtherType2;

/**
 *获取当前具体时间
 */
+(NSString *)getCurrentTime;

+(NSString *)getTime;

/**获取昨天时间*/
+(NSString *)getYesterdayTime;

/**
 *将时间date转换成NSString类型
 */
+ (NSString *)convertStringFromData:(NSDate *)date;

/**
 *将时间str转换为NSDate类型
 */
+(NSDate *)convertDateFromString:(NSString*)dataString;

/**
 *比较两个时间，返回0表示两个时间相等，返回－1表示oneDay比anotherDay小，返回1表示oneDay比anotherDay大
 */
+(NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


/**
 获取某个字符串或者汉字的首字母

 @param string 传人的字符串或者汉字
 @return 拼音首字母
 */
+ (NSString *)firstCharactorWithString:(NSString *)string;

//判断输入的字符串首字母是否为中文
+ (BOOL)judgeIfChinese:(NSString *)st;

/**
 查询相机权限

 @return 提示语
 */
+ (NSString *)judgeMyCameraAuthority;

@end

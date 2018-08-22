//
//  MGItemTool.m
//  CheDaiBao
//
//  Created by zzw on 17/2/13.
//  Copyright © 2017年 MG. All rights reserved.
//

#import "MGItemTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation MGItemTool


/**获取当前年份*/
+(NSString *)getCurrentYear
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/**获取当前年月*/
+(NSString *)getCurrentYearAndMonth
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/**获取当前年月*/
+(NSString *)getCurrentYearAndMonthOtherType
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMM"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/**获取当前年月*/
+(NSString *)getCurrentYearAndMonthOtherType2
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}


/**获取当前时间*/
+(NSString *)getCurrentTime
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/**获取当前时间*/
+(NSString *)getTime
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

/**获取昨天时间*/
+(NSString *)getYesterdayTime
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:currentDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:lastDay];
    return dateString;
}


/**将时间date转换成NSString类型*/
+ (NSString *)convertStringFromData:(NSDate *)date{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

/**将时间str转换为NSDate类型*/
+(NSDate *)convertDateFromString:(NSString*)dataString {
    
    NSString * time  = dataString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [formatter dateFromString:time];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

/**比较两个时间*/
+(NSInteger)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result ==NSOrderedAscending){
        return -1;
    }
    return 0;
}

//获取某个字符串或者汉字的首字母.
+ (NSString *)firstCharactorWithString:(NSString *)string {
    
    //转可变字符串
    NSMutableString *str = [NSMutableString stringWithString:string];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformStripDiacritics, NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

//判断输入的字符串首字母是否为中文
+ (BOOL)judgeIfChinese:(NSString *)str {

    //取首字母
    NSRange range = NSMakeRange(0, 1);
    NSString *subString = [str substringWithRange:range];
    
    //UTF8编码 ->中文占3个字节、英文占1个字节
    const char *cString = [subString UTF8String];
    
    if (strlen(cString) == 3) {
        return YES;
    }else {
        return NO;
    }
}

/**
 查询相机权限
 */
+ (NSString *)judgeMyCameraAuthority {
    
    // 1.判断手机是否有摄像头以及是否有权限开摄像头
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return @"您的手机没有摄像头";
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied||authStatus == AVAuthorizationStatusRestricted) {
        return @"没有权限使用您的相机，请前往设置->隐私->相机授权应用拍照权限";
    }
    return nil;
}

@end

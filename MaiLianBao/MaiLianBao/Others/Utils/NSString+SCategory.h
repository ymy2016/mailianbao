//
//  NSString+SCategory.h
//  
//
//  Created by TFT_SuHan on 15/4/21.
//  Copyright (c) 2015年 MapGoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SCategory)

/** 直接传入精度丢失有问题的Double类型*/
+ (NSString *)decimalNumberWithDouble:(double)conversionValue;

/**
 *  计算字符串宽度
 *
 *  @param contentSize CGSzie
 *  @param font 字体
 *
 *  @return 返回一个CGSzie
 */
- (CGSize)boundingRectWithSize:(CGSize)contentSize andFont:(UIFont *)font;

/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString* sha1Hash;

/**
 *  检测字符串中是否有空白符和换行符
 *
 *  @return BOOL
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 *  URL Encode
 *
 *  @return NSString
 */
- (NSString *)urlEncoded;

/**
 *  移除string中所有的HTML标签
 *
 *  @return NSString
 */
- (NSString *)stringByRemovingHTMLTags;

/**
 *  验证字符串是否为空 为空返回NO 不为空为YES
 *
 *  @return BOOL
 */
- (BOOL)isNotNil;

/**
 *去掉字符串两头的空格
 *
 *
 */
- (NSString *)TrimString;
/*
 *把带有中文字符的转换格式
 *
 */
+ (NSString *)StringFormatURLEncode:(NSString *)pStr, ...;

/**
 获取当前连接的WiFi名称

 @return 返回WiFi名称字符串
 */
+ (NSString *)GetCurrentWifiHotSpotName;


/**
 字符串转Base64

 @param text 待转字符串

 @return 转换后的字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 Base64转字符串
 
 @param text 待转base64
 
 @return 转换后的字符串
 */
+ (NSString *)textFromBase64String:(NSString *)text;

/**
 获取路由器的Mac地址

 @return 返回Mac地址
 */
+ (NSString *)GetCurrentWifiMacAddress;

+ (NSString *)timestamp;

// 获取本机ip地址
+ (NSString *)getIpAddresses;
@end

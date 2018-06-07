//
//  NSString+MGUtil.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MGUtil)

/// MD5加密
- (NSString *)MD5String;

/// 给字符串添加下划线
+ (NSAttributedString *)underLineWithStr:(NSString *)str
                               textColor:(UIColor *)textColor
                                textFont:(UIFont *)textFont;

// 时间戳
+ (NSString *)timestamp;

// 去除字符串首尾空格
- (NSString *)mdf_stringByTrimingWhitespaceOrNewlineCharacter;

// 去除字符串所有空格
- (NSString *)mdf_stringByTrimingAllWhitespaces;

@end

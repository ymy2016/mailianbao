//
//  UILabel+Category.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (SCategory)

/**
 *  根据range加粗字体
 *
 *  @param range NSRange范围
 */
- (void)setBoldFontToRange:(NSRange)range;
/**
 *  根据指定字符串加粗字体
 *
 *  @param string 指定字符串
 */
- (void)setBoldFontToString:(NSString *)string;
/**
 *  根据range修改字体颜色
 *
 *  @param color 字体要修改的颜色
 *  @param range 要修改的范围
 */
- (void)setFontColor:(UIColor *)color range:(NSRange)range;
/**
 *  根据字符串修改字体颜色
 *
 *  @param color  字体要修改的颜色
 *  @param string 要修改的字符串
 */
- (void)setFontColor:(UIColor *)color string:(NSString *)string;
/**
 *  根据范围修改字体
 *
 *  @param font  字体
 *  @param range 要修改的范围
 */
- (void)setFont:(UIFont *)font range:(NSRange)range;
/**
 *  根据字符串修改字体
 *
 *  @param font   字体
 *  @param string 要求改的字符串
 */
- (void)setFont:(UIFont *)font string:(NSString *)string;

@end

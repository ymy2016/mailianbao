//
//  MGFormartUtil.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Formart [MGFormartUtil sharedInstance]

@interface MGFormartUtil : NSObject

+ (MGFormartUtil *)sharedInstance;

/// 浮点型转换成字符串
- (NSString *(^)(CGFloat num))floatToStr;

/// 格式化金额，带逗号的形式
- (NSString *(^)(CGFloat num))money;

/// 格式化数字，带逗号的形式
- (NSString *(^)(CGFloat num))num;

/// 格式化数字，带逗号、橙色的形式
- (NSMutableAttributedString *(^)(CGFloat num))orangeNum;

+ (NSString *)countNumAndChangeformat:(NSInteger)num;

// 每个几位增加空格
+ (NSString *)dealWithString:(NSString *)number length:(NSInteger)length;

@end

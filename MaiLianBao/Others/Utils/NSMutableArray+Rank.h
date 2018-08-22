//
//  NSMutableArray+Rank.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/18.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Rank)

// 依据某个属性，获取数组模型中该属性最大值的model
- (id)getMaxModel_MaxValueWithProperty:(NSString *)property;

// 依据某个属性，获取数组模型中该属性最小值的model
- (id)getMinModel_MinValueWithProperty:(NSString *)property;

// 依据某个属性，进行降序排列
- (instancetype)getRankArray_DescendRankWithProperty:(NSString *)property;

// 依据某个属性，进行升序排列
- (instancetype)getRankArray_AscendRankWithProperty:(NSString *)property;

@end

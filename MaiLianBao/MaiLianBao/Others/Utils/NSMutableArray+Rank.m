//
//  NSMutableArray+Rank.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/18.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "NSMutableArray+Rank.h"

@implementation NSMutableArray (Rank)

// 依据某个属性，获取数组模型中该属性最大值的model
- (id)getMaxModel_MaxValueWithProperty:(NSString *)property{
    
    NSParameterAssert(property.length != 0 && property != nil);
    NSMutableArray *mArr = [self mutableCopy];
    // 降序排列
    NSSortDescriptor *descRank = [NSSortDescriptor sortDescriptorWithKey:property ascending:false];
    [mArr sortUsingDescriptors:@[descRank]];
    id model = [mArr firstObject];
    return model;
}

// 依据某个属性，获取数组模型中该属性最小值的model
- (id)getMinModel_MinValueWithProperty:(NSString *)property{
    
    NSParameterAssert(property.length != 0 && property != nil);
    NSMutableArray *mArr = [self mutableCopy];
    // 升序排列
    NSSortDescriptor *asceRank = [NSSortDescriptor sortDescriptorWithKey:property ascending:true];
    [mArr sortUsingDescriptors:@[asceRank]];
    id model = [mArr firstObject];
    return model;
}

// 依据某个属性，进行降序排列
- (instancetype)getRankArray_DescendRankWithProperty:(NSString *)property{
    
    NSParameterAssert(property.length != 0 && property != nil);
    NSMutableArray *mArr = [self mutableCopy];
    // 降序排列
    NSSortDescriptor *descRank = [NSSortDescriptor sortDescriptorWithKey:property ascending:false];
    [mArr sortUsingDescriptors:@[descRank]];
    return mArr;
}

// 依据某个属性，进行升序排列
- (instancetype)getRankArray_AscendRankWithProperty:(NSString *)property{
    
    NSParameterAssert(property.length != 0 && property != nil);
    NSMutableArray *mArr = [self mutableCopy];
    // 升序排列
    NSSortDescriptor *asceRank = [NSSortDescriptor sortDescriptorWithKey:property ascending:true];
    [mArr sortUsingDescriptors:@[asceRank]];
    return mArr;
}

@end

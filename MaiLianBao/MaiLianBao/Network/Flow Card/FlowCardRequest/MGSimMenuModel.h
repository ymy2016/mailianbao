//
//  MGSimMenuModel.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "CodingObject.h"
#import "MGCardEnum.h"

@interface MGSimType : CodingObject
@property (nonatomic, assign) SimCardType simFromType;
@property (nonatomic, copy) NSString *name;

@end

@interface MGSimPackage : CodingObject
@property (nonatomic, assign) SimCardType simFromType;
@property (nonatomic, assign) NSInteger packageId;
@property (nonatomic, copy) NSString *name;
@end

@interface MGSimState : CodingObject
@property (nonatomic, assign) SimCardType simFromType;
@property (nonatomic, assign) NSInteger stateId;
@property (nonatomic, copy) NSString *name;
@end

@interface MGSimMenuModel : CodingObject
@property (nonatomic, strong) NSMutableArray *simFromTypelist;
@property (nonatomic, strong) NSMutableArray *packageList;
@property (nonatomic, strong) NSMutableArray *simStatelist;

// SIM卡类型
- (SimCardType)typeWithName:(NSString *)name;
// 获取卡状态
- (NSNumber *)stateTypeWithName:(NSString *)name;
// 卡套餐数组
- (NSArray *)packageTypeWithName:(NSArray *)nameArray type:(SimCardType)type;
// SIM卡类型数据
- (NSMutableArray *)simData;
// 套餐类型数据
- (NSMutableArray *)packageDataWithType:(SimCardType)type;
// 状态类型数据
- (NSMutableArray *)stateDataWithType:(SimCardType)type;
// 筛选条件,返回筛选后的数据
- (void)filterWithType:(SimCardType)type result:(void (^)(NSMutableArray * packageData, NSMutableArray *stateData))result;
@end

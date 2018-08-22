//
//  MGFlowCardRequest.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/27.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"
#import "MGCardEnum.h"

@interface MGFlowCardParams : NSObject
/**
 *  用户ID
 */
@property (nonatomic, assign) NSInteger holdId;
/**
 *  卡类型
 */
@property (nonatomic, assign) SimCardType simFromType;
/**
 *  页数
 */
@property (nonatomic, assign) NSInteger P;
/**
 *  每页条数
 */
@property (nonatomic, copy) NSNumber *pRowCount;
/**
 *  ICCID、 SIM关键字
 */
@property (nonatomic, copy) NSString * key;
/**
 *  排序方式
 */
@property (nonatomic, copy) NSNumber *orderWay;
/**
 *  排序类型 剩余流量-expiretime 剩余流量-flowleftvalue
 */
@property (nonatomic, copy) NSString * sortField;
/**
 *  套餐类型
 */
@property (nonatomic, strong) NSArray *packageType;
/**
 *  卡状态
 */
@property (nonatomic, copy) NSNumber *simState;

+ (instancetype)param;

@end

@interface MGFlowCardRequest : MGRequest

- (instancetype)initWithParam:(MGFlowCardParams *)param;

@end

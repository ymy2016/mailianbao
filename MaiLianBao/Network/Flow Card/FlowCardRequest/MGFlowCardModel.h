//
//  MGFlowCardModel.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "CodingObject.h"
#import "MGCardEnum.h"

@interface MGTotal : CodingObject
@property (nonatomic, assign) CGFloat activatedCount;
@property (nonatomic, assign) CGFloat allCount;
@property (nonatomic, assign) CGFloat deactivatedCount;
@property (nonatomic, assign) CGFloat unactivatedCount;
@end

@interface MGPageInfo : CodingObject
@property (nonatomic, copy) NSString * p;
@property (nonatomic, copy) NSString * pcount;
@property (nonatomic, copy) NSString * psize;
@property (nonatomic, copy) NSString * records;
@end

@interface MGListInfo : CodingObject
@property (nonatomic, assign) NSInteger apiCode;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, copy) NSString * expireTime;
@property (nonatomic, assign) CGFloat flowLeftValue;
@property (nonatomic, copy) NSString * iccid;
@property (nonatomic, copy) NSString * oddTime;
@property (nonatomic, copy) NSString * packageId;
@property (nonatomic, copy) NSString * packageName;
@property (nonatomic, copy) NSString * sim;
@property (nonatomic, assign) SimCardType simFromType;
@property (nonatomic, assign) NSInteger simId;
//1未激活 2正常 3停机
@property (nonatomic, assign) SimCardStateType simState;
@end

@interface MGFlowCardModel : CodingObject
@property (nonatomic, strong) MGTotal * total;
@property (nonatomic, strong) MGPageInfo * pageInfo;
@property (nonatomic, strong) NSMutableArray * list;
@end

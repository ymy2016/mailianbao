//
//  MGFlowInfoModel.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "CodingObject.h"
#import "MGCardEnum.h"

@interface MGRenewalsOrder : CodingObject
@property (nonatomic, assign) double Amount;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *ICCID;
@property (nonatomic, assign) NSInteger IndexNo;
@property (nonatomic, copy) NSString *OrderSign;
@property (nonatomic, copy) NSString *PackageName;
@property (nonatomic, copy) NSString *PayMenter;
@property (nonatomic, copy) NSString *PayState;
@property (nonatomic, copy) NSString *PayTime;
@property (nonatomic, copy) NSString *SIM;
@property (nonatomic, copy) NSString *isPush;
@property (nonatomic, copy) NSString *isToActiveOrder;
@property (nonatomic, copy) NSString *wxOrderId;
@property (nonatomic, copy) NSString *wxOrderNo;
@end

@interface MGHistoryMonthUsage : CodingObject
@property (nonatomic, copy) NSString *BillTime;
@property (nonatomic, copy) NSString *UsageMB;
@end

@interface MGYDSimBill : CodingObject
@property (nonatomic, copy) NSString *sim;
@property (nonatomic, copy) NSString *operation;
@property (nonatomic, copy) NSString *billTime;
@property (nonatomic, assign) CGFloat cost;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *createTime;
@end

@interface MGUnicomUsage : CodingObject
@property (nonatomic, copy) NSString *sessionTime;
@property (nonatomic, copy) NSString *usage;
@property (nonatomic, copy) NSString *duration;
@end

@interface MGFlowInfoModel : CodingObject
@property (nonatomic, assign) NSInteger simId;
@property (nonatomic, copy) NSString *iccid;
@property (nonatomic, copy) NSString *sim;
@property (nonatomic, copy) NSString *monthUsageData;
@property (nonatomic, assign) SimCardType simFromType;
@property (nonatomic, assign) NSInteger apiCode;
@property (nonatomic, assign) NSInteger packageId;
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *oddTime;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, assign) NSString *flowLeftValue;
@property (nonatomic, assign) SimCardStateType simState;
@property (nonatomic, copy) NSString *simStateSrc;
@property (nonatomic, assign) NSInteger isUsageReset;
@property (nonatomic, assign) NSInteger isAddPackage;
@property (nonatomic, copy) NSString *surplusPeriod;
@property (nonatomic, assign) CGFloat surplusUsage;
@property (nonatomic, assign) CGFloat doneUsage;
@property (nonatomic, assign) NSInteger overUsageStoped;
@property (nonatomic, assign) NSInteger addPackageCount;
@property (nonatomic, assign) NSInteger renewalsCount;
@property (nonatomic, assign) CGFloat renewalAmount;
@property (nonatomic, strong) NSMutableArray *renewalsOrderList;
@property (nonatomic, strong) NSMutableArray *historyMonthUsageList;
@property (nonatomic, strong) NSMutableArray *ydSimBillList;
@end

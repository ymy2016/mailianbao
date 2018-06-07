//
//  MGLeftMenuModel.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodingObject.h"

@interface MGLeftMenuModel : CodingObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)CGFloat activatedCount;
@property(nonatomic,assign)CGFloat allCount;
@property(nonatomic,assign)NSInteger mId;
@property(nonatomic,assign)CGFloat lastMonthBackAmount;
@property(nonatomic,assign)CGFloat lastMonthRenewalsActiveCount;
@property(nonatomic,assign)CGFloat lastMonthRenewalsActivePrice;
@property(nonatomic,assign)CGFloat lastMonthRenewalsAmount;
@property(nonatomic,assign)CGFloat lastMonthRenewalsCount;
@property(nonatomic,assign)CGFloat monthBackAmount;
@property(nonatomic,assign)CGFloat monthRenewalsActivatedCount;
@property(nonatomic,assign)CGFloat monthRenewalsAmount;
@property(nonatomic,assign)CGFloat monthRenewalsCount;
@property(nonatomic,assign)NSInteger nodeLevel;
@property(nonatomic,assign)NSInteger parentId;
@property(nonatomic,assign)CGFloat totalBackAmount;
@property(nonatomic,assign)CGFloat totalRenewalsActiveCount;
@property(nonatomic,assign)CGFloat totalRenewalsActivePrice;
@property(nonatomic,assign)CGFloat totalRenewalsAmount;
@property(nonatomic,assign)CGFloat totalRenewalsCount;
@property(nonatomic,assign)CGFloat unactivatedCount;

/** 是否为逻辑用户 */
@property(nonatomic,assign)BOOL isLogicalUser;
/// 该节点是否已经展开
@property (nonatomic, assign)BOOL isExpansion;

@end







//
//  MGHPRebateModel.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGHPRebateModel : NSObject

@property(nonatomic,assign)CGFloat lastMonthBackAmount;
@property(nonatomic,assign)CGFloat lastMonthRenewalsAmount;
@property(nonatomic,assign)CGFloat lastMonthRenewalsCount;
@property(nonatomic,assign)CGFloat monthBackAmount;
@property(nonatomic,assign)CGFloat monthRenewalsAmount;
/** 已续费 */
@property(nonatomic,assign)CGFloat renewalsActiveCount;
/** 流量卡总数 */
@property(nonatomic,assign)NSInteger simCount;
@property(nonatomic,assign)CGFloat totalBackAmount;
@property(nonatomic,assign)CGFloat totalRenewalsAmount;
/** 已使用 */
@property(nonatomic,assign)CGFloat activatedCount;
/** 已使用 */
@property(nonatomic,assign)CGFloat stopCount;
/** 脱网卡 */
@property(nonatomic,assign)CGFloat ltOutCount;

@property(nonatomic, copy) NSString *holdName;
@end

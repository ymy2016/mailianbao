//
//  MGFlowPayTableViewCell.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/24.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGRenewalsOrder,MGYDSimBill;
@interface MGFlowPayTableViewCell : UITableViewCell
@property (nonatomic, strong) MGRenewalsOrder *renewalsOrderModel;
@property (nonatomic, strong) MGYDSimBill *ydSimBillModel;
@end
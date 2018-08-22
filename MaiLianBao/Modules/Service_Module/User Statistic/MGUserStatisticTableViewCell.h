//
//  MGUserStatisticTableViewCell.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/25.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCardEnum.h"
//#import "MGTreeNodeModel.h"

@class MGLeftMenuModel;
@interface MGUserStatisticTableViewCell : UITableViewCell
//@property (nonatomic, strong) NSIndexPath * indexPath;
//@property (nonatomic, strong) MGTreeNodeModel * nodeModel;

// 表的整体数据源 用于左侧按钮判断
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) SimDataType dataType;
@property (nonatomic, strong) MGLeftMenuModel *model;
@property (nonatomic, copy) void (^nodeButtonBlock)();
@end

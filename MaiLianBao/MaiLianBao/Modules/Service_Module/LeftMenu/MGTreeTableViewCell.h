//
//  MGTreeTableViewCell.h
//  MaiLianBao
//
//  Created by MapGoo on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLeftMenuModel.h"

@interface MGTreeTableViewCell : UITableViewCell

@property(nonatomic,strong)MGLeftMenuModel *model;

@property (nonatomic,copy)void(^leftBtnBlock)();

/// 表的整体数据源，用于左侧按钮显示隐藏的判断
@property(nonatomic,strong)NSMutableArray *dataList;

@end

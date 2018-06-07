//
//  MGHPBotTableViewCell.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHPRebateModel.h"

@protocol BotCellTapDelegate <NSObject>

- (void)handleBotCellTap;

@end

@interface MGHPBotTableViewCell : UITableViewCell

@property(nonatomic,strong)MGHPRebateModel *model;

@property(nonatomic,weak)id<BotCellTapDelegate> delegate;

@end

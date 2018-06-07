//
//  MGUserStatisticTableCell.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/11.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGChannelManageOutModel.h"

// 数据Model
@interface MGUserStatisticChartModel : NSObject

@property(nonatomic,assign)double maxValue;

@property(nonatomic,assign)double currentValue;

@property(nonatomic,copy)NSString *provinceName;

- (instancetype)initWithProvinceName:(NSString *)provinceName
                            maxValue:(NSInteger)maxValue
                        currentValue:(NSInteger)currentValue;

// 返利
@property(nonatomic,copy)NSString *rebate;

// 续费
@property(nonatomic,copy)NSString *renew;

// 续费model初始化
- (instancetype)initWithProvinceName:(NSString *)provinceName
                              rebate:(NSString *)rebate
                               renew:(NSString *)renew;

@end

// 绘制柱状图类
@interface MGUserStatisticChartBar : UIView

@end

// cell
@interface MGUserStatisticTableCell : UITableViewCell

@property(nonatomic,strong)MGUserSynthesisUseOutModel *model;

// 初始化续费tableView的cel
- (instancetype)initRenewCellWithStyle:(UITableViewCellStyle)style
                       reuseIdentifier:(NSString *)reuseIdentifier;

@end



//
//  MGSearchTableViewCell.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/5.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCardEnum.h"

@class MGLeftMenuModel;
@interface MGSearchTableViewCell : UITableViewCell
@property (nonatomic, assign) SimDataType dataType;
@property (nonatomic, strong) MGLeftMenuModel *model;
@end

//
//  MGSearchTreeTableViewController.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/25.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCardEnum.h"

@interface MGSearchTreeTableViewController : UITableViewController
@property (nonatomic, assign) SimDataType dataType;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

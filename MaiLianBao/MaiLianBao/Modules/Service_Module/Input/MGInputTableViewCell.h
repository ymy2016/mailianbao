//
//  MGInputTableViewCell.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MGScanRecordModel;

@interface MGInputTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) MGScanRecordModel *scanRecordModel;
@end

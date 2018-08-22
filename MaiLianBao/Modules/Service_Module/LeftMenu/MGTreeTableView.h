//
//  MGTableTree.h
//  MaiLianBao
//
//  Created by MapGoo on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLeftMenuModel.h"

@protocol SelectedCellDelegate <NSObject>

- (void)selectedCellWithModel:(MGLeftMenuModel *)model;

@end

@interface MGTreeTableView : UITableView

@property(nonatomic,weak)id<SelectedCellDelegate>mDelegate;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                         data:(NSMutableArray *)data;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

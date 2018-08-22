//
//  MGRenewTableView.h
//  MaiLianBao
//
//  Created by 谭伟华 on 2018/4/11.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGRenewTableView : UIView

@property(nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,copy)void(^refreshBlock)();

@property(nonatomic,strong)UITableView *tableView;

// 刷新tableView
- (void)reloadTableView;

@end

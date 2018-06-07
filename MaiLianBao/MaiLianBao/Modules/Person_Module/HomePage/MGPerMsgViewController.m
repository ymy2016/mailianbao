//
//  MGPerMsgViewController.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/7.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerMsgViewController.h"
#import "MGPerMsgTableViewCell.h"
#import "MGPerMsgModel.h"

@interface MGPerMsgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

// 测试model
@property(nonatomic,strong)MGPerMsgModel *model;

// 数据源
@property(nonatomic,strong)NSMutableArray *dataList;

// cell高度
@property(nonatomic,assign)CGFloat cellHeight;

@end

static NSString *identy = @"cell";

@implementation MGPerMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息箱";
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{

    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-kTopSubHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MGPerMsgTableViewCell class] forCellReuseIdentifier:identy];
        
        /*
         * 任意设置非0的estimatedRowHeight(预估高度)        
         */
        // cell预估高度
        _tableView.estimatedRowHeight = 40;
    }

    return _tableView;
}

- (MGPerMsgModel *)model{

    if (_model == nil) {
        
        _model = [[MGPerMsgModel alloc] init];
        _model.postTime = @"2016年12月26日 09:51";
        _model.postContent = @"尊敬的用户，您好，手联通月结影响部分卡可能会无法使用尊敬的用户，您好，手联通月结束影响部分卡可能会无法使用尊敬的用户，您用尊敬的用户，您好，手联通月结影响部分卡,尊敬的用户，您好，手联通月结影响部分卡可能会无法使用尊敬的用户，您好，手联通月结束影响部分卡可能会无法使用尊敬的用户，您用尊敬的用户，您好，手联通月结影响,尊敬的用户，您好，手联通月结影响部分卡可能会无法使用尊敬的用户，您好，手联通月结束影响部分卡可能会无法使用尊敬的用户，您用尊敬的用户，您好，手联通月结影响";
    }
 
    return _model;
}

- (NSMutableArray *)dataList{

    if (_dataList == nil) {
        
        _dataList = [NSMutableArray arrayWithObjects:self.model,self.model,self.model,self.model,self.model,self.model,self.model,nil];
    }
    
    return _dataList;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataList.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGPerMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    
    // model赋值
    cell.model = self.dataList[indexPath.row];
    
    // 获取cell高度
    _cellHeight = [cell prepareLayoutHeight];
    
    return cell;
}

// 返回height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellHeight;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end

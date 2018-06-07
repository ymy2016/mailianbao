	//
//  MGRenewTableView.m
//  MaiLianBao
//
//  Created by 谭伟华 on 2018/4/11.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGRenewTableView.h"
#import "MGUserStatisticTableCell.h"
#import "UIView+BSLine.h"
#import "NSMutableArray+Rank.h"
#import "KVOController.h"
#import "MGRefreshHeader.h"

typedef NS_ENUM(NSInteger,ArrowBtnState){
    
    AscendState,  // 升序
    DescendState, // 降序
    NoneState     // 无排序
};

@interface MGRenewTableView()<UITableViewDelegate,UITableViewDataSource>

// 返利按钮状态
@property(nonatomic,assign)ArrowBtnState rebateBtnState;

// 续费按钮状态
@property(nonatomic,assign)ArrowBtnState renewBtnState;

@property(nonatomic,strong)FBKVOController *kvoController;

// 返利按钮
@property(nonatomic,strong)UIButton *rebateBtn;

// 续费按钮
@property(nonatomic,strong)UIButton *renewBtn;

@end

static NSString *renewCell = @"renewCell";
@implementation MGRenewTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 返利默认无排序
        _rebateBtnState = NoneState;
        // 续费默认降序
        _renewBtnState = DescendState;
      
        [self addSubview:self.tableView];
        self.kvoController = [FBKVOController controllerWithObserver:self];
        
        // 监听 rebateBtnState 属性
        [_kvoController observe:self keyPath:@"rebateBtnState" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            
            if ([@"rebateBtnState" isEqualToString:change[FBKVONotificationKeyPathKey]]) {
               
                NSInteger rebateBtnState = [change[NSKeyValueChangeNewKey] integerValue];
                NSLog(@"返利状态 ==> %zd",rebateBtnState);
               
                // 返利升序
                if (rebateBtnState == 0) {
                    [self.rebateBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
                    [self.renewBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
                    self.dataList = [self.dataList getRankArray_AscendRankWithProperty:@"RebateAmount"];
                    [self.tableView reloadData];
                    
                }
                // 返利降序
                else if (rebateBtnState == 1){
                    [self.rebateBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                    [self.renewBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
                    self.dataList = [self.dataList getRankArray_DescendRankWithProperty:@"RebateAmount"];
                    [self.tableView reloadData];
                }
                // 返利无排序
                else{
                    [self.rebateBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
                }
            }

        }];
        
        // 监听 rebateBtnState 属性
        [_kvoController observe:self keyPath:@"renewBtnState" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            
            if ([@"renewBtnState" isEqualToString:change[FBKVONotificationKeyPathKey]]) {
                
                NSInteger renewBtnState = [change[NSKeyValueChangeNewKey] integerValue];
                NSLog(@"续费状态 ==> %zd",renewBtnState);
                // 续费升序
                if (renewBtnState == 0) {
                    [self.renewBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
                    [self.rebateBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
                    self.dataList = [self.dataList getRankArray_AscendRankWithProperty:@"RenewAmount"];
                    [self.tableView reloadData];
                }
                // 续费降序
                else if (renewBtnState == 1){
                    [self.renewBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
                    [self.rebateBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
                    self.dataList = [self.dataList getRankArray_DescendRankWithProperty:@"RenewAmount"];
                    [self.tableView reloadData];
                }
                // 续费无排序
                else{
                    [self.renewBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
                }
            }
        }];
    }
    
    return self;
}

- (void)reloadTableView{
    
    self.renewBtnState = _renewBtnState;
    self.rebateBtnState = _rebateBtnState;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// row数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGUserStatisticTableCell *cell =  [[MGUserStatisticTableCell alloc] initRenewCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:renewCell];
    if (cell == nil) {
        cell = [[MGUserStatisticTableCell alloc] initRenewCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:renewCell];
    }
    
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

// cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

// 组的头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

// 组的头部视图View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    [bgView addBottomLineWithLeftPading:0 andRightPading:0];
    
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(AdaptW(20), AdaptH(10), AdaptW(60), AdaptH(20))];
    leftLab.text = @"用户";
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.font = [UIFont systemFontOfSize:14.0f];
    leftLab.textColor = [UIColor blackColor];
    [bgView addSubview:leftLab];
    
    // 默认按钮返利降序
    [bgView addSubview:self.rebateBtn];
    
    // 续费按钮)
    [bgView addSubview:self.renewBtn];
    
    return bgView;
}

#pragma mark - 按钮响应
// 返利排序事件
- (void)rebateRankAction{
    
    _renewBtnState = NoneState;
     [self.renewBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
    // 升序 --> 无序
    if (self.rebateBtnState == AscendState ) {
        self.rebateBtnState = NoneState;
    }
    // 降序 --> 升序
    else if (self.rebateBtnState == DescendState){
        self.rebateBtnState = AscendState;
    }
    // 无序 --> 降序
    else if (self.rebateBtnState == NoneState){
        self.rebateBtnState = DescendState;
    }
}

// 续费排序事件
- (void)renewRankAction{
    
    _rebateBtnState = NoneState;
    [self.rebateBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
    // 升序 --> 无序
    if (self.renewBtnState == AscendState) {
        self.renewBtnState = NoneState;
    }
    // 降序 --> 无序
    else if (self.renewBtnState == DescendState){
        self.renewBtnState = AscendState;
    }
    // 无序 --> 降序
    else if (self.renewBtnState == NoneState){
        self.renewBtnState = DescendState;
    }
}

#pragma mark - 懒加载
- (UIButton *)renewBtn{
    
    if (_renewBtn == nil) {
        
        _renewBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW-AdaptW(80), AdaptH(10), AdaptW(60), AdaptH(20))];
        _renewBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_renewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_renewBtn setTitle:@"续费" forState:UIControlStateNormal];
        [_renewBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        _renewBtn.imageEdgeInsets = UIEdgeInsetsMake(0, AdaptW(50), 0, 0);
        [_renewBtn addTarget:self action:@selector(renewRankAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _renewBtn;
}

- (UIButton *)rebateBtn{
    
    if (_rebateBtn == nil) {
        
        _rebateBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2.0 - AdaptW(30), AdaptH(10), AdaptW(60), AdaptH(20))];
        _rebateBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_rebateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rebateBtn setTitle:@"返利" forState:UIControlStateNormal];
        [_rebateBtn setImage:[UIImage imageNamed:@"arrow_none"] forState:UIControlStateNormal];
        _rebateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, AdaptW(50), 0, 0);
        [_rebateBtn addTarget:self action:@selector(rebateRankAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rebateBtn;
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MGUserStatisticTableCell class] forCellReuseIdentifier:renewCell];
        
        weakSelf(self);
        _tableView.mj_header = [MGRefreshHeader headerWithRefreshingBlock:^{
            // 抛出到外部进行刷新
            if (weakSelf.refreshBlock) {
                weakSelf.refreshBlock();
            }
        }];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataList{
    
    if (_dataList == nil) {
        
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (FBKVOController *)kvoController{
    
    if (_kvoController == nil) {
        _kvoController = [FBKVOController controllerWithObserver:self];
    }
    
    return _kvoController;
}

@end

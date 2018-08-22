//
//  MGInputViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGInputViewController.h"
#import "MGInputTableViewCell.h"
#import "MGInputTitleView.h"
#import "MGHPDistributeLog.h"
#import "MGDistributeByScan.h"
#import "MGRecordModel.h"

@interface MGInputViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) MGListType listType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MGInputViewController

- (instancetype)initWithListType:(MGListType)listType
{
    if (self = [super init])
    {
        _listType = listType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_tableView registerClass:[MGInputTableViewCell class] forCellReuseIdentifier:@"CELLID"];
    
    if (self.listType == MGScanListType)
    {
        self.navigationItem.title = @"入库记录";
        [self requestDistributeLog];
    }
    
}

// 入库记录
- (void)requestDistributeLog
{
    MGHPDistributeLog *request = [[MGHPDistributeLog alloc] initWithHoldId:HoldId];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
           
            NSArray *array = [MGScanRecordModel mj_objectArrayWithKeyValuesArray:NetParse.result(dic)];
            
            NSLog(@"%@", array);
            
            self.dataSource = [array[0] mutableCopy];
            
            [self.tableView reloadData];
        }];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

// 扫码入库
- (void)requestDistributeByScan
{
    MGDistributeByScan *request = [[MGDistributeByScan alloc] initWithHoldId:HoldId
                                                                      userId:[MGUserDefaultUtil getUserInfo].userId
                                                                         str:self.scanResult];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
            
            NSLog(@"扫描数据:%@", dic);
            MGScanRecordModel *model = [MGScanRecordModel mj_objectWithKeyValues:NetParse.result(dic)];
            [self.dataSource insertObject:model atIndex:0];
            
            [self.tableView reloadData];
        }];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setScanResult:(NSString *)scanResult
{
    _scanResult = scanResult;
    
    [self requestDistributeByScan];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    
    [cell.numberLabel setText:[NSString stringWithFormat:@"%@", @(self.dataSource.count - indexPath.row)]];
    [cell setScanRecordModel:self.dataSource[indexPath.row]];
    cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : UIColorFromRGB(0xF3F3F3);
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MGInputTitleView *view = [[MGInputTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, AdaptH(30))];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGScanRecordModel *model = self.dataSource[indexPath.row];
    if (model.distributeState == 2) {
        return AdaptH(50);
    }
    return AdaptH(30);
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

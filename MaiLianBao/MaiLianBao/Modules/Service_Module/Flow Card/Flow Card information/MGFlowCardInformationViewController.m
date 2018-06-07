//
//  MGFlowCardInformationViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGFlowCardInformationViewController.h"

#import "MGFlowCardHeaderView.h"
#import "MGCustomSegmentView.h"

#import "MGRefreshHeader.h"
#import "MJRefresh.h"
#import "UIView+BSLine.h"
#import "UILabel+Category.h"

#import "MGFlowUseTableViewCell.h"
#import "MGFlowPayTableViewCell.h"

#import "MGFlowInfoRequest.h"
#import "MGUnicomUsageRequest.h"
#import "MGFlowInfoModel.h"

typedef NS_ENUM(NSInteger, FlowDataType)
{
    FlowMonthUse = 0,   // 本月用量
    FlowPayRecord       // 续费记录
};

static NSString * CellForUse = @"CellForUse";
static NSString * CellForPay = @"CellForPay";
static NSString * CellForBill = @"CellForBill";

@interface MGFlowCardInformationViewController () <UITableViewDelegate, UITableViewDataSource>
{
    FlowDataType _flowInfoType;
    NSInteger _codeKey;
    SimGetInfoType _getType;
    SimCardType _cardType;
}
@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, weak) MGFlowCardHeaderView * flowCardHeaderView;
@property (nonatomic, strong) MGCustomSegmentView * segmentView;
@property (nonatomic, strong) MGFlowInfoModel *infoModel;   // 流量卡信息模型
@property (nonatomic, strong) NSMutableArray *unicomUsageArray; // 联通卡用量
@end

@implementation MGFlowCardInformationViewController

- (instancetype)initWithCode:(NSInteger)code CardType:(SimCardType)cType GetType:(SimGetInfoType)gType
{
    self = [super init];
    if (self)
    {
        _codeKey = code;
        _getType = gType;
        _cardType = cType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"单卡详情";
    
    [self configUI];
}

- (void)configUI
{
    [self.view addSubview:self.mainTableView];
    
//    UILabel *titleLabel = [UILabel new];
//    titleLabel.text = @"暂无此卡信息";
//    [self.view insertSubview:titleLabel belowSubview:self.mainTableView];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//    }];
    
    // 首次进入自动下拉刷新
    [self.mainTableView.mj_header beginRefreshing];
}

#pragma mark - Segment Handle
- (void)changeSwipeViewIndex:(UISegmentedControl *)segment
{
    _flowInfoType = (FlowDataType)segment.selectedSegmentIndex;
    // 刷新列表
    [self.mainTableView reloadData];
}

#pragma mark - 网络请求协议
// 请求成功
- (void)chainRequestFinished:(YTKChainRequest *)chainRequest
{
    [self.mainTableView.mj_header endRefreshing];
    
    [MGFlowInfoRequest requestArray:chainRequest.requestArray successBlock:^(__kindof NSDictionary *dic) {
        NSLog(@"流量卡详情数据:%@",dic);
        
        MGFlowInfoModel *model = [MGFlowInfoModel mj_objectWithKeyValues:NetParse.result(dic)];
        self.infoModel = model;
        
        if (self.infoModel.simFromType == SimCardForCUCC)
        {
            self.segmentView.items = @[[NSString stringWithFormat:@"本月用量(%@MB)",self.infoModel.monthUsageData],
                                       [NSString stringWithFormat:@"续费记录(%@)",Formart.money(self.infoModel.renewalAmount)]];
        }
        else
        {
            if (self.infoModel.apiCode == 2)
            {
                self.segmentView.items = @[[NSString stringWithFormat:@"续费记录(%@)",Formart.money(self.infoModel.renewalAmount)]];
            }
            else if (self.infoModel.apiCode == 3)
            {
                
            }
            else
            {
                self.segmentView.items = @[@"账单"];
            }
            
            _flowInfoType = FlowPayRecord;
            self.segmentView.userInteractionEnabled = NO;
        }
        
        [self.flowCardHeaderView setInfoModel:model];
        
        self.mainTableView.tableHeaderView.hidden = NO;
        
    } failBlock:^(__kindof NSString *reason) {
        self.errorLabel.hidden = NO;
    }];
    
    
    [MGUnicomUsageRequest requestArray:chainRequest.requestArray successBlock:^(__kindof NSDictionary *dic) {
        NSLog(@"联通卡本月用量:%@",dic);
        
        NSArray *array = [MGUnicomUsage mj_objectArrayWithKeyValuesArray:NetParse.result(dic)];
        
        MGUnicomUsage *unicomUsage = [[MGUnicomUsage alloc] init];
        unicomUsage.sessionTime = @"连接开始";
        unicomUsage.usage = @"用量(KB)";
        unicomUsage.duration = @"持续时间(分钟)";
        
        self.unicomUsageArray = [NSMutableArray arrayWithArray:array];
        [self.unicomUsageArray insertObject:unicomUsage atIndex:0];
        
    } failBlock:^(__kindof NSString *reason) {
        NSLog(@"%@",reason);
    }];
    
    [self.mainTableView reloadData];
}

// 请求失败
- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest *)request
{
    if (request.responseStatusCode == 0) {
        [SVProgressHUD showInfoWithStatus:@"获取失败,请检查您的网络后重试!"];
    }

    [self.mainTableView.mj_header endRefreshing];
    
//    [MGFlowInfoRequest requestArray:chainRequest.requestArray failBlock:^(__kindof NSString *reason) {
//        
//    }];
//    
//    [MGUnicomUsageRequest requestArray:chainRequest.requestArray failBlock:^(__kindof NSString *reason) {
//        
//    }];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_flowInfoType == FlowMonthUse)
    {
        // 只有联通卡有本月用量数据 移动卡不显示
        if (self.infoModel.simFromType == SimCardForCUCC)
        {
            return [self.unicomUsageArray count];
        }
        return 0;
    }
    else if (_flowInfoType == FlowPayRecord)
    {
        if (self.infoModel.simFromType == SimCardForCMCC)
        {
            if (self.infoModel.apiCode == 3)
            {
                return 0;
            }
            else if (self.infoModel.apiCode == 2)
            {
                return [self.infoModel.renewalsOrderList count];
            }
            else
            {
                return [self.infoModel.ydSimBillList count];
            }
        }
        else
            return [self.infoModel.renewalsOrderList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_flowInfoType) {
        case FlowMonthUse:
        {
            MGFlowUseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellForUse forIndexPath:indexPath];
            
            if (indexPath.row == 0)
            {
                cell.backgroundColor = UIColorFromRGB(0xf3f3f3);
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
            // 联通卡显示的数据
            MGUnicomUsage *unicomUsage = self.unicomUsageArray[indexPath.row];
            [cell setUnicomUsageModel:unicomUsage];
            
            return cell;
        }
            break;
        case FlowPayRecord:
        {
            MGFlowPayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellForPay forIndexPath:indexPath];
            
            if (self.infoModel.simFromType == SimCardForCMCC)
            {
                // 没有逻辑的跟1一样  其他的正常
                if (self.infoModel.apiCode == 2)
                {
                    MGRenewalsOrder *renewalsOrder = self.infoModel.renewalsOrderList[indexPath.row];
                    [cell setRenewalsOrderModel:renewalsOrder];
                }
                else if (self.infoModel.apiCode == 3)
                {
                    return nil;
                }
                else
                {
                    MGYDSimBill *ydSimBill = self.infoModel.ydSimBillList[indexPath.row];
                    [cell setYdSimBillModel:ydSimBill];
                }
                
            }
            else
            {
                MGRenewalsOrder *renewalsOrder = self.infoModel.renewalsOrderList[indexPath.row];
                [cell setRenewalsOrderModel:renewalsOrder];
            }
          
            return cell;
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView DataSouce

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.infoModel)
    {
        if ((self.infoModel.simFromType == SimCardForCMCC) && (self.infoModel.apiCode == 3))
        {
            return 0;
        }
        return self.segmentView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((self.infoModel.simFromType == SimCardForCMCC) && (self.infoModel.apiCode == 3))
    {
        return nil;
    }
    return self.segmentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_flowInfoType == FlowPayRecord)
    {
        return 70;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 添加卡片信息
        MGFlowCardHeaderView * flowCarHeaderView = [[MGFlowCardHeaderView alloc] initWithCardType:_cardType];
//        flowCarHeaderView.frame = CGRectMake(0, 0, self.view.width, AdaptH(240));
        self.flowCardHeaderView = flowCarHeaderView;
        _mainTableView.tableHeaderView = flowCarHeaderView;
        _mainTableView.tableHeaderView.hidden = YES;
        
        // 注册单元格
        [_mainTableView registerClass:[MGFlowUseTableViewCell class] forCellReuseIdentifier:CellForUse];
        [_mainTableView registerClass:[MGFlowPayTableViewCell class] forCellReuseIdentifier:CellForPay];
        
        // 下拉刷新
        _mainTableView.mj_header = [MGRefreshHeader headerWithRefreshingBlock:^{

            self.errorLabel.hidden = YES;
            
            MGFlowInfoRequest *flowInfoReqeust = nil;
            if (_getType == SimGetWithListType)
            {
                flowInfoReqeust = [[MGFlowInfoRequest alloc] initWithSimId:_codeKey];
            }
            else
            {
                flowInfoReqeust = [[MGFlowInfoRequest alloc] initWithKey:_codeKey];
            }
            
            YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
            [chainRequest addRequest:flowInfoReqeust callback:^(YTKChainRequest *chainRequest, YTKBaseRequest *baseRequest) {
                
                MGFlowInfoRequest *result = (MGFlowInfoRequest *)baseRequest;
                MGFlowInfoModel *model = [MGFlowInfoModel mj_objectWithKeyValues:NetParse.result(result.responseJSONObject)];
                
                if (model.simFromType == SimCardForCUCC)
                {
                    MGUnicomUsageRequest *uuRequest = [[MGUnicomUsageRequest alloc] initWithSimId:model.simId];
                    [chainRequest addRequest:uuRequest callback:nil];
                }
            }];
            chainRequest.delegate = self;
            [chainRequest start];
        }];
//        // 上拉加载
//        _mainTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//                [_mainTableView.mj_footer endRefreshing];
//            });
//        }];
    }
    return _mainTableView;
}

- (UILabel *)errorLabel
{
    if (!_errorLabel)
    {
        _errorLabel = [UILabel new];
        _errorLabel.text = @"查询不到该卡!\n\n注:请确保为麦联宝的卡,如仍无法查询,请在公众号留言并附上您的ICCID号或流量卡号";
        _errorLabel.textColor = [UIColor darkGrayColor];
        _errorLabel.font = [UIFont systemFontOfSize:13.f];
        _errorLabel.hidden = YES;
        _errorLabel.numberOfLines = 0;
        
        [_errorLabel setFont:[UIFont boldSystemFontOfSize:16.f] string:@"查询不到该卡!"];
        [_errorLabel setFontColor:[UIColor darkTextColor] string:@"查询不到该卡!"];
        
        [self.mainTableView addSubview:_errorLabel];
        [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(20);
            make.centerX.mas_equalTo(self.mainTableView);
            make.left.mas_equalTo(self.mainTableView).offset(20);
            make.right.mas_equalTo(self.mainTableView).offset(-20);
        }];
    }
    return _errorLabel;
}

- (MGCustomSegmentView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[MGCustomSegmentView alloc] init];
        _segmentView.frame = CGRectMake(0, 0, kScreenW, 44);
        [_segmentView addTarget:self action:@selector(changeSwipeViewIndex:) forControlEvents:UIControlEventValueChanged];
        [_segmentView addTopLineWithLeftPading:0 andRightPading:0];
        [_segmentView addBottomLineWithLeftPading:0 andRightPading:0];
    }
    return _segmentView;
}

@end

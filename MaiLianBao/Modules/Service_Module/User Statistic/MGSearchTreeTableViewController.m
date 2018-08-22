//
//  MGSearchTreeTableViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/25.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGSearchTreeTableViewController.h"
#import "MGSearchTableViewCell.h"

#import "MGWebViewController.h"

#import "MGLeftMenuModel.h"
#import "UTPinYinHelper.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface MGSearchTreeTableViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation MGSearchTreeTableViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchResults = [NSMutableArray array];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor orangeColor];
    _searchBar.placeholder = @"请输入用户名";
    [_searchBar setImage:[UIImage imageNamed:@"fc_icon_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"search_background"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_text_background"] forState:UIControlStateNormal];
    self.navigationItem.titleView = _searchBar;
    
    [_searchBar setShowsCancelButton:YES animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MGSearchTableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - SearchBar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // 输入过程中
    [self.searchResults removeAllObjects];
    
    if (searchText.length <= 0) {
        [self.tableView reloadData];
        return;
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(MGLeftMenuModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        UTPinYinHelper *pinYinHelper = [UTPinYinHelper sharedPinYinHelper];
        if ([pinYinHelper isString:model.name MatchsKey:searchText IgnorCase:YES])
        {
            [self.searchResults addObject:model];
        }
    }];
    
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource && Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.dataType = _dataType;
    
    MGLeftMenuModel *model = self.searchResults[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString * urlString = nil;
//    NSString * title = nil;
//    MGLeftMenuModel *model = self.searchResults[indexPath.row];
//
//    if (_dataType == ThisMonthData)
//    {
//        urlString = URL_HPMonthRebate(model.mId,Token);
//        title = @"本月返利";
//    }
//    else if (_dataType == LastMonthData)
//    {
//        urlString = URL_HPBotWeb(model.mId,Token);
//        title = @"上月返利";
//    }
//    else if (_dataType == AllMonthData)
//    {
//        urlString = URL_HPAccumulateRebate(model.mId,Token);
//        title = @"累计返利";
//    }
//
//    MGWebViewController * viewController = [[MGWebViewController alloc] initWihtURL:urlString];
//    viewController.navigationItem.title = title;
//    [self.navigationController pushViewController:viewController animated:YES];
    
    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end

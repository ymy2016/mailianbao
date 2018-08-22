//
//  MGTableTree.m
//  MaiLianBao
//
//  Created by MapGoo on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGTreeTableView.h"
#import "MGTreeTableViewCell.h"

// 展开cell内容的偏移量
#define Offset AdaptW(15)

@interface MGTreeTableView ()<UITableViewDelegate,UITableViewDataSource>

// 表的总的数据源
//@property(nonatomic,strong)NSMutableArray *dataList;

// 每次刷新的表的数据源
@property(nonatomic,strong)NSMutableArray *tempDataList;

@end

static NSString *identy = @"identy";
@implementation MGTreeTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                        data:(NSMutableArray *)data
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.separatorColor = RGB(242, 244, 246, 1);
        self.tableFooterView = [[UIView alloc] init];
        
        [self registerClass:[MGTreeTableViewCell class] forCellReuseIdentifier:identy];
        
//        _dataList = [data mutableCopy];
//        
//        [self initTreeStruct];
        
        _dataList = [NSMutableArray array];
    }
    return self;
}


- (void)setDataList:(NSMutableArray *)dataList
{
    _dataList = dataList;
    
    [self initTreeStruct];
}

// 初始化树形结构,默认展开二级树形结构
- (void)initTreeStruct
{
    _tempDataList = [NSMutableArray array];
    
    MGLeftMenuModel *rootModel = [_dataList firstObject];
    rootModel.isExpansion = YES;
    NSInteger endPosition = 1;
    
    [_tempDataList addObject:rootModel];
    
    for (MGLeftMenuModel *model in _dataList)
    {
        if ((model.nodeLevel == rootModel.nodeLevel + 1)&&(model.parentId == rootModel.mId))
        {
            [_tempDataList insertObject:model atIndex:endPosition];
            endPosition++;
        }
    }
    
    [self reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tempDataList.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];

    // 整体数据源，传递给cell
    cell.dataList = _dataList;
    
    // cell赋值
    cell.model = _tempDataList[indexPath.row];
    
    // 取得登录用户的NodeLevel
    MGLeftMenuModel *rootModel = [_tempDataList firstObject];
    NSInteger rootNodeLevel = rootModel.nodeLevel;

    // 设置偏移量
    if (indexPath.row == 0)
    {
        // (textLabel)缩进大小 = 缩进级别 * 每个缩进宽度
        cell.indentationLevel = 1; // 缩进级别，默认值是0
        cell.indentationWidth = 20; // 每个缩进宽度，默认值是10
    }
    else
    {
       MGLeftMenuModel *model = _tempDataList[indexPath.row];
       NSInteger shiftWidth =  (model.nodeLevel - rootNodeLevel + 1) * Offset;
       cell.indentationLevel = 1;
       cell.indentationWidth = shiftWidth;
    }
    
    // 点击cell左侧Btn
    cell.leftBtnBlock = ^(){
    
        NSUInteger startPosition = indexPath.row+1;
        NSUInteger endPosition = startPosition;
        
        MGLeftMenuModel *nowNodeModel = _tempDataList[indexPath.row];
        
        NSInteger nowNodeLevel = nowNodeModel.nodeLevel;
        NSInteger nowNodeId = nowNodeModel.mId;

        // 未展开
        if (nowNodeModel.isExpansion == NO)
        {
            for (MGLeftMenuModel *model in _dataList)
            {
                if ((model.nodeLevel == nowNodeLevel + 1)&&(model.parentId == nowNodeId))
                {
                    [_tempDataList insertObject:model atIndex:endPosition];
                    
                    endPosition++;
                }
            }
        }
        // 已经展开
        else
        {
            NSLog(@"%zd",_tempDataList.count);
            
            endPosition = [self removeAllNodesAtParentModel:nowNodeModel];
        }
    
        // 是否展开取反
        nowNodeModel.isExpansion = !nowNodeModel.isExpansion;
        
        [self reloadData];
        
//        // 获得需要修正的indexPath
//        NSMutableArray *indexPathArray = [NSMutableArray array];
//        for (NSUInteger i=startPosition; i<endPosition; i++) {
//            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [indexPathArray addObject:tempIndexPath];
//        }
//        
//        NSLog(@"%zd",indexPath.row);
//        
//        // 执行展开、缩进动画
//        if (nowNodeModel.isExpansion == NO)
//        {
//            // 是否展开取反
//            nowNodeModel.isExpansion = !nowNodeModel.isExpansion;
//        
//            // 这个方法会触发创建cell的方法(但是并不是刷新整个表，是从点击cell下一个cell开始刷新，结束为自己设置的位置)
//            [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
//            
//            // 刷新本次点击的cell(为的是改变cell左侧的“+”、“-”图标)
//            NSIndexPath *mIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            
//            [self reloadRowsAtIndexPaths:@[mIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            
//        }else{
//            
//            // 是否展开取反
//            nowNodeModel.isExpansion = !nowNodeModel.isExpansion;
//            
//            // 这个方法不会触发创建cell的方法
//            [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
//            
//            //  刷新本次点击的cell(为的是改变cell左侧的“+”、“-”图标)
//            NSIndexPath *mIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            
//            [self reloadRowsAtIndexPaths:@[mIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }

    };
    
    return cell;
}

// cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MGLeftMenuModel *model = _tempDataList[indexPath.row];
    
    if ([_mDelegate respondsToSelector:@selector(selectedCellWithModel:)])
    {
        [_mDelegate selectedCellWithModel:model];
    }
}

// 缩进，从数据源移除model
- (NSUInteger)removeAllNodesAtParentModel:(MGLeftMenuModel *)parentModel
{
    // indexOfObject:获取model所在数组的index
    NSUInteger startPosition = [_tempDataList indexOfObject:parentModel];
    NSUInteger endPosition = startPosition+1;
    
    MGLeftMenuModel *nowNodeModel = _tempDataList[startPosition];
    NSInteger nowNodeLevel = nowNodeModel.nodeLevel;
    
    for (NSUInteger i = startPosition+1; i<_tempDataList.count; i++)
    {
        MGLeftMenuModel *currentModel = _tempDataList[i];
        // 防止下次展开后，子节点前面出现“-”，移除时将所有子节点前的“—”改为“+”
        currentModel.isExpansion = NO;
        
        if ((currentModel.nodeLevel > nowNodeLevel))
        {
            endPosition++;
        }
        else
        {
            break;
        }
    }
    
    if (endPosition>startPosition) {
        
        [_tempDataList removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
        
    }
    return endPosition;
}

@end

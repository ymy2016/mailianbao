//
//  JSDropDownMenu.h
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger leftOrRight;
@property (nonatomic, assign) NSInteger leftRow;
@property (nonatomic, assign) NSInteger row;
- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end

@interface JSPBackgroundCellView : UIView

@end

#pragma mark - data source protocol
@class JSDropDownMenu;

@protocol JSDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath;
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column;
/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
/**
 *  返回menu有多少列,默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

/**
 * 选择后是否更改Title
 */
- (BOOL)changeTitleInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol JSDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath;
// 点击的是第几组menu
- (void)menu:(JSDropDownMenu *)menu didSelectColumn:(NSInteger)column;
- (void)menu:(JSDropDownMenu *)menu didSelectCollectionViewWithArray:(NSArray *)array title:(NSString *)title;
@end

#pragma mark - interface
@interface JSDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <JSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <JSDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textSelectedColor;
@property (nonatomic, strong) UIColor *separatorColor;
// UICollectionView 是否多选 默认NO
@property (nonatomic, assign) BOOL isCollectionMultiselect;

/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
// 获取title
- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath;
// 重新加载数据
- (void)reloadData;
// 清楚CollectionView 已选数据
- (void)clearCollectionMenuSelectWithIndex:(NSInteger)index;
@end
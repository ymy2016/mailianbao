//
//  MGNewDeviceTypeView.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGNewDeviceTypeView.h"
#import "MGDeviceTypeCell.h"
#import "MGItemTool.h"

@interface MGNewDeviceTypeView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *itemsArray;

@property(nonatomic,strong)NSMutableString *selDeviceStr;

// 选中设备的数组
@property(nonatomic,strong)NSMutableArray *selDeviceArr;

@property(nonatomic,copy)void(^selDataBlock)(NSMutableString *);

@end

static NSString *identy = @"identy";

@implementation MGNewDeviceTypeView

- (instancetype)initWithFrame:(CGRect)frame
                   itemsArray:(NSMutableArray *)itemsArray
                 selDateBlock:(void(^)(NSMutableString *))selDateBlock{
    
    if (self = [super initWithFrame:frame]) {
        
        NSParameterAssert(itemsArray.count != 0 && itemsArray !=nil);
        self.itemsArray = itemsArray;
        // 开始默认是全选
        self.selDeviceArr = [itemsArray mutableCopy];
        
        self.selDataBlock = selDateBlock;
        self.selDeviceStr = [NSMutableString string];
        
        // CollectionView布局类
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layOut];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        
        // item的大小
        layOut.itemSize = CGSizeMake(AdaptW(62),AdaptH(35));
        // item与周边的间距(逆时针：top、left、bottom、right)
        layOut.sectionInset = UIEdgeInsetsMake(AdaptH(10), AdaptW(10), 0, AdaptW(10));
        
        // 注册cell
        [self.collectionView registerClass:[MGDeviceTypeCell class] forCellWithReuseIdentifier:identy];
    }
    
    return self;
}

- (void)resetSelDataArr{
    
    self.selDeviceStr = [NSMutableString string];
    [self.selDeviceArr removeAllObjects];
    
    for (MGDeviceTypeOutModel *model in self.itemsArray) {
        model.isSel = false;
    }
    
    // 抛出可变字符串
    if (self.selDataBlock) {
        self.selDataBlock(self.selDeviceStr);
    }
    
    [self.collectionView reloadData];
}

#pragma mark ---- UICollectionViewDataSource
// 返回section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 返回row
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}

// 创建cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGDeviceTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identy forIndexPath:indexPath];
    cell.model = self.itemsArray[indexPath.row];
    weakSelf(self);
    cell.selBlock = ^(BOOL isSel, MGDeviceTypeOutModel *selModel) {
       
        if (isSel) {
            [weakSelf.selDeviceArr addObject:selModel];
        }
        else{
            [weakSelf.selDeviceArr removeObject:selModel];
        }
        
        weakSelf.selDeviceStr = [NSMutableString string];
        for (MGDeviceTypeOutModel *aModel in weakSelf.selDeviceArr) {
            NSString *tmpStr = [NSString stringWithFormat:@"%@,",aModel.DeviceNum];
            [weakSelf.selDeviceStr appendString:tmpStr];
        }
        
        // 抛出可变字符串
        if (weakSelf.selDataBlock) {
            
            // 移除掉，最后一个逗号
            if (weakSelf.selDeviceStr.length > 2 && [weakSelf.selDeviceStr containsString:@","]) {
               weakSelf.selDeviceStr = (NSMutableString *)[weakSelf.selDeviceStr substringToIndex:weakSelf.selDeviceStr.length-1];
            }
            weakSelf.selDataBlock(weakSelf.selDeviceStr);
        }
    };
    return cell;
}

// cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (indexPath.section == 0) {
//
//        // 与上次点击的是同一个cell
//        if (indexPath != self.lastFirstPath) {
//
//            [collectionView deselectItemAtIndexPath:self.lastFirstPath animated:YES];
//        }
//
//        self.lastFirstPath = indexPath;
//    }
//    else if (indexPath.section == 1){
//
//        // 与上次点击的是同一个cell
//        if (indexPath != self.lastSecondPath) {
//
//            [collectionView deselectItemAtIndexPath:self.lastSecondPath animated:YES];
//        }
//
//        self.lastSecondPath = indexPath;
//    }
//    else if (indexPath.section == 2){
//
//        // 与上次点击的是同一个cell
//        if (indexPath != self.lastThirdPath) {
//
//            [collectionView deselectItemAtIndexPath:self.lastThirdPath animated:YES];
//        }
//
//        self.lastThirdPath = indexPath;
//    }
    
    NSLog(@"选中了===>%zd,%zd",indexPath.section,indexPath.row);
}

#pragma mark - 懒加载
- (NSMutableArray *)itemsArray{
    
    if (_itemsArray == nil) {
        
        _itemsArray = [NSMutableArray array];
    }
    
    return _itemsArray;
}

//- (NSMutableString *)selDeviceStr{
//
//    if (_selDeviceStr == nil) {
//
//        _selDeviceStr = [NSMutableString string];
//        for (NSInteger i = 0; i<self.itemsArray.count; i++) {
//
//            if (i == 0) {
//                [_selDeviceStr appendString:_itemsArray[i]];
//            }
//            else{
//                NSString *str = [NSString stringWithFormat:@",%@",_itemsArray[i]];
//                [_selDeviceStr appendString:str];
//            }
//        }
//    }
//
//    return _selDeviceStr;
//}

- (NSMutableArray *)selDeviceArr{
    
    if (_selDeviceArr == nil) {
        
        _selDeviceArr = [NSMutableArray array];
    }
    
    return _selDeviceArr;
}

@end



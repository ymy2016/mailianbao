//
//  MGNewTimePickView.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGNewTimePickView.h"
#import "UIView+BSLine.h"

@interface MGNewTimePickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)UIPickerView *pickerView;

@property(nonatomic,strong)NSMutableArray *dataList;

// 选中行
@property(nonatomic,assign)NSInteger selRow;

@property(nonatomic,copy)void(^selBlock)(NSString *);

@end

@implementation MGNewTimePickView

- (instancetype)initDataArray:(NSMutableArray *)dataArray
                     selBlock:(void(^)(NSString *))selBlock{
    

    if (self = [super init]) {
      
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.selBlock = selBlock;
        self.selRow = 0;
        self.dataList = dataArray;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
        _contentView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self addSubview:_contentView];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, AdaptH(40))];
        whiteView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [whiteView addBottomLineWithLeftPading:0 andRightPading:0];
        [_contentView addSubview:whiteView];
        //添加确定和取消按钮
        for (int i = 0; i < 2; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
            [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
            if (i == 0) {
                [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            [whiteView addSubview:button];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 10 + i;
        }
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,whiteView.bottom,kScreenW,_contentView.height - AdaptH(40))];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        
        // 默认选中第一个
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        [_contentView addSubview:self.pickerView];
    }
    
    return self;
 
}

- (NSMutableArray *)dataList{
    
    if (_dataList == nil) {
        
        _dataList = [NSMutableArray array];
    }
    
    return _dataList;
}

- (void)reloadDataWithListArray:(NSMutableArray *)listArray{
    
    // 先移除
    [self.dataList removeAllObjects];
  
    // 默认选中第一个
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        NSString *selContent = self.dataList[self.selRow];
        if (self.selBlock) {
            self.selBlock(selContent);
        }
        
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.center = CGPointMake(self.frame.size.width/2, _contentView.center.y - _contentView.frame.size.height);
    }];
}

#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.center = CGPointMake(self.frame.size.width/2, _contentView.center.y + _contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.dataList.count;
}

// 每行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return AdaptH(40);
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return AdaptW(280);
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selRow = row;
 
    // 不采用实时回调
//    if (self.selBlock) {
//        NSString *selContent = self.dataList[row];
//        self.selBlock(selContent);
//    }
}

// 返回当前行的内容,返回值，则放置到UIPickerView上显示
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataList[row];
}

// 选中栏
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    // 设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = UIColorFromRGB(0xcccccc);
        }
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,kScreenW,AdaptH(35))];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor blackColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:18];
    lab.text = self.dataList[row];
    
    return lab;
}


@end

//
//  MGUserStatisticFilterView.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/9.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGUserStatisticFilterView.h"
#import "UIView+BSLine.h"
#import "QFDatePickerView.h"
#import "QFTimePickerView.h"

@interface MGUserStatisticFilterView()

// 月份Lab
@property(nonatomic,strong)UILabel *monthLab;

// pencil图标
@property(nonatomic,strong)UIImageView *pencilImgV;

// 设备Lab
@property(nonatomic,strong)UILabel *deviceLab;

// 设备数组
@property(nonatomic,strong)NSMutableArray *deviceArr;

// 选中的按钮
@property(nonatomic,strong)NSMutableArray *selBtnArr;

// 全部按钮
@property(nonatomic,strong)NSMutableArray *allBtnArr;

@end

@implementation MGUserStatisticFilterView

- (instancetype)initWithFrame:(CGRect)frame
                    deviceArr:(NSMutableArray *)deviceArr{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addLeftLineWithTopPading:0 andBottomPading:0];
        [self addBottomLineWithLeftPading:0 andRightPading:0];
        
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateSelLeftAction:)];
        
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateSelRightAction:)];
        
        NSArray *timeArr = [self getCurrentTime];
        
        _monthLab = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2.0 - AdaptW(120)/2.0, AdaptH(8), AdaptW(115), AdaptH(20))];
        _monthLab.userInteractionEnabled = true;
        _monthLab.textColor = [UIColor blackColor];
        _monthLab.text = [NSString stringWithFormat:@"月份: %@年%@月",[timeArr firstObject],[timeArr lastObject]];
        _monthLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_monthLab];
        [_monthLab addGestureRecognizer:leftTap];
        
        _pencilImgV = [[UIImageView alloc] initWithFrame:CGRectMake(_monthLab.right, AdaptH(8), AdaptW(20), AdaptH(20))];
        _pencilImgV.userInteractionEnabled = true;
        _pencilImgV.image = [UIImage imageNamed:@"edit_btn"];
        [self addSubview:_pencilImgV];
        [_pencilImgV addGestureRecognizer:rightTap];
        
        [self addHorLineWithPadingTop:_monthLab.bottom + 8 left:AdaptW(15) right:-AdaptW(15)];
        
        _deviceLab = [[UILabel alloc] initWithFrame:CGRectMake(AdaptW(15), _monthLab.bottom + AdaptH(15), AdaptW(75), AdaptH(20))];
        _deviceLab.text = @"设备机型:";
        _deviceLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_deviceLab];
        
        [self handleDeviceArr:deviceArr];
    }
    
    return self;
}

- (NSArray *)getCurrentTime{
    
    //获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    NSArray *arr = [currentDateStr componentsSeparatedByString:@"-"];
    return arr;
}

// 处理设备数
- (CGFloat)handleDeviceArr:(NSMutableArray *)deviceArr{

    CGFloat height = 0.0;
    for (NSInteger i = 0; i < deviceArr.count; i++) {
    
        NSString *title = deviceArr[i];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_deviceLab.right + (i % 4) * 40, _deviceLab.top + (i / 4) * 40, 30, 30)];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        // 添加选中按钮到选中数组
        [self.selBtnArr addObject:btn];
        
        // 按钮默认全部选中
        btn.selected = true;
        btn.backgroundColor = RGB(252, 109, 18, 1);
        
        height = btn.bottom + AdaptH(20);
    }
   
    [self handleFilterBottomBtnWithTop:height];
    return height;
}

// 处理重置、确定按钮
- (void)handleFilterBottomBtnWithTop:(CGFloat)top{
    
    CGFloat fTop = top;
    
    [self addHorLineWithPadingTop:fTop left:AdaptW(15) right:-AdaptW(15)];
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - AdaptW(150), fTop + AdaptH(10), AdaptW(55), AdaptH(30))];
    clearBtn.backgroundColor = RGB(255, 166, 50, 1);
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [clearBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn setTitle:@"重置" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    clearBtn.layer.cornerRadius = 5;
    clearBtn.layer.masksToBounds = true;
    [self addSubview:clearBtn];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(clearBtn.right + AdaptW(20), fTop + AdaptH(10), AdaptW(55), AdaptH(30))];
    sureBtn.backgroundColor = RGB(255, 130, 15, 1);
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = true;
    [self addSubview:sureBtn];
}

#pragma mark - 日期选择触发
// 左侧月份Lab触发
- (void)dateSelLeftAction:(UITapGestureRecognizer *)tap{
   
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        // 年-月
        NSArray *arr = [str componentsSeparatedByString:@"-"];
        _monthLab.text = [NSString stringWithFormat:@"月份: %@年%@月",[arr firstObject],[arr lastObject]];
    }];
    [datePickerView show];
}

// 右侧铅笔触发
- (void)dateSelRightAction:(UITapGestureRecognizer *)tap{
   
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        // 年-月
        NSArray *arr = [str componentsSeparatedByString:@"-"];
        _monthLab.text = [NSString stringWithFormat:@"月份: %@年%@月",[arr firstObject],[arr lastObject]];
    }];
    [datePickerView show];
}

#pragma mark - 按钮响应
// 设备机型选择
- (void)btnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        btn.backgroundColor = RGB(252, 109, 18, 1);
        [self.selBtnArr addObject:btn];
    }
    else{
        btn.backgroundColor = RGB(235, 235, 235, 1);
        [self.selBtnArr removeObject:btn];
    }
}

// 重置按钮
- (void)clearAction:(UIButton *)btn{
    
    for (UIButton *btn in self.selBtnArr) {
        btn.selected = false;
        btn.backgroundColor = RGB(235, 235, 235, 1);
    }
    [self.selBtnArr removeAllObjects];
}

// 确定按钮
- (void)sureAction:(UIButton *)btn{
    
    if (self.sureBlock) {
        NSMutableArray *itemsArr = [NSMutableArray array];
        for (UIButton *btn in self.selBtnArr) {
            [itemsArr addObject:btn.titleLabel.text];
        }
        self.sureBlock(itemsArr);
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)selBtnArr{
    
    if (_selBtnArr == nil) {
        
        _selBtnArr = [NSMutableArray array];
    }
    
    return _selBtnArr;
}

- (NSMutableArray *)allBtnArr{
    
    if (_allBtnArr == nil) {
        
        _allBtnArr = [NSMutableArray array];
    }
    
    return _allBtnArr;
}

@end

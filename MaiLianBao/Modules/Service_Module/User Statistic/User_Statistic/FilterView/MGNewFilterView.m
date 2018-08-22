//
//  MGNewFilterView.m
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGNewFilterView.h"
#import "UIView+BSLine.h"
#import "MGNewTimePickView.h"
#import "MGNewDeviceTypeView.h"
#import "MGItemTool.h"
#import "MGChannelManageOutModel.h"

@interface MGNewFilterView()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIView *filterView;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UILabel *topLab;

@property(nonatomic,strong)UILabel *monthDesLab;

@property(nonatomic,strong)UILabel *monthLab;

@property(nonatomic,strong)UIImageView *editImgv;

@property(nonatomic,strong)UILabel *deviceDesLab;

@property(nonatomic,strong)UIButton *resetBtn;

@property(nonatomic,strong)UIButton *confirmBtn;

@property(nonatomic,strong)MGNewDeviceTypeView *deviceTypeView;

@property(nonatomic,strong)NSMutableArray *dateInfoArr;

@property(nonatomic,strong)NSMutableArray *deviceIdsArr;

@property(nonatomic,copy)void(^selBlock)(NSString *dateBlock,NSString *deviceIdsBlock);

// 日期选择结果
@property(nonatomic,copy)NSString *resultDateInfo;

// 设备机型选择结果
@property(nonatomic,copy)NSMutableString *resultDeviceInfo;

@end

@implementation MGNewFilterView

- (instancetype)initWithDateInfoArr:(NSMutableArray *)dateInfoArr
                       deviceIdsArr:(NSMutableArray *)deviceIdsArr
                        selBlock:(void(^)(NSString *dateBlock,NSString *deviceIdsBlock))selBlock{
    
    if (self = [super init]) {
        
        NSParameterAssert(dateInfoArr.count != 0 && dateInfoArr != nil);
        NSParameterAssert(deviceIdsArr.count != 0 && deviceIdsArr != nil);
        
        // 外部设置frame无效
        self.frame = CGRectMake(kScreenW, 0, kScreenW, kScreenH);
        self.selBlock = selBlock;
        
        // 构建筛选条件
        self.dateInfoArr = dateInfoArr;
        self.deviceIdsArr = deviceIdsArr;
        
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapAction)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.filterView];
        
        [self.filterView addSubview:self.topView];
        [self.topView addSubview:self.topLab];
        [self.filterView addSubview:self.monthDesLab];
        [self.filterView addSubview:self.monthLab];
        [self.filterView addSubview:self.editImgv];
        
        [self.filterView addHorLineWithPadingTop:_monthDesLab.bottom + AdaptH(10) left:0 right:0];
         
        [self.filterView addSubview:self.deviceDesLab];
        [self.filterView addHorLineWithPadingTop:_deviceDesLab.bottom + AdaptH(10) left:0 right:0];
        
        [self.filterView addSubview:self.resetBtn];
        [self.filterView addSubview:self.confirmBtn];
        [self.filterView addSubview:self.deviceTypeView];
    }
    
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
// 手势开始识别
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    // 判断一个范围，进行识别
    CGPoint point = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.filterView.frame, point)) {
        return NO;
    }
    else{
        return YES;
    }
}

#pragma mark - 懒加载
- (UIView *)filterView{
    
    if (_filterView == nil) {
        
        _filterView = [[UIView alloc] initWithFrame:CGRectMake(self.width - AdaptW(260),  0,AdaptW(260), kScreenH)];
        _filterView.backgroundColor = [UIColor whiteColor];
    }
    
    return _filterView;
}

- (UIView *)topView{
    
    if (_topView == nil) {
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_filterView.width, AdaptH(40))];
        _topView.backgroundColor = RGB(238, 238, 238, 1);
    }
    
    return _topView;
}

- (UILabel *)topLab{
    
    if (_topLab == nil) {
        
        _topLab = [[UILabel alloc] initWithFrame:CGRectMake(AdaptW(15), AdaptH(10), AdaptW(120), AdaptH(20))];
        _topLab.font = [UIFont systemFontOfSize:14];
        _topLab.textColor = RGB(136, 136, 136, 1);
        _topLab.text = @"筛选条件";
    }
    
    return _topLab;
}

- (UILabel *)monthDesLab{
    
    if (_monthDesLab == nil) {
        
        _monthDesLab = [[UILabel alloc] initWithFrame:CGRectMake(AdaptW(15), _topView.bottom + AdaptH(40), AdaptW(40), AdaptH(20))];
        _monthDesLab.text = @"月份";
        _monthDesLab.font = [UIFont systemFontOfSize:14];
        _monthDesLab.textColor = RGB(51, 51, 51, 1);
    }
    
    return _monthDesLab;
}

- (UILabel *)monthLab{
    
    if (_monthLab == nil) {
        
        _monthLab = [[UILabel alloc] initWithFrame:CGRectMake(_monthDesLab.right + AdaptW(40), _monthDesLab.top, AdaptW(80), AdaptH(20))];
        _monthLab.text = [MGItemTool getCurrentYearAndMonth];
        _monthLab.font = [UIFont systemFontOfSize:14];
        _monthLab.textColor = RGB(51, 51, 51, 1);
        _monthLab.userInteractionEnabled = true;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_monthLab addGestureRecognizer:tap];
    }
    
    return _monthLab;
}

- (UIImageView *)editImgv{
    
    if (_editImgv == nil) {
        
        _editImgv = [[UIImageView alloc] initWithFrame:CGRectMake(_monthLab.right, _monthDesLab.top, AdaptW(15), AdaptH(15))];
        _editImgv.image = [UIImage imageNamed:@"edit_btn"];
        _editImgv.userInteractionEnabled = true;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_editImgv addGestureRecognizer:tap];
    }
    
    return _editImgv;
}

- (UILabel *)deviceDesLab{
    
    if (_deviceDesLab == nil) {
        
        _deviceDesLab = [[UILabel alloc] initWithFrame:CGRectMake(AdaptW(15), _monthLab.bottom + AdaptH(40), AdaptW(80), AdaptH(20))];
        _deviceDesLab.text = @"设备类型";
        _deviceDesLab.font = [UIFont systemFontOfSize:14];
        _deviceDesLab.textColor = RGB(51, 51, 51, 1);
    }
    
    return _deviceDesLab;
}

- (UIButton *)resetBtn{
    
    if (_resetBtn == nil) {
        
        _resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.height - AdaptH(50),_filterView.width/2,AdaptH(50))];
        [_resetBtn setTitleColor:RGB(255,130,18,1) forState:UIControlStateNormal];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        _resetBtn.lineColor = RGB(255,130,18,1);
        [_resetBtn addTopLineWithLeftPading:0 andRightPading:0];
        [_resetBtn addLeftLineWithTopPading:0 andBottomPading:0];
        _resetBtn.backgroundColor = [UIColor whiteColor];
        [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _resetBtn;
}

- (UIButton *)confirmBtn{
    
    if (_confirmBtn == nil) {
        
        // 确定按钮
        self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.resetBtn.right,self.height - AdaptH(50),_filterView.width/2,AdaptH(50))];
        [self.confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.confirmBtn.backgroundColor = RGB(255,130,18,1);
        [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmBtn];
    }
    
    return _confirmBtn;
}

- (MGNewDeviceTypeView *)deviceTypeView{
    
    if (_deviceTypeView == nil) {
        
        weakSelf(self);
        _deviceTypeView = [[MGNewDeviceTypeView alloc] initWithFrame:CGRectMake(AdaptW(15), self.deviceDesLab.bottom + AdaptH(40), _filterView.width - 2 * AdaptW(15), _resetBtn.top - self.deviceDesLab.bottom - AdaptH(50))  itemsArray:self.deviceIdsArr selDateBlock:^(NSMutableString *deviceStr) {
           
            weakSelf.resultDeviceInfo = deviceStr;
        }];
    }
    
    return _deviceTypeView;
}

- (NSMutableString *)resultDeviceInfo{
    
    if (_resultDeviceInfo == nil) {

        _resultDeviceInfo = [NSMutableString string];
        // 初始化填充选中的设备id
        for (NSInteger i = 0; i < self.deviceIdsArr.count; i++) {
            MGDeviceTypeOutModel *model = self.deviceIdsArr[i];
            if (i != self.deviceIdsArr.count - 1) {
                NSString *tmpStr = [NSString stringWithFormat:@"%@,",model.DeviceNum];
                [_resultDeviceInfo appendString:tmpStr];
            }
            else{
                [_resultDeviceInfo appendString:model.DeviceNum];
            }
        }
    }
    
    return _resultDeviceInfo;
}

#pragma mark -  事件响应
// 重置
- (void)resetAction{
    
    [self.deviceTypeView resetSelDataArr];
}
// 确定
- (void)confirmAction{
    
    NSString *exYear = [self.monthLab.text stringByReplacingOccurrencesOfString:@"年" withString:@""];
    NSString *exMonth = [exYear stringByReplacingOccurrencesOfString:@"月" withString:@""];

    [self makeToast:exMonth];
    [self makeToast:self.resultDeviceInfo];
    
    if (self.selBlock) {
        self.selBlock(exMonth, self.resultDeviceInfo);
    }
}

- (void)tapAction{
 
    MGNewTimePickView *pickerView = [[MGNewTimePickView alloc] initDataArray:self.dateInfoArr selBlock:^(NSString *str) {
        
        self.monthLab.text = str;
    }];
    
    [pickerView show];
}


// 显示
- (void)show{
    
    self.isShow = true;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelAlert;
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    }];
}

// 隐藏
- (void)dismiss{
    
    self.isShow = false;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelNormal;
    
    [UIView animateWithDuration:0.25 animations:^{
         self.frame = CGRectMake(kScreenW, 0, kScreenW, kScreenH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 隐藏当前视图手势
- (void)dismissTapAction{
    
    [self dismiss];
}

@end

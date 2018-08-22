//
//  MGTreeTableViewCell.m
//  MaiLianBao
//
//  Created by MapGoo on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGTreeTableViewCell.h"

// cell左侧按钮图标
#define PlusBtnImg  @"+"
#define MinusBtnImg @"-0"

@interface  MGTreeTableViewCell()

@property(nonatomic,strong)UIButton *leftBtn;

@end

@implementation MGTreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:AdaptFont(15)];
        
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setImage:[UIImage imageNamed:PlusBtnImg] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.textLabel.mas_left).mas_offset(-AdaptW(8));
            make.size.mas_equalTo(CGSizeMake(AdaptW(20),self.height));
        }];
    }

    return self;
}

- (void)setModel:(MGLeftMenuModel *)model
{
    _model = model;
    
    self.textLabel.text = _model.name;
    
#warning 注意：在cell的set方法里面判断model，if里面给某个对象赋值后，else里面也要相应给它赋值，否则会出现复用问题
    if (_model.isExpansion)
    {
        [_leftBtn setImage:[UIImage imageNamed:MinusBtnImg] forState:UIControlStateNormal];
    }
    else
    {
        [_leftBtn setImage:[UIImage imageNamed:PlusBtnImg] forState:UIControlStateNormal];
    }
    
    // 判断是否是最底层节点，最底层节点左侧不显示图标，否则显示图标
    for (NSInteger i = 0;i < _dataList.count;i++)
    {
        MGLeftMenuModel *aModel = _dataList[i];

        if (aModel.parentId != _model.mId)
        {
            if (i == _dataList.count - 1)
            {
                _leftBtn.hidden = YES;
                break;
            }
            
            continue;
        }
        else
        {
            _leftBtn.hidden = NO;
            break;
        }
    }
}

- (void)leftBtnAction:(UIButton *)btn
{
    if (self.leftBtnBlock)
    {
        self.leftBtnBlock();
    }
}

@end

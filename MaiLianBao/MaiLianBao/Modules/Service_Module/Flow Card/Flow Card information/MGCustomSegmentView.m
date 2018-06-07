//
//  MGCustomSegmentView.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/24.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGCustomSegmentView.h"
#import "UIView+BSLine.h"

#define ButtonTag 8888

@interface MGCustomSegmentView ()
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIView * sliderView;
@end

@implementation MGCustomSegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configCommon];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        if ([items count] > 0)
        {
            self.items = items;
        }
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    [self layoutSubviews];
}

- (void)configCommon
{
    _font = [UIFont systemFontOfSize:AdaptFont(15.f)];
    _textColor = UIColorFromRGB(0x333333);
    _selectedTextColor = UIColorFromRGB(0xfe8d2e);
    _selectionIndicatorColor = UIColorFromRGB(0xfe8d2e);
    _backgroundColor = [UIColor whiteColor];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _sliderView = [[UIView alloc] init];
    _sliderView.backgroundColor = _selectionIndicatorColor;
    [self addSubview:_sliderView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView * subView in _contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    _contentView.backgroundColor = _backgroundColor;
    _contentView.frame = self.bounds;
    
    for (int i = 0; i < [_items count]; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = ButtonTag + i;
        [button setTitleColor:_textColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedTextColor forState:UIControlStateSelected];
        [button setTitle:_items[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:_font];
        
        CGFloat itemWidth = self.width / _items.count;
        button.size = CGSizeMake(itemWidth, self.height);
        button.left = itemWidth * i;
        
        if (i == _selectedSegmentIndex)
        {
            if ([_items count] == 1)
            {
                _sliderView.frame = CGRectZero;
                button.userInteractionEnabled = NO;
            }
            else
            {
                _sliderView.frame = CGRectMake(button.left + AdaptW(10), self.height - AdaptH(3), (self.width - AdaptW(40))/_items.count, AdaptH(3));
                button.userInteractionEnabled = YES;
            }
            button.selected = YES;
        }
        else
        {
            button.backgroundColor = [UIColor clearColor];
        }
        
        [button addTarget:self action:@selector(didSelectedSegment:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    UIButton *oldItemButton = [_contentView viewWithTag:ButtonTag + _selectedSegmentIndex];
    oldItemButton.backgroundColor = [UIColor whiteColor];
    [oldItemButton setTitleColor:_textColor forState:UIControlStateNormal];
    oldItemButton.selected = NO;
    
    UIButton * button = [_contentView viewWithTag:ButtonTag + selectedSegmentIndex];
    [button setTitleColor:_selectedTextColor forState:UIControlStateNormal];
    button.selected = YES;
    _selectedSegmentIndex = selectedSegmentIndex;
    
    [UIView animateWithDuration:0.25 animations:^{
        _sliderView.left = button.left + AdaptW(10);
    }];
}

- (void)didSelectedSegment:(UIButton *)button
{
    UIButton * oldButton = [_contentView viewWithTag:ButtonTag + _selectedSegmentIndex];
    oldButton.backgroundColor = [UIColor whiteColor];
    [oldButton setTitleColor:_textColor forState:UIControlStateNormal];
    oldButton.selected = NO;
    
    [button setTitleColor:_selectedTextColor forState:UIControlStateNormal];
    button.selected = YES;
    
    _selectedSegmentIndex = button.tag - ButtonTag;
    
    [UIView animateWithDuration:0.25 animations:^{
        _sliderView.left = button.left + AdaptW(10);
    }];

    if (self.indexChangeBlock)
    {
        self.indexChangeBlock(_selectedSegmentIndex);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
@end

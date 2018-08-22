//
//  MGCustomSegmentView.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/24.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGCustomSegmentView : UIControl
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectionIndicatorColor;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, copy) void(^indexChangeBlock)(NSInteger index);

- (id)initWithItems:(NSArray *)items;

@end

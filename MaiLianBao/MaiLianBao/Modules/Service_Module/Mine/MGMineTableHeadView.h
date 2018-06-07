//
//  MGMineTableHeadView.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMineTableHeadView : UIView

// 上方logoImg
@property(nonatomic,strong)UIImageView *topImg;

// 中间Lab
@property(nonatomic,strong)UILabel *midTitle;

// 整个View的点击手势
@property(nonatomic,copy) void(^tapBlock)();

// 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                        bgImg:(NSString *)bgImg  // 背景图片
                      logoImg:(NSString *)logoImg // logo图片
                  middleTitle:(NSString *)middleTitle // 中间标题
                    itemArray:(NSMutableArray *)itemArray // 下方item描述字符串数组
                 contentArray:(NSMutableArray *)contentArray; // 下方item内容字符串数组

// 重设下方item底部Lab的内容
- (void)setItemLabDataWithArray:(NSMutableArray *)array;

@end

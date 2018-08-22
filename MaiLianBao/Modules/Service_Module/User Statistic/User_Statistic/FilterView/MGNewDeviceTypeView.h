//
//  MGNewDeviceTypeView.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGNewDeviceTypeView : UIView

@property(nonatomic,copy)void(^isSelBlock)(BOOL);

- (instancetype)initWithFrame:(CGRect)frame
                   itemsArray:(NSMutableArray *)itemsArray
                 selDateBlock:(void(^)(NSMutableString *))selDateBlock;

// 重置选中数组
- (void)resetSelDataArr;

@end

//
//  MGUserStatisticFilterView.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/9.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGUserStatisticFilterView : UIView

@property(nonatomic,copy)void(^sureBlock)(NSMutableArray *itemsName);

- (instancetype)initWithFrame:(CGRect)frame
                    deviceArr:(NSMutableArray *)deviceArr;

@end

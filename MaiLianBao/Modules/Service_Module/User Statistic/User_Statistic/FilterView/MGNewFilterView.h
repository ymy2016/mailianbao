//
//  MGNewFilterView.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGNewFilterView : UIView

// 是否已经显示
@property(nonatomic,assign)BOOL isShow;

- (instancetype)initWithDateInfoArr:(NSMutableArray *)dateInfoArr
                       deviceIdsArr:(NSMutableArray *)deviceIdsArr
                           selBlock:(void(^)(NSString *dateBlock,NSString *deviceIdsBlock))selBlock;

// 显示
- (void)show;

// 隐藏
- (void)dismiss;

@end

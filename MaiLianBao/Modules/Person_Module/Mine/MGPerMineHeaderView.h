//
//  MGPerMineHeaderView.h
//  MaiLianBao
//
//  Created by 伟华 on 17/1/4.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGPerMineHeaderView : UIView

// 中心图片
@property(nonatomic,strong)UIImageView *centerImgv;
// 昵称
@property(nonatomic,strong)UILabel     *nickLab;

// 点击block
@property(nonatomic,copy) void(^clickBlock)();

- (instancetype)initWithFrame:(CGRect)frame
                    centerImg:(NSString *)centerImg
                     nickName:(NSString *)nickName;

@end

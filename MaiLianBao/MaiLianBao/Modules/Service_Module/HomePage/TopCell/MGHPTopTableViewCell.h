//
//  MGHPTopTableViewCell.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGHPRebateModel.h"

// 标注Imgv点击位置
typedef NS_ENUM(NSInteger,ImgvPosition)
{
    LeftPosition,
    RightPosition
};

// 图片点击手势
@protocol TopCellImgTapDelegate <NSObject>

- (void)handleImgvTapWithImgvPosition:(ImgvPosition)imgvPosition;

@end

@interface MGHPTopTableViewCell : UITableViewCell

@property(nonatomic,strong)MGHPRebateModel *model;

@property(nonatomic,weak)id<TopCellImgTapDelegate> delegate;

@end

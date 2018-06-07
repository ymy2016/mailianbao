//
//  MGPerMsgTableViewCell.h
//  MaiLianBao
//
//  Created by 伟华 on 17/1/7.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGPerMsgModel.h"

@interface MGPerMsgTableViewCell : UITableViewCell

@property(nonatomic,strong)MGPerMsgModel *model;

// 计算当前cell的高度
- (CGFloat)prepareLayoutHeight;

@end

//
//  MGDeviceTypeCell.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGChannelManageOutModel.h"

@interface MGDeviceTypeCell : UICollectionViewCell

@property(nonatomic,strong)MGDeviceTypeOutModel *model;

@property(nonatomic,strong)UIButton *titleBtn;

@property(nonatomic,copy)void(^selBlock)(BOOL,MGDeviceTypeOutModel *);

@end

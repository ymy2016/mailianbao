//
//  MGHPMidTableViewCell.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MidCellCheckDelegate <NSObject>

- (void)handleCheckRecentRebate;

@end

@interface MGHPMidTableViewCell : UITableViewCell

@property(nonatomic,weak)id<MidCellCheckDelegate>delegate;

@end

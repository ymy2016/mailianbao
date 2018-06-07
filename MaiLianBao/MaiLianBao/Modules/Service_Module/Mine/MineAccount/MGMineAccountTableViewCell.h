//
//  MGMineAccountTableViewCell.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMineAccountTableViewCell : UITableViewCell

@property(nonatomic,strong)UITextField *inputTf;

@property(nonatomic,copy)void(^inputBlock)(NSString *);

@end

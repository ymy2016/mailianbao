//
//  MGMineItemView.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGMineItemView : UIView

@property(nonatomic,strong)UILabel *topLab;
@property(nonatomic,strong)UILabel *bottomLab;

- (instancetype)initWithFrame:(CGRect)frame
                    topLabStr:(NSString *)topLabStr
                 bottomLabStr:(NSString *)bottomLabStr;

@end

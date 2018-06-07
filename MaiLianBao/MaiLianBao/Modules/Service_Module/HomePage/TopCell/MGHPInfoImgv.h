//
//  MGHPInfoImgv.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGHPInfoImgv : UIImageView

// 上方内容Lab
@property(nonatomic,strong)UILabel *topLab;
// 下方内容Lab
@property(nonatomic,strong)UILabel *botLab;

- (instancetype)initWithFrame:(CGRect)frame
                    topDesStr:(NSString *)topDesStr // 上方描述字符串
                    botDesStr:(NSString *)botDesStr; // 下方描述字符串

@end

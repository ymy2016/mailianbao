//
//  MGMineTableHeadView.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/20.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGMineTableHeadView.h"
#import "UIView+BSLine.h"
#import "MGMineItemView.h"

@implementation MGMineTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
                        bgImg:(NSString *)bgImg
                      logoImg:(NSString *)logoImg
                  middleTitle:(NSString *)middleTitle
                    itemArray:(NSMutableArray *)itemArray
                 contentArray:(NSMutableArray *)contentArray
{
    if (self = [super initWithFrame:frame])
    {
        if (bgImg.length != 0)
        {
            // 给View添加背景图片
            UIImage *bgvImg = [UIImage imageNamed:bgImg];
            self.layer.contents = (id)bgvImg.CGImage;
        }
        else
        {
            self.backgroundColor = [UIColor clearColor];
        }
        
        UIImageView *topImg = [[UIImageView alloc] init];
        self.topImg = topImg;
        topImg.contentMode = UIViewContentModeScaleAspectFit;
        topImg.image = [UIImage imageNamed:logoImg];
        [self addSubview:topImg];
        [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).mas_offset(AdaptH(80));
            make.size.mas_equalTo(CGSizeMake(AdaptW(83),AdaptW(83)));
        }];
        
        UILabel *midTitle = [[UILabel alloc] init];
        self.midTitle = midTitle;
        midTitle.text = middleTitle;
        midTitle.textAlignment = NSTextAlignmentCenter;
        midTitle.textColor = [UIColor whiteColor];
        midTitle.font = [UIFont boldSystemFontOfSize:AdaptFont(17)];
        [self addSubview:midTitle];
        [midTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topImg.mas_bottom).mas_offset(AdaptH(8));
            make.centerX.equalTo(self);
            make.height.mas_equalTo(AdaptH(30));
        }];
        
        
        /*
        if (itemArray != nil && contentArray != nil)
        {
            // 循环遍历，创建itemView
            for (NSInteger i = 0;i < itemArray.count;i++)
            {
                CGFloat itemWidth = (self.width - AdaptW(10)*2)/itemArray.count;
                MGMineItemView *itemBgView = [[MGMineItemView alloc] initWithFrame:CGRectMake(AdaptW(10)+itemWidth*i,self.bottom-AdaptH(80),itemWidth,AdaptH(80)) topLabStr:itemArray[i] bottomLabStr:contentArray[i]];
                
                if (i != itemArray.count - 1)
                {
                    // 添加item右侧划线
                    itemBgView.lineColor = UIColorFromRGB(0xcc6261);
                    [itemBgView addRightLineWithTopPaidng:0 andBottomPading:-AdaptH(25)];
                }
                
                [self addSubview:itemBgView];
                
            }
 
        }
        */
        
        // 整个View添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
    }

    return self;
}

- (void)setItemLabDataWithArray:(NSMutableArray *)array
{
    // self.subviews 前两个子视图为 topImg 、midTitle，因此排除它们
    // 未激活
    MGMineItemView *unactivatedItem = self.subviews[2];
    // 正常
    MGMineItemView *normalItem = self.subviews[3];
    // 已停机
    MGMineItemView *deactivatedItem = self.subviews[4];

    unactivatedItem.bottomLab.text = [NSString stringWithFormat:@"%@",array[0]];
    normalItem.bottomLab.text = [NSString stringWithFormat:@"%@",array[1]];
    deactivatedItem.bottomLab.text = [NSString stringWithFormat:@"%@",array[2]];
}

- (void)tapAction
{
    if (self.tapBlock)
    {
        self.tapBlock();
    }
}


@end

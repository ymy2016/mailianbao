//
//  MGNewTimePickView.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/13.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGNewTimePickView : UIView

- (instancetype)initDataArray:(NSMutableArray *)dataArray
                     selBlock:(void(^)(NSString *))selBlock;

- (void)reloadDataWithListArray:(NSMutableArray *)listArray;

- (void)show;

@end

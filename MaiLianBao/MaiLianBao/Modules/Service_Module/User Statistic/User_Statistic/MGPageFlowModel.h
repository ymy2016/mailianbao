//
//  MGPageFlowModel.h
//  MaiLianBao
//
//  Created by 谭伟华 on 2018/4/11.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGPageFlowModel : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *num;

- (instancetype)initWithTitle:(NSString *)title num:(NSString *)num;

@end

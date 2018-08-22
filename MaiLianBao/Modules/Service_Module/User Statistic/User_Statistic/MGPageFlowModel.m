//
//  MGPageFlowModel.m
//  MaiLianBao
//
//  Created by 谭伟华 on 2018/4/11.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import "MGPageFlowModel.h"

@implementation MGPageFlowModel

- (instancetype)initWithTitle:(NSString *)title num:(NSString *)num{
    
    if (self = [super init]) {
        
        self.title = title;
        self.num = num;
    }
    
    return self;
}

@end

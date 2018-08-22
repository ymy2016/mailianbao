//
//  MGSimMenuRequest.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/29.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"
#import "MGCardEnum.h"

@interface MGSimMenuRequest : MGRequest

- (instancetype)initWithHoldId:(NSInteger)holdId;

- (SimCardType)simFromType;

@end

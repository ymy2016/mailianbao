//
//  MGHPRebateRequest.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGHPRebateRequest : MGRequest

- (instancetype)initWithHoldId:(NSInteger)holdId
                        isSync:(NSInteger)isSync;

@end

//
//  MGFlowInfoRequest.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGFlowInfoRequest : MGRequest

- (instancetype)initWithSimId:(NSInteger)simId;

- (instancetype)initWithKey:(NSInteger)key;

@end

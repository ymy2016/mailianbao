//
//  MGRemoveBindRequest.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/11.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGRemoveBindRequest : MGRequest

- (instancetype)initWithToken:(NSString *)token simID:(NSString *)simID;

@end

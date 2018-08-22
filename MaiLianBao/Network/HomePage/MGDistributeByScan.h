//
//  MGDistributeByScan.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/6.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGDistributeByScan : MGRequest

- (instancetype)initWithHoldId:(NSInteger)holdId userId:(NSInteger)userId str:(NSString *)str;

@end

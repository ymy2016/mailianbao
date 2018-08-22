//
//  MGPerLoginRequest.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/10.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGPerLoginRequest : MGRequest

- (instancetype)initWithMobile:(NSString *)mobile validcode:(NSString *)validcode;

@end

//
//  MGLoginRequest.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/26.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGLoginRequest : MGRequest

- (instancetype)initWithUserName:(NSString *)userName
                        password:(NSString *)password
                        showTips:(NSString *)showTips
                        delegate:(id<YTKRequestDelegate>)delegate;

@end

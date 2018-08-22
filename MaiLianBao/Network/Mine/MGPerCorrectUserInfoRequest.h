//
//  MGCorrectUserInfoRequest.h
//  MaiLianBao
//
//  Created by 伟华 on 17/1/11.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGRequest.h"

@interface MGPerCorrectUserInfoRequest : MGRequest

- (instancetype)initWithToken:(NSString *)token
                     nickName:(NSString *)nickName
                    iconImage:(NSString *)iconImage
                     showTips:(NSString *)showTips
                     delegate:(id<YTKRequestDelegate>)delegate;
@end

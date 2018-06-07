//
//  MGOpenApi.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGOpenApi.h"

@implementation MGOpenApi

+ (NSURL *)openApiWithFlowQuery:(NSString *)userid
                          mchId:(NSString *)mchId
                            num:(NSString *)num
                       num_type:(NSString *)num_type
                      timestamp:(NSString *)timestamp
                           sign:(NSString *)sign
                        os_type:(NSString *)os_type
{
    NSString *URLString = [NSString stringWithFormat:@"%@/Html/Terminal/SDKQuery.aspx?userId=%@&mchId=%@&num=%@&num_type=%@&timestamp=%@&sign=%@&os_type=%@",
                           URL_Base,
                           userid,
                           mchId,
                           num,
                           num_type,
                           timestamp,
                           sign,
                           os_type];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    return URL;
}

+ (NSURL *)bindSimWithToken:(NSString *)token
{
    NSString *URLString = [NSString stringWithFormat:@"%@/Html/Terminal/bindsims_APP.aspx?tokent=%@",URL_Base,token];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    return URL;
}
@end

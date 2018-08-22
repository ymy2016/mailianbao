//
//  MGOpenApi.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGOpenApi : NSObject

/**
 流量卡查询的URL
 
 @param userid    用户id
 @param mchId     商户id
 @param num       卡号
 @param num_type  卡类型 iccid:按卡号ICCID查询 sim:按SIM查询 IMSI:按IMSI查询
 @param timestamp 时间戳
 @param sign      签名 (userid + key + 时间戳 进行MD5加密后转成大写)
 @param os_type   操作平台烈性
 
 @return 返回一个H5的URL
 */
+ (NSURL *)openApiWithFlowQuery:(NSString *)userid
                          mchId:(NSString *)mchId
                            num:(NSString *)num
                       num_type:(NSString *)num_type
                      timestamp:(NSString *)timestamp
                           sign:(NSString *)sign
                        os_type:(NSString *)os_type;


/**
 绑定卡URL

 @param token 登录时获取的token

 @return 返回一个H5的URL
 */
+ (NSURL *)bindSimWithToken:(NSString *)token;

@end

//
//  MGMineGetUrlRequest.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/11.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGMineGetUrlRequest.h"

@interface MGMineGetUrlRequest ()

// 上传者id(可以是设备imei、app的登录帐号id)
@property(nonatomic,assign)int uid;

// 图片内容(需要base64编码处理,最大支持5M)
@property(nonatomic,strong)NSString *image;

@end


@implementation MGMineGetUrlRequest

- (instancetype)initWithUid:(int)uid
                     image:(NSString *)image
                     delegate:(id<YTKRequestDelegate>)delegate{
    
    if (self = [super init]) {
        
        _uid = uid;
        _image = image;
        self.delegate = delegate;
        
    }
    
    return self;
}

- (NSString *)baseUrl{

    return @"http://open.u12580.com/";
}

- (NSString *)requestUrl
{
    return URL_ImgToUrl;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    return @{
             @"uid":@(_uid),
             @"image":_image
             };
}

@end

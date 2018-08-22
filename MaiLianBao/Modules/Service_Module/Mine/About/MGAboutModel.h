//
//  MGAboutModel.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/21.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGAboutModel : NSObject

// 上方logo
@property(nonatomic,strong)NSString *topImg;
// 版本标题
@property(nonatomic,strong)NSString *versionStr;
// cell数据源
@property(nonatomic,strong)NSMutableArray *dataList;
// 用户协议
@property(nonatomic,strong)NSAttributedString *agreementStr;
// 著作权
@property(nonatomic,strong)NSString *workRightStr;

@end

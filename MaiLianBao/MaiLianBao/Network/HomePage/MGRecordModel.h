//
//  MGRecordModel.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/7.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGRecordModel : NSObject

@end

@interface MGScanRecordModel : NSObject

@property (nonatomic, copy) NSString *iccid;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, assign) NSInteger distributeState;

@end

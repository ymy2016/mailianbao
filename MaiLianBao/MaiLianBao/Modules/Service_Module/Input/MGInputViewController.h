//
//  MGInputViewController.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/12/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGViewController.h"

typedef enum {
    MGInputListType = 0,
    MGScanListType
}MGListType;//枚举名称

@interface MGInputViewController : MGViewController

- (instancetype)initWithListType:(MGListType)listType;

/** 扫描结果 */
@property (nonatomic, copy) NSString *scanResult;

@end

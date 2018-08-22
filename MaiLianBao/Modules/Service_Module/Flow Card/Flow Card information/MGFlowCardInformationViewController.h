//
//  MGFlowCardInformationViewController.h
//  MaiLianBao
//
//  Created by 苏晗 on 16/7/22.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGViewController.h"
#import "MGCardEnum.h"

@interface MGFlowCardInformationViewController : MGViewController

- (instancetype)initWithCode:(NSInteger)code CardType:(SimCardType)cType GetType:(SimGetInfoType)gType;

@end


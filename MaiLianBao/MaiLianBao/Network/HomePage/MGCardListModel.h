//
//  MGCardListModel.h
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/11.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "CodingObject.h"

@interface MGCardListModel : CodingObject

@property (nonatomic, copy) NSString *ICCID;
@property (nonatomic, copy) NSString *SimID;
@property (nonatomic, assign) NSInteger State;
@property (nonatomic, copy) NSString *StateStr;
@property (nonatomic, assign) NSInteger SimFromType;
@end

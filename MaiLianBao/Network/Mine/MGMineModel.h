//
//  MGMineModel.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/28.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodingObject.h"

@interface MGMineModel : CodingObject

@property(nonatomic,assign)NSInteger mId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,assign)NSInteger allCount;
@property(nonatomic,assign)NSInteger unactivatedCount;
@property(nonatomic,assign)NSInteger activatedCount;
@property(nonatomic,assign)NSInteger deactivatedCount;

@end

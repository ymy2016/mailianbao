//
//  MGChannelManageOutModel.h
//  MaiLianBao
//
//  Created by 伟华 on 2018/4/12.
//  Copyright © 2018年 Twh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ModelType){
   
    FirstActivationType, // 首次入网
    RenewType,           // 续费
    StopType,            // 停机
    RegisterUserType,    // 注册用户
    ActivieUserType      // 活跃用户
};


@class MGGrowthTrendOutModel;
@class MGUserSynthesisUseOutModel;
@class MGDeviceTypeOutModel;

// 渠道管理输出模型
@interface MGChannelManageOutModel : NSObject

// 未激活
@property(nonatomic,assign)long Notused;
// 可激活
@property(nonatomic,assign)long Activable;
// 已激活
@property(nonatomic,assign)long Active;
// 已停用
@property(nonatomic,assign)long Terminated;
// 公众号用户关注数
@property(nonatomic,assign)long Wechatuser;
// 注册用户
@property(nonatomic,assign)long Registeruser;
// 使用用户
@property(nonatomic,assign)long Useuser;
// 实名用户
@property(nonatomic,assign)long Realnameuser;

// 麦联宝用户增长趋势
@property(nonatomic,strong)NSMutableArray *rptUserGrowthTrendEntity;
// 用户综合使用情况汇总
@property(nonatomic,strong)NSMutableArray *rptUserSynthesisUseEntity;
// 用户设备类型
@property(nonatomic,strong)NSMutableArray *holdDeviceTypeEntity;

//// 麦联宝用户增长趋势
//@property(nonatomic,strong)MGGrowthTrendOutModel *rptUserGrowthTrendEntity;
//// 用户综合使用情况汇总
//@property(nonatomic,strong)MGUserSynthesisUseOutModel *rptUserSynthesisUseEntity;
//// 用户设备类型
//@property(nonatomic,strong)MGDeviceTypeOutModel *holdDeviceTypeEntity;

// 可选月份
@property(nonatomic,strong)NSMutableArray *historyCountMonth;

@end

// 用户增长趋势
@interface MGGrowthTrendOutModel : NSObject

// 注册用户
@property(nonatomic,assign)NSInteger Newfollow;
// 使用用户
@property(nonatomic,assign)NSInteger Newregister;
// 实名用户
@property(nonatomic,assign)NSInteger Newuse;
// 纬度(暂不解析)
//@property(nonatomic,assign)NSInteger Datedim;
// 年
@property(nonatomic,copy)NSString *Y;
// 天/周/日
@property(nonatomic,copy)NSString *V;

@end

// 用户综合使用情况汇总
@interface MGUserSynthesisUseOutModel : NSObject<NSMutableCopying>

@property(nonatomic,assign)NSInteger HoldID;

@property(nonatomic,copy)NSString *HoldName;
@property(nonatomic,assign)NSInteger TotalCardNum;
@property(nonatomic,assign)NSInteger Used;

@property(nonatomic,assign)double RegisterUser;
@property(nonatomic,assign)NSInteger RealNameUser;
@property(nonatomic,assign)double ActiveUser;
@property(nonatomic,assign)NSInteger WeChatFollow;
@property(nonatomic,assign)double FirstActivation;
@property(nonatomic,assign)NSInteger FirstRenew;
@property(nonatomic,assign)double Stopped;

@property(nonatomic,assign)double RenewAmount;
@property(nonatomic,assign)double RebateAmount;
@property(nonatomic,assign)double RenewCount;

@property(nonatomic,copy)NSString *UsageRate;
@property(nonatomic,copy)NSString *OutageRate;
@property(nonatomic,copy)NSString *FollowRate;
@property(nonatomic,copy)NSString *RealNameRate;
@property(nonatomic,copy)NSString *PhoneBindRate;
@property(nonatomic,copy)NSString *RenewalRate;

/** 以下为自定义添加，非接口返回值 */
// 为了绘制横向柱状图
@property(nonatomic,assign)double maxValue;

// 区分使用在(首次入网、续费、停机、注册用户、活跃用户)不同cell
@property(nonatomic,assign)ModelType modelType;

@end

@interface MGDeviceTypeOutModel : NSObject

@property(nonatomic,assign)NSInteger DeviceID;
@property(nonatomic,copy)NSString *DeviceNum;
// 本地新增字段，表示是否已经选选中
@property(nonatomic,assign)BOOL isSel;

@end




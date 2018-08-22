//
//  NetworkConfig.h
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//


//#if 1             //外网正式
//#define URL_Base          @"http://open.m-m10010.com"

#define URL_Base            @"http://open.m-m10010.com"

//#define URL_Base          @"http://192.168.110.30"

//#define URL_Base          @"http://192.168.100.107:8000/"

//
//#elif(0)        //test测试
//
//#define URL_Base          @"http://test.app001.u12580.com"
//
//#elif(0)
//
//#define URL_Base          @"http://192.168.100.113/usageopen"
//
//#endif


// 微信应用id
#define WXAppID @"wx3d8daa3390c26924"
// 微信支付商户号
#define WXMerchantID @"1400326702"
#define WXAppSecret @"8d7d158f64b7ff893c5534f76a0a7669"

/*======================== 网络请求URL_detail ========================*/

/*** 登录模块 ***/
// 登录
#define URL_Login @"/api/OperatorAPP/Login"

// 个人登录
#define URL_Per_Login @"/api/MemberAPP/Login"

// 验证码
#define URL_Captcha @"/api/SendLoginValidSMS"
// 流量卡列表
#define URL_Per_CardList @"/api/MemberAPP/GetCardList"
// 流量卡解绑接口
#define URL_Per_UnBind  @"/api/RemoveICCIDBind"

/*** 我的模块 ***/
// 我的界面
#define URL_Mine @"/api/OperatorAPP/HoldInfo"
// 修改密码
#define URL_CorrectPW @"/api/OperatorAPP/Password"
// 流量卡常见问题(html5)
#define URL_FlowCardQuestion @"https://open.m-m10010.com/html/Terminal/fq_app.html"
// 用户使用许可协议(html5)
#define URL_UserAgreeMent @"https://open.m-m10010.com/Html/Terminal/UserAgreement.html"
// 个人车主，修改用户信息(昵称、头像)
#define URL_Per_CorrectUserInfo @"/api/MemberAPP/SetUserNameImage/"
// 中间件，图片转换成url
#define URL_ImgToUrl @"api/v1/image"

/*** 首页模块 ***/
// 返利
#define URL_HPRebate @"/api/OperatorAPP/Home"
// 续费报表
#define URL_HPRenew @"/api/OperatorAPP/RenewalsTotalBy30Days"

// 入库列表
#define URL_DistributeLog @"/api/OperatorAPP/GetDistributeLog"
// 入库操作
#define URL_DistributeByScan @"/api/OperatorAPP/DistributeByScan"

/*** 用户统计模块 ***/
// 用户统计模块初始化
#define URL_UserStatisticInit @"/api/GetRptChannelMangeInfo"

// 用户统计列表查询
#define URL_UserStatisticList @"/api/GetUserUseCountSelect"

// 本月返利(html5)
#define HPMonthRebate @"https://open.m-m10010.com/Html/Operator/rebate-detail-more.aspx?holdid="
#define URL_HPMonthRebate(holdid,token) [NSString stringWithFormat:@"%@%zd%@%zd",HPMonthRebate,holdid,@"&token=",token]

// 累积返利(html5)
// 旧：#define HPAccumulateRebate @"http://open.m-m10010.com/Html/Operator/rebate-total.aspx?holdid="
#define HPAccumulateRebate @"https://open.m-m10010.com/Html/operator/rebate-detail.aspx?holdid="
#define URL_HPAccumulateRebate(holdid,token,type) [NSString stringWithFormat:@"%@%zd%@%zd%@%@",HPAccumulateRebate,holdid,@"&token=",token,@"&type=",type]

// 中间cell(html5)
#define HPMidWeb @"https://open.m-m10010.com/html/Operator/Histogram.aspx?holdId="
#define URL_HPMidWeb(holdid,token) [NSString stringWithFormat:@"%@%zd%@%@",HPMidWeb,holdid,@"&token=",token]

// 下方cell(html5)
#define HPBotWeb @"https://open.m-m10010.com/Html/Operator/rebate-detail.aspx?holdid="
#define URL_HPBotWeb(holdid,token) [NSString stringWithFormat:@"%@%zd%@%zd",HPBotWeb,holdid,@"&token=",token]

// 近期续费(html5)
#define HPRecentRebate @"https://open.m-m10010.com/Html/Operator/renewals-statistics.aspx?holdid="
#define URL_HPRecentRebate(holdid,token) [NSString stringWithFormat:@"%@%zd%@%zd",HPRecentRebate,holdid,@"&token=",token]

// 首页更多H5(激活统计)
//#define HPMoreWeb @"https://open.m-m10010.com/Html/Operator/Activated-statistics.aspx?holdid="
#define HPMoreWeb @"https://open.m-m10010.com/Html/Operator/status.html?holdid="
#define URL_HPMoreWeb(holdid,token) [NSString stringWithFormat:@"%@%zd%@%zd",HPMoreWeb,holdid,@"&token=",token]

/*** 左侧菜单模块 ***/
#define URL_LeftMenu @"/api/OperatorAPP/HoldList"

// 卡列表
#define URL_SimList         @"/api/OperatorAPP/SimList"
// 筛选菜单
#define URL_SimParamList    @"/api/OperatorApp/SimParamList"
// 流量卡详细信息
#define URL_SimInfo         @"/api/OperatorAPP/SimInfo"
// 联通卡当月用量
#define URL_UnicomUsage     @"/api/OperatorAPP/CurrentMonthUsage"
// 扫码获取卡详情
#define URL_SimInfoByScan   @"/api/OperatorAPP/SimInfoByScan"


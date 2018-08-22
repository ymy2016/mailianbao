//
//  MGPerModifyNickViewController.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerModifyNickViewController.h"
#import "MGPerCorrectUserInfoRequest.h"
#import "MGUserDefaultUtil.h"
#import "NSString+SCategory.h"
#import "NSString+MGUtil.h"
@interface MGPerModifyNickViewController ()

@property(nonatomic,strong)UITextField *textField;

@end

@implementation MGPerModifyNickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"昵称修改";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configUI];
}

- (void)configUI{

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, AdaptH(20), kScreenW, AdaptH(45))];
    self.textField = textField;
    textField.placeholder = @"请输入昵称";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // 设置textField左占位视图
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AdaptW(10), textField.height)];
    paddingView.backgroundColor = [UIColor clearColor];
    textField.leftView = paddingView;
    [self.view addSubview:textField];
    
    // 注意block的循环引用
    weakSelf(self);
    self.navigationItem.rightBarButtonItem = [[NavButton alloc] initWithBtnStr:@"保存" btnActionBlock:^{
        
        if (![self.textField.text isNotNil]) {
            
            [SVProgressHUD showErrorWithStatus:@"请填写昵称"];
            return;
        }
      #warning 过滤(从左侧起，首次遇见的空格)空格后的字符串，如果length等于0，说明全部是空格
        else if ([self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
            
            [SVProgressHUD showErrorWithStatus:@"昵称不能全为空格"];
            return;
        }
        else if (self.textField.text.length>14){
        
            [SVProgressHUD showErrorWithStatus:@"昵称不能超过14个字符"];
            return;
        }
        
     // 去除字符串中的空格
     self.textField.text = [self.textField.text mdf_stringByTrimingAllWhitespaces];
        
     // 获取登录用户token
      MGPerUserModel *model = [MGUserDefaultUtil getPerUserInfo];
      NSString *iconImage =  [NSString base64StringFromText:model.IconImage];
        
     // 发送修改昵称网络请求
    [[[MGPerCorrectUserInfoRequest alloc] initWithToken:model.token
                                               nickName:self.textField.text
                                              iconImage:iconImage
                                               showTips:@"正在修改"
                                               delegate:weakSelf] start];
        
    }];
}

#pragma mark - 网络相关
// 成功
- (void)requestFinished:(YTKBaseRequest *)request{

    NSLog(@"%@",request.responseJSONObject);
    
    [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
       
        [SVProgressHUD showSuccessWithStatus:@"昵称修改成功"];
        
        // 保存到本地
        MGPerUserModel *model = [MGUserDefaultUtil getPerUserInfo];
        model.WxNickName = self.textField.text;
        [MGUserDefaultUtil savePerUserInfo:model];
        
        if (self.textBlock) {
            self.textBlock(self.textField.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failBlock:^(__kindof NSString *reason) {
        
        [SVProgressHUD showErrorWithStatus:@"昵称修改失败"];
    }];
}

// 失败
- (void)requestFailed:(YTKBaseRequest *)request{

    [SVProgressHUD showErrorWithStatus:@"昵称修改失败"];
}

- (void)dealloc{
 
    NSLog(@"%s",__func__);
}

@end

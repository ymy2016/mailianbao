//
//  MGPerModifyAccountViewController.m
//  MaiLianBao
//
//  Created by 伟华 on 17/1/5.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGPerModifyAccountViewController.h"
#import "MGPerModifyAccountTableViewCell.h"
#import "MGSimMenuDB.h"
#import "MGLoginRootViewController.h"
#import "MGPerModifyNickViewController.h"
#import "MGUserDefaultUtil.h"
#import "UIImageView+WebCache.h"
#import "MGPerCorrectUserInfoRequest.h"
#import "NSString+SCategory.h"
#import "MGMineGetUrlRequest.h"


@interface MGPerModifyAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataList;

// 拍照或者从相册选择后的图片
@property(nonatomic,strong)UIImage *originImg;

@end

static NSString *identy = @"cell";

@implementation MGPerModifyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户修改";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configUI];
}

- (void)configUI{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[MGPerModifyAccountTableViewCell class] forCellReuseIdentifier:identy];
    [self.view addSubview:self.tableView];
    
    UIButton *loginOutBtn = [[UIButton alloc] init];
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptFont(19)];
    [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"tuichubtn"] forState:UIControlStateNormal];
    [loginOutBtn setBackgroundImage:[UIImage imageNamed:@"tuichubtn-press"] forState:UIControlStateHighlighted];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateHighlighted];
    [loginOutBtn addTarget:self action:@selector(loginOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutBtn];
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(-AdaptH(50));
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).mas_offset(AdaptW(20));
        make.right.equalTo(self.view).mas_offset(-AdaptW(20));
    }];

}

// 退出登录
- (void)loginOutAction{

    [MGAlertUtil mg_alertTwoWithTitle:@"您确定要退出？" leftBtnStr:@"取消" rightBtnStr:@"确定" superController:self leftBtnActionBlock:nil rightBtnActionBlock:^{
        
        MGLoginRootViewController *mgLoginVC = [[MGLoginRootViewController alloc] init];
        [mgLoginVC showLoginIndex:0];
        [UIApplication sharedApplication].keyWindow.rootViewController = mgLoginVC;
        
        // 清空NSUserDefault本地数据
        [MGUserDefaultUtil removeUserDefaultInfo];
        
        // 清空MGSimMenuDB信息
        [MGSimMenuDBManager dropTableFromDB];
        
    }];
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)dataList{
    
    if (_dataList == nil) {
        
        _dataList = [NSMutableArray arrayWithObjects:@"头像",@"昵称",nil];
    }
    
    return _dataList;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
// 返回row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MGPerModifyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    NSString *title = self.dataList[indexPath.row];
    
    // cell相关配置
    cell.textLabel.text = title;
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont boldSystemFontOfSize:AdaptFont(15)];
    
    MGPerUserModel *model = [MGUserDefaultUtil getPerUserInfo];
    
    if ([title isEqualToString:@"头像"]) {
       
        [cell.rightImgv sd_setImageWithURL:[NSURL URLWithString:model.IconImage] placeholderImage:[UIImage imageNamed:@"mlb_logo"]];
        
    }
    else if ([title isEqualToString:@"昵称"]){
    
        cell.rightStr = model.WxNickName;
    }
   
    return cell;
}

// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = _dataList[indexPath.row];
    
    if ([title isEqualToString:@"头像"]) {
        
       [MGAlertUtil mg_actionsTwoWithTitle:nil topBtnStr:@"从相册中选择" bottomBtnStr:@"拍照" superController:self topBtnActionBlock:^{
           
           UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
           // 设置文件来源
           pickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
           // 设置代理
           pickerCtrl.delegate = self;
           [self presentViewController:pickerCtrl animated:YES completion:nil];
           
       } bottomBtnActionBlock:^{
           
           // 判断该设备是否有摄像头
           BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear | UIImagePickerControllerCameraDeviceFront];
           if (isCamera == false) {
               
               [SVProgressHUD showWithToast:@"您的设备没有可用摄像头" superView:KeyWindow];
               return;
           }
           
           // 获取摄像头，进行拍照
           UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
           //设置文件来源
           pickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
           //设置代理
           pickerCtrl.delegate = self;
           [self presentViewController:pickerCtrl animated:YES completion:nil];
       }];
    }
    else if ([title isEqualToString:@"昵称"]){
        
        MGPerModifyNickViewController *mgPerModifyNickVC = [[MGPerModifyNickViewController alloc] init];
        mgPerModifyNickVC.textBlock = ^(NSString *str){
            
            // 获取到第0组，第1个cell
            MGPerModifyAccountTableViewCell *cell = getIndexPath(self.tableView, 0, 1);
            cell.rightStr = str;
        
        };
        [self.navigationController pushViewController:mgPerModifyNickVC animated:YES];
    }
}

// 头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return AdaptH(10);
}

// 尾视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return AdaptH(0.1);
}

// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptH(51);
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取得图片
    _originImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 关闭模态
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *encodeImg = [self getEncodedImageWithOriginImage:_originImg];
    // 发送给中间件(将图片转换成url)
    MGMineGetUrlRequest *request = [[MGMineGetUrlRequest alloc] initWithUid:2000 image:encodeImg delegate:nil];
    [SVProgressHUD showWithTips:@"正在修改"];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        // 获取用户登录数据
        MGPerUserModel *model = [MGUserDefaultUtil getPerUserInfo];
        
        // 请求成功
        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        NSDictionary *resultDic = NetParse.result(dic);
        NSString *imgStr = resultDic[@"url"];
        
        // 发送修改头像网络请求
        [[[MGPerCorrectUserInfoRequest alloc] initWithToken:model.token nickName:model.WxNickName iconImage:imgStr showTips:@"正在修改" delegate:self] start];
        
    } failure:^(__kindof YTKBaseRequest *request) {
       
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
    
}

// 获取进行Base64编码后的图片
- (NSString *)getEncodedImageWithOriginImage:(UIImage *)originImage{
    
    // 对图片进行Base64编码
    NSData *nativeData = UIImageJPEGRepresentation(originImage, 0.01f);
    NSString *encodeStr = [nativeData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodeStr;
}


// 优化导航栏显示隐藏效果
- (void)back{
    
    self.navigationController.navigationBarHidden = YES;
    [super back];
}

// 获取对应IndexPath的cell
__kindof UITableViewCell* getIndexPath(UITableView *tableView,int section,int row){
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    MGPerModifyAccountTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - 网络相关
// 成功
- (void)requestFinished:(YTKBaseRequest *)request{
 
    
    [request requestSuccessBlock:^(__kindof NSDictionary *dic) {
        
        [SVProgressHUD showSuccessWithStatus:@"头像修改成功"];
        
        // 获取请求参数
        NSDictionary *argDic = request.requestArgument;
        
        // 获取用户登录数据
        MGPerUserModel *model = [MGUserDefaultUtil getPerUserInfo];
        
        // 保存修改的头像到沙盒
        model.IconImage =  argDic[@"iconImage"];;
        [MGUserDefaultUtil savePerUserInfo:model];
        
        // 获取到第0组，第0个cell
        MGPerModifyAccountTableViewCell *cell = getIndexPath(self.tableView, 0, 0);
        cell.rightImgv.image = _originImg;
        
    } failBlock:^(__kindof NSString *reason) {
        
        [SVProgressHUD showErrorWithStatus:@"头像修改失败"];
    }];
    
}
// 失败
- (void)requestFailed:(YTKBaseRequest *)request{

    [SVProgressHUD showErrorWithStatus:@"头像修改失败"];
}

- (void)dealloc{

    NSLog(@"%s",__func__);
}

@end

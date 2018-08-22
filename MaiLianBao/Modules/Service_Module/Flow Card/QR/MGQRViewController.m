//
//  MGQRViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 16/8/1.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGQRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MGQRView.h"
#import "MGFlowCardInformationViewController.h"
#import "MGInputViewController.h"

@interface MGQRViewController ()
<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL _isShow;
}
@property (nonatomic, strong) MGQRView * qrView;
@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic) QRType type;
/** 记录扫过的二维码 */
@property (nonatomic, strong) NSMutableArray *tempCodeArray;
@property (nonatomic, strong) MGInputViewController *inputVC;
@end

@implementation MGQRViewController

- (void)dealloc
{
    [self stopScan];
}

- (instancetype)initWitType:(QRType)type
{
    if (self = [super init])
    {
        self.type = type;
        _isShow = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    [self configAVCapture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startScan];
}

- (void)configUI
{
    if (self.type == QRTypeInput)
    {
        weakSelf(self);
        self.navigationItem.rightBarButtonItem = [[NavButton alloc] initWithBtnStr:@"入库记录" btnActionBlock:^{
            MGInputViewController *inputVC = [[MGInputViewController alloc] initWithListType:MGScanListType];
            [weakSelf.navigationController pushViewController:inputVC animated:YES];
        }];
    }
    
    _qrView = [[MGQRView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) qrType:self.type];
//    _qrView.delegate = self;
    [self.view addSubview:_qrView];
    
    [self.view addSubview:self.inputVC.view];
    [self.inputVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(0));
    }];
}

- (void)configAVCapture
{
    //获取输入设备(摄像头)
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //根据输入设备创建对象
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    //创建输出对象
    _output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理监听输出对象输出的数据
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //创建对话
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
//    _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode, nil];
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        //        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        _output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode, nil];
        
    }
    else
    {
        UIAlertView *pAlert = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"相机不支持,请去设置->隐私->相机,开启相机支持" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [pAlert show];
        [self stopScan];
    }
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    //    [_session startRunning];
    
    // 设置二维码扫描范围
    CGSize size = CGSizeMake(self.view.width, self.view.height);//self.view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    
    CGRect cropRect = CGRectMake((kScreenW - _qrView.transparentArea.width)/2,
                                 _qrView.transparentAreaTop,
                                 _qrView.transparentArea.width,
                                 _qrView.transparentArea.height);
    
    if (p1 < p2)
    {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        _output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                            cropRect.origin.x/size.width,
                                            cropRect.size.height/fixHeight,
                                            cropRect.size.width/size.width);
    }
    else
    {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        _output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                            (cropRect.origin.x + fixPadding)/fixWidth,
                                            cropRect.size.height/size.height,
                                            cropRect.size.width/fixWidth);
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    NSString * stringValue = nil;
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
//        if ([stringValue isEqualToString:_tempCodeStr]) {
//            NSLog(@"此码刚刚已经扫过!");
//            return;
//        }
//
//        _tempCodeStr = stringValue;
        
        //        if ([_delegate respondsToSelector:@selector(QRScanWithCode:)]) {
        //            [_delegate QRScanWithCode:stringValue];
        //        }
        
        NSLog(@"扫描信息:%@",stringValue);
        if (self.type == QRTypeScan)
        {
            //停止扫描
            [self stopScan];
            
            MGFlowCardInformationViewController *viewController = [[MGFlowCardInformationViewController alloc] initWithCode:[stringValue integerValue] CardType:0 GetType:SimGetWithScanType];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (self.type == QRTypeInput)
        {
            if ([self.tempCodeArray containsObject:stringValue])
            {
                NSInteger idx = [self.tempCodeArray indexOfObject:stringValue];
                [self.view makeToast:[NSString stringWithFormat:@"序号%@为该码扫描结果, 请不要重复录入", @(self.tempCodeArray.count - idx)]];
                return;
            }
            else
            {
                [self.tempCodeArray insertObject:stringValue atIndex:0];
            }
            
            [self.inputVC setScanResult:stringValue];
            
            if (!_isShow)
            {
                [UIView animateWithDuration:0.35 animations:^{
                    _isShow = YES;
                    [self.inputVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.equalTo(@(kScreenH - self.qrView.transparentAreaTop - self.qrView.transparentArea.height - AdaptH(46)));
                    }];
                    [self.view layoutIfNeeded];
                }];
            }
        }
    }
}

- (void)startScan
{
    [_qrView runLink];
    [_session startRunning];
}

- (void)stopScan
{
    [_session stopRunning];
    [_qrView removeLink];
}

#pragma mark - 懒加载
- (MGInputViewController *)inputVC
{
    if (!_inputVC) {
        _inputVC = [[MGInputViewController alloc] init];
        [self addChildViewController:_inputVC];
    }
    return _inputVC;
}

- (NSMutableArray *)tempCodeArray
{
    if (!_tempCodeArray)
    {
        _tempCodeArray = [NSMutableArray array];
    }
    return _tempCodeArray;
}
@end

//
//  MGQRView.m
//  CarTools
//
//  Created by 苏晗 on 16/5/20.
//  Copyright © 2016年 MapGoo. All rights reserved.
//

#import "MGQRView.h"

#define MarginX 5
#define MarginY 5
#define LineLength 15

@interface MGQRView ()
{
    UIImageView *qrLine;
    CGFloat qrLineY;
    QRType _qrType;
}
@property (nonatomic, strong) CADisplayLink * link;
@end

@implementation MGQRView


- (instancetype)initWithFrame:(CGRect)frame qrType:(QRType)qrType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _qrType = qrType;
        
        _transparentArea = CGSizeMake(AdaptW(220), AdaptW(220));

        if (qrType == QRTypeScan)
        {
            _transparentAreaTop = kTopSubHeight + (kScreenH - kTopSubHeight - self.transparentArea.height) * 0.25;
        }
        else if (qrType == QRTypeInput)
        {
            _transparentAreaTop = kTopSubHeight + AdaptH(45);
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!qrLine)
    {
        [self initQRLine];
        
        [self initView];
        
        CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(scan)];
        self.link = link;
        
        [self runLink];
    }
    
}

- (void)setTransparentAreaTop:(CGFloat)transparentAreaTop
{
    _transparentAreaTop = transparentAreaTop;
}

- (void)runLink
{
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLink
{
    //    [self.link invalidate];
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    //    self.link = nil;
}

- (void)initQRLine
{
//    UIImage * qrLineImage = [UIImage imageNamed:@""];
    qrLine  = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - (self.transparentArea.width + 20))/2, self.transparentAreaTop, self.transparentArea.width + 20, 2)];
    qrLine.backgroundColor = [UIColor whiteColor];
    qrLine.contentMode = UIViewContentModeCenter;
//    qrLine.image = qrLineImage;
    qrLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:qrLine];
    qrLineY = qrLine.frame.origin.y;
}

- (void)initView
{
//    UILabel * titleLabel = [UILabel initWithFrame:CGRectMake((self.width - self.transparentArea.width)/2, self.transparentAreaTop + self.transparentArea.height + 5, self.transparentArea.width, 25)
//                                             Font:mCommonFont(12)
//                                        TextColor:[UIColor whiteColor]
//                                        Alignment:NSTextAlignmentCenter
//                                            Lines:1];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [self addSubview:subTitleLabel];
    
    UIImage *image = [UIImage imageNamed:_qrType == QRTypeScan ? @"qr_background" : @"scan_storage"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    subTitleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.font = [UIFont systemFontOfSize:AdaptFont(14.f)];
    subTitleLabel.font = [UIFont systemFontOfSize:AdaptFont(13.f)];
    
    titleLabel.text = _qrType == QRTypeScan ? @"将二维码放入框内,即可自动扫描" : @"扫描车载设备的二维码,ICCID和IMEI匹配成功后自动完成分配入库";
    subTitleLabel.text = _qrType == QRTypeScan ? @"点击“扫码输入”,对着卡的条形码扫一扫" : @"示意图";
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_qrType == QRTypeScan)
    {
        titleLabel.frame = CGRectMake(AdaptW(10), kTopSubHeight + AdaptW(10), self.width - AdaptW(10) *2, self.transparentAreaTop - AdaptH(20) - kTopSubHeight);
        
        imageView.frame = CGRectMake((self.width - imageView.image.size.width)/2, self.transparentAreaTop + self.transparentArea.height + AdaptH(20), imageView.image.size.width, imageView.image.size.height);
        
        subTitleLabel.frame = CGRectMake(titleLabel.left, imageView.bottom + AdaptH(5), titleLabel.width, AdaptH(20));
    }
    else if (_qrType == QRTypeInput)
    {
        titleLabel.frame = CGRectMake(AdaptW(10), self.transparentAreaTop + self.transparentArea.height + AdaptH(45), self.width - AdaptW(10) *2, AdaptH(35));
        
        imageView.frame = CGRectMake((self.width - imageView.image.size.width)/2, titleLabel.bottom + AdaptH(10), imageView.image.size.width, imageView.image.size.height);
        
        subTitleLabel.frame = CGRectMake(titleLabel.left, imageView.bottom + AdaptH(10), titleLabel.width, AdaptH(20));
    }
}

//扫描效果
- (void)scan
{
    CGRect rect = qrLine.frame;
    rect.origin.y = qrLineY;
    qrLine.frame = rect;
    
    CGFloat maxBorder = self.transparentAreaTop + self.transparentArea.height - 4;
    if (qrLineY > maxBorder)
    {
        qrLineY = self.transparentAreaTop;
    }
    qrLineY++;
}

//- (void)cancelBtnAction:(id)sender
//{
//    if ([_delegate respondsToSelector:@selector(scanDismiss)])
//    {
//        [_delegate scanDismiss];
//    }
//}

- (void)drawRect:(CGRect)rect {
    
    //整个二维码扫描界面的颜色
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      self.transparentAreaTop,
                                      self.transparentArea.width,self.transparentArea.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect
{
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 255 /255.0, 255/255.0, 255/255.0, 1);//白色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+MarginX, rect.origin.y + MarginX),
        CGPointMake(rect.origin.x+MarginX, rect.origin.y + LineLength + MarginX)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x + MarginX - 1, rect.origin.y +MarginY),CGPointMake(rect.origin.x + LineLength + MarginX + 1, rect.origin.y+MarginY)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ MarginX, rect.origin.y + rect.size.height - LineLength - MarginY),CGPointMake(rect.origin.x +MarginX,rect.origin.y + rect.size.height - MarginY)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x+MarginX - 1, rect.origin.y + rect.size.height - MarginY) ,CGPointMake(rect.origin.x+MarginX +LineLength + 1, rect.origin.y + rect.size.height - MarginY)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - LineLength - MarginX, rect.origin.y+MarginY),CGPointMake(rect.origin.x + rect.size.width - MarginX,rect.origin.y +MarginY )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-MarginX, rect.origin.y + MarginY - 1),CGPointMake(rect.origin.x + rect.size.width-MarginX,rect.origin.y + LineLength +MarginY + 1)};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    //右下角
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - MarginX , rect.origin.y+rect.size.height - LineLength - MarginY),CGPointMake(rect.origin.x-MarginX + rect.size.width,rect.origin.y + rect.size.height - MarginY)};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - LineLength - MarginX - 1, rect.origin.y + rect.size.height-MarginY),CGPointMake(rect.origin.x + rect.size.width - MarginX + 1,rect.origin.y + rect.size.height - MarginY )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}


@end

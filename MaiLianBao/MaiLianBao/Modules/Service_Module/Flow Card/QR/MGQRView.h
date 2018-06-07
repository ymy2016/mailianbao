//
//  MGQRView.h
//  CarTools
//
//  Created by 苏晗 on 16/5/20.
//  Copyright © 2016年 MapGoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRConfig.h"

//@protocol QRViewDelegate;

@interface MGQRView : UIView

- (instancetype)initWithFrame:(CGRect)frame qrType:(QRType)qrType;

//@property (nonatomic, weak) id<QRViewDelegate> delegate;
/**
 *  透明的区域
 */
@property (nonatomic, assign) CGSize transparentArea;
/** 透明区域的位置Top */
@property (nonatomic, assign) CGFloat transparentAreaTop;

- (void)runLink;
- (void)removeLink;

@end


//@protocol QRViewDelegate <NSObject>
//
//- (void)scanDismiss;
//
//@end

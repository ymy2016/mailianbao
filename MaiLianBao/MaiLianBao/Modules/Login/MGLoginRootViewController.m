//
//  MGLoginRootViewController.m
//  MaiLianBao
//
//  Created by 苏晗 on 2017/1/3.
//  Copyright © 2017年 Twh. All rights reserved.
//

#import "MGLoginRootViewController.h"
#import "MGSerLoginViewController.h"
#import "MGPerLoginViewController.h"
#import "UIView+BSLine.h"

@interface MGLoginRootViewController ()
{
    NSInteger _loginIdx;
}
@property (nonatomic, strong) MGSerLoginViewController *serLoginViewController;
@property (nonatomic, strong) MGPerLoginViewController *perLoginViewController;
@end

@implementation MGLoginRootViewController

- (void)showLoginIndex:(NSInteger)index
{
    _loginIdx = index;
    
    [self.view insertSubview:self.serLoginViewController.view atIndex:index];
    [self.view insertSubview:self.perLoginViewController.view atIndex:index == 0 ? (index + 1) : (index - 1)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.serLoginViewController = [[MGSerLoginViewController alloc] init];
    [self addChildViewController:self.serLoginViewController];
    
    self.perLoginViewController = [[MGPerLoginViewController alloc] init];
    [self addChildViewController:self.perLoginViewController];

    [self showLoginIndex:0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:_loginIdx == 0 ? @"切换到运营商入口" : @"切换到个人用户入口" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"login_switch"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, AdaptW(-10), kTabbarSafeBottomMargin, 0)];
    [button addTarget:self action:@selector(switchBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, kTabbarSafeBottomMargin, 0);
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(AdaptH(44.f) + kTabbarSafeBottomMargin);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [button addTopLineWithLeftPading:0 andRightPading:0];
}

- (void)switchBtnSelected:(UIButton *)button
{
    button.selected = !button.selected;
    
    [button setTitle:button.selected ? @"切换到个人用户入口" : @"切换到运营商入口" forState:UIControlStateNormal];
    
    UIViewAnimationOptions option =  button.selected ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    
    void (^update)(void) = ^ {
        
    };
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:option
                    animations:^ {
                         [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                    }
                    completion:^ (BOOL finished){
                        
                        update();
                        
                    }];
}

- (void)dealloc
{

}

@end

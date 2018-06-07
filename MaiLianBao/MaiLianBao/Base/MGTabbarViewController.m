//
//  MGTabbarViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGTabbarViewController.h"
#import "MGNavigationController.h"
#import "MGHomePageViewController.h"
#import "MGFlowCardViewController.h"
#import "MGUserStatisticViewController.h"
#import "MGMineViewController.h"
#import "MGTabbarModel.h"

@interface MGTabbarViewController ()<UINavigationControllerDelegate,UINavigationBarDelegate>

// tabbarItem数据源
@property(nonatomic,strong)NSMutableArray *dataList;

@end

@implementation MGTabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addAllChildrenVC];
}

- (NSMutableArray *)dataList
{
    if (_dataList == nil)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MGTabData" ofType:@"plist"];
        _dataList = [MGTabbarModel mj_objectArrayWithFile:plistPath];
    }

    return _dataList;
}

// 添加所有子控制器
- (void)addAllChildrenVC
{
    MGHomePageViewController *homePageVC = [[MGHomePageViewController alloc] init];
    
    MGFlowCardViewController *flowCardVC = [[MGFlowCardViewController alloc] init];
    
    MGUserStatisticViewController *userStatisticVC = [[MGUserStatisticViewController alloc] init];
    
    MGMineViewController *mineVC = [[MGMineViewController alloc] init];
    
    NSArray *subVCArray = @[homePageVC,flowCardVC,userStatisticVC,mineVC];
    
    [subVCArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MGTabbarModel *model = self.dataList[idx];
        [self addChildViewController:subVCArray[idx] title:model.title imageName:model.imageNormal selectedImageName:model.imageHighlight];
        
    }];
    
    // 设置item字体大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:AdaptFont(11)]
                                                        } forState:UIControlStateNormal];
    
    // 设置选中的item下方文字颜色、字体大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : [UIColor orangeColor],
                                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:AdaptFont(11)]
                                                        }
                                             forState:UIControlStateSelected];
    
    // 设置默认选中tabbar上第0个按钮(不用设置，默认也是选中第一个)
    self.selectedIndex = 0;
}
- (void)addChildViewController:(UIViewController *)childVC

                         title:(NSString *)title
                     imageName:(NSString *)imageName
             selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVC.tabBarItem.title = title;
    
    // 设置默认图标
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    // 用原图 不渲染
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置选中图标
    childVC.tabBarItem.selectedImage = selectedImage;
    
    // 添加导航控制器
    MGNavigationController * nav = [[MGNavigationController alloc] initWithRootViewController:childVC];
    nav.delegate = self;
    
    // “我的”模块，隐藏导航栏
    if ([childVC isKindOfClass:[MGMineViewController class]])
    {
        childVC.navigationController.navigationBarHidden = YES;
    }
    
    // 添加为tabbar控制器的子控制器
    [self addChildViewController:nav];
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end

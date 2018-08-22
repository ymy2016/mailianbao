//
//  MGTabbarViewController.m
//  MaiLianBao
//
//  Created by MapGoo on 16/7/18.
//  Copyright © 2016年 Twh. All rights reserved.
//

#import "MGSerTabbarViewController.h"
#import "MGNavigationController.h"
#import "MGHomePageViewController.h"
#import "MGFlowCardViewController.h"
#import "MGUserStatisticViewController.h"
#import "MGMineViewController.h"
#import "MGTabbarModel.h"
#import "MGNewUserStatisticViewController.h"

@interface MGSerTabbarViewController ()<UINavigationControllerDelegate,UINavigationBarDelegate, CYLTabBarControllerDelegate, UITabBarControllerDelegate>

// tabbarItem数据源
@property(nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,strong)MGUserModel *userModel;

@end

@implementation MGSerTabbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self addAllChildrenVC];
    
    self.delegate = self;
    
    self.userModel = [MGUserDefaultUtil getUserInfo];
    
    self.tabBarItemsAttributes = [self rootTabBarItemsAttributes];
    self.viewControllers = [self rootVCs];
    [self customizeTabBarAppearance:self];
}

- (NSArray *)rootVCs
{
    MGHomePageViewController *homePageVC = [[MGHomePageViewController alloc] init];
    MGNavigationController *homeNav = [[MGNavigationController alloc] initWithRootViewController:homePageVC];
    
    MGFlowCardViewController *flowCardVC = [[MGFlowCardViewController alloc] init];
    MGNavigationController *flowCardNav = [[MGNavigationController alloc] initWithRootViewController:flowCardVC];
    
    // MGUserStatisticViewController *userStatisticVC = [[MGUserStatisticViewController alloc] init];
    MGNewUserStatisticViewController *userStatisticVC = [[MGNewUserStatisticViewController alloc] init];
    MGNavigationController *userStatisticNav = [[MGNavigationController alloc] initWithRootViewController:userStatisticVC];
    
    MGMineViewController *mineVC = [[MGMineViewController alloc] init];
    MGNavigationController *mineNav = [[MGNavigationController alloc] initWithRootViewController:mineVC];

    NSArray *vcs = nil;
    if (self.userModel.isHomeAuth == 1) {
        vcs = @[homeNav, flowCardNav, userStatisticNav, mineNav];
    }
    else{
        vcs = @[flowCardNav, userStatisticNav, mineNav];
    }
    return vcs;
}

- (NSArray *)rootTabBarItemsAttributes
{
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"01",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"01-press", /* NSString and UIImage are supported*/
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"流量卡",
                                                  CYLTabBarItemImage : @"02",
                                                  CYLTabBarItemSelectedImage : @"02-press",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"用户统计",
                                                 CYLTabBarItemImage : @"03",
                                                 CYLTabBarItemSelectedImage : @"03-press",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"04",
                                                  CYLTabBarItemSelectedImage : @"04-press"
                                                  };
    
    NSArray *tabBarItemsAttributes = nil;
    if (self.userModel.isHomeAuth == 1) {
        tabBarItemsAttributes = @[
                                  firstTabBarItemsAttributes,
                                  secondTabBarItemsAttributes,
                                  thirdTabBarItemsAttributes,
                                  fourthTabBarItemsAttributes
                                  ];
    }
    else{
        tabBarItemsAttributes = @[
                                  secondTabBarItemsAttributes,
                                  thirdTabBarItemsAttributes,
                                  fourthTabBarItemsAttributes
                                  ];
    }
    
    return tabBarItemsAttributes;
}

- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController
{
    // 自定义 TabBar 高度
    //    tabBarController.tabBarHeight = kTabBarHeight;
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];
    
    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    //     UITabBar *tabBarAppearance = [UITabBar appearance];
    //     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tab_bar"]];
    
    // 去除 TabBar 自带的顶部阴影
    // [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    
    return YES;
}

/*
- (NSMutableArray *)dataList
{
    if (_dataList == nil)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MGSerTabData" ofType:@"plist"];
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
*/

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end

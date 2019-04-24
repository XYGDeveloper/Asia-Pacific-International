//
//  YJTabBarController.m
//  YJOTC
//
//  Created by 周勇 on 2017/12/22.
//  Copyright © 2017年 前海数交平台运营. All rights reserved.
//

#import "YJTabBarController.h"
#import "YJBaseViewController.h"
#import "YJBaseNavController.h"
#import "YJMainViewController.h"
#import "YJNewsViewController.h"
#import "YJMineViewController.h"
#import "FXBlurView.h"
#import "YJDiscoverViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YWCircleViewController.h"
#import "YTNewsViewController.h"
#import "YTMainViewController.h"
#import "YTMineViewController.h"
#import "YTDealViewController.h"
#import "MeViewController.h"
#import "IndexViewController.h"
#import "QuotationViewController.h"
#import "NewViewController.h"
#define kAnimationTime 0.25

@interface YJTabBarController ()<UITabBarControllerDelegate>

@property(nonatomic,strong)MeViewController *mineVC;
@property(nonatomic,strong)YJMainViewController *mainVC;
@property(nonatomic,strong)NewViewController *newsVC;
@property(nonatomic,strong)YJDiscoverViewController *disVC;
@property(nonatomic,strong)YJDealViewController *dealVC;
@property(nonatomic,strong)YWCircleViewController *cirVC;
@property(nonatomic,strong)QuotationViewController *nnewVC;
@property(nonatomic,strong)IndexViewController *nmainVC;
@property(nonatomic,strong)YTMineViewController *nMineVC;
@property (nonatomic, strong) UIViewController *tradeVC;



@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,strong)NSArray *selctedImagesArray;
@property(nonatomic,strong)NSArray *titleArray;


@end

@implementation YJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self configureTabbarVC];
    [self addChildViewControllers];
    [self.tabBar setBarTintColor:kColorFromStr(@"#17151F")];
    self.tabBar.translucent = NO;
    self.delegate = self;
    [self registerNotifications];
    
//    [self handleUnreadMeg];

}

-(void)configureTabbarVC
{
//    _tabbar = [[YJTabbar alloc] init];
//    [_tabbar.centerBtn addTarget:self action:@selector(midButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    [self setValue:_tabbar forKeyPath:@"tabBar"];
    self.delegate = self;
    
    // 背景图颜色
    [self.tabBar setBarTintColor:kColorFromStr(@"#17151F")];
//    self.tabBar.backgroundColor = [UIColor colorWithRed:0.13 green:0.14 blue:0.21 alpha:1.00];
    [self addChildViewControllers];
    //阴影
    [self dropShadowWithOffset:CGSizeMake(0, -3) radius:3 color:[UIColor grayColor] opacity:0.3];
    //去掉黑线
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
}

-(void)addChildViewControllers
{
//    YJBaseNavController *nav0 = [[YJBaseNavController alloc] initWithRootViewController:self.mainVC];
    YJBaseNavController *nav0 = [[YJBaseNavController alloc] initWithRootViewController:self.nmainVC];

    
    
//    YJBaseNavController *nav1 = [[YJBaseNavController alloc] initWithRootViewController:self.newsVC];
    YJBaseNavController *nav1 = [[YJBaseNavController alloc] initWithRootViewController:self.nnewVC];

    
    
//    YJBaseNavController *nav2 = [[YJBaseNavController alloc] initWithRootViewController:self.dealVC];
    YJBaseNavController *nav2 = [[YJBaseNavController alloc] initWithRootViewController:self.tradeVC];

    
    
//    YJBaseNavController *nav3 = [[YJBaseNavController alloc] initWithRootViewController:self.disVC];
    YJBaseNavController *nav3 = [[YJBaseNavController alloc] initWithRootViewController:self.newsVC];

    
//    YJBaseNavController *nav4 = [[YJBaseNavController alloc] initWithRootViewController:self.mineVC];
    YJBaseNavController *nav4 = [[YJBaseNavController alloc] initWithRootViewController:self.mineVC];

    
    /**  紫色  */
    UIColor *color = [UIColor colorWithRed:0.54 green:0.47 blue:0.91 alpha:1.00];
    
    
    [nav0.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [nav1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [nav2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [nav3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    [nav4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];

//    self.viewControllers = @[nav2,nav3,nav0,nav1,nav4];
    self.viewControllers = @[nav0,nav1,nav2,nav3,nav4];
}



- (void)setUpOneChildViewController:(UIViewController *)vc image:(NSString *)image selectImage:(NSString *)selectImage
{
    //描述对应的按钮的内容
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    // Creating shadow path for better performance
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.tabBar.clipsToBounds = NO;
}





#pragma mark - 环信
-(void)userDidLoginOut
{
    //环信
//    if ([[EMClient sharedClient] isLoggedIn]) {
//        [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
//            if (aError) {
//                kLOG(@"%@",aError);
//            }else{
//                kLOG(@"环信登出成功");
//                [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageCountKey object:@(0)];
//            }
//        }];
//    }
    //极光
    //    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    //        kLOG(@"极光别名删除成功");
    //    } seq:0];
}


-(void)userDidLogin
{
//    YJUserInfo *model = kUserInfo;
//    NSString *userName = [NSString stringWithFormat:@"%zd",model.uid];
//    NSString *pwd = model.hx_password;
//    [[EMClient sharedClient] loginWithUsername:userName password:pwd completion:^(NSString *aUsername, EMError *aError) {
//        if (!aError) {
//            kLOG(@"用户<=%@=>即时通讯登录成功",aUsername);
//            BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//            if (isAutoLogin == NO) {
//                //设置是否自动登录
//                [[EMClient sharedClient].options setIsAutoLogin:YES];
//            }
//
//            EMError *error = [[EMClient sharedClient] bindDeviceToken:[kUserDefaults objectForKey:kDeviceTokenKey]];
//            if (error) {
//                kLOG(@"%@",error.errorDescription);
//            }
//            [[EMClient sharedClient] setApnsNickname:kUserInfo.nickName];
//            [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
//            EMPushOptions *options = [[EMClient sharedClient] pushOptions];
//            options.displayName = kUserInfo.nickName;
//            options.displayStyle = EMPushDisplayStyleMessageSummary; // 显示消息内容
//            //            options.displayStyle = EMPushDisplayStyleSimpleBanner; // 显示“您有一条新消息”
//
//            dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//
//                EMError *optionError = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
//                if(!optionError) {
//                    // 成功
//                    kLOG(@"环信配置更新到服务器");
//                }else {
//                    // 失败
//                }
//            });
//        }else{
//            kLOG(@"====%@",aError);
//        }
//    }];
    
    //    if (![Utilities isExpired]) {
    //        NSString *alias = [NSString stringWithFormat:@"%zd",kUserInfo.uid];
    //        [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    //            kLOG(@"极光别名设置成功");
    //        } seq:0];
    //    }
}

#pragma mark - 处理未读信息
-(void)messagesDidReceive:(NSArray *)aMessages
{
//    kLOG(@"新消息来了");
//    [self handleUnreadMeg];
//
//    for (EMMessage*message in aMessages) {
//        dispatch_sync_on_main_queue(^{
//            UIApplicationState state =[[UIApplication sharedApplication] applicationState];
//            switch (state) {
//                    //前台运行
//                case UIApplicationStateActive:
//                    [self showPushNotificationMessage:message];
//                    break;
//                    //待激活状态
//                case UIApplicationStateInactive:
//                    break;
//                    //后台状态
//                case UIApplicationStateBackground:
//                    [self showPushNotificationMessage:message];
//                    break;
//                default:
//                    break;
//            }
//
//        });
//    }
    
}
-(void)messagesDidRead:(NSArray *)aMessages
{
    kLOG(@"消息已读");
    //    [self handleUnreadMeg];
}




-(YJMainViewController *)mainVC
{
    if (_mainVC == nil) {
        
        _mainVC = [[YJMainViewController alloc]init];
        [self setUpOneChildViewController:_mainVC image:self.imagesArray.firstObject selectImage:self.selctedImagesArray.firstObject];
        _mainVC.title = LocalizedString(@"main");

    }
    return _mainVC;
}

-(IndexViewController *)nmainVC
{
    if (_nmainVC == nil) {
        _nmainVC = [[IndexViewController alloc] init];
        [self setUpOneChildViewController:_nmainVC image:self.imagesArray[0] selectImage:self.selctedImagesArray[0]];
        _nmainVC.title = LocalizedString(@"main");
    }
    return _nmainVC;
    
}


-(MeViewController *)mineVC
{
    if (_mineVC == nil) {
        _mineVC = [MeViewController new];
        [self setUpOneChildViewController:_mineVC image:self.imagesArray.lastObject  selectImage:self.selctedImagesArray.lastObject];
        _mineVC.title = LocalizedString(@"account");
    }
    return _mineVC;
}
//-(YTMineViewController *)nMineVC
//{
//    if (_nMineVC == nil) {
//        _nMineVC = [[YTMineViewController alloc] initWithWebViewType:BaseWebVCWebViewTypeTabbar title:@"" urlString:[NSString stringWithFormat:@"%@/Mobile/AccountManage/account",kBasePath]];
//        [self setUpOneChildViewController:_nMineVC image:self.imagesArray[4] selectImage:self.selctedImagesArray[4]];
//        _nMineVC.title = LocalizedString(@"account");
//    }
//    return _nMineVC;
//}



-(NewViewController *)newsVC
{
    if (_newsVC == nil) {
        _newsVC = [[NewViewController alloc] init];
        [self setUpOneChildViewController:_newsVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
        _newsVC.title = LocalizedString(@"discover");
    }
    return _newsVC;
}
-(QuotationViewController *)nnewVC
{
    if (_nnewVC == nil) {
        _nnewVC = [[QuotationViewController alloc] init];
        [self setUpOneChildViewController:_nnewVC image:self.imagesArray[1] selectImage:self.selctedImagesArray[1]];
        _nnewVC.title = LocalizedString(@"hangqing");
    }
    return _nnewVC;
}





//-(YJDiscoverViewController *)disVC
//{
//    if (_disVC == nil) {
//        _disVC = [YJDiscoverViewController new];
//        _disVC.title = LocalizedString(@"discover");
//        [self setUpOneChildViewController:_disVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
//    }
//    return _disVC;
//}
//-(YWCircleViewController *)cirVC
//{
//    if (_cirVC == nil) {
//        _cirVC = [YWCircleViewController new];
//        _cirVC.title = LocalizedString(@"discover");
//        [self setUpOneChildViewController:_cirVC image:self.imagesArray[3] selectImage:self.selctedImagesArray[3]];
//    }
//    return _cirVC;
//}


-(YJDealViewController *)dealVC
{
    if (_dealVC == nil) {
        
        _dealVC = [YJDealViewController new];
        _dealVC.title = LocalizedString(@"trade");
        [self setUpOneChildViewController:_dealVC image:self.imagesArray[2] selectImage:self.selctedImagesArray[2]];
    }
    return _dealVC;
}



- (UIViewController *)tradeVC {
    if (!_tradeVC) {
        _tradeVC = [UIStoryboard storyboardWithName:@"Trade" bundle:nil].instantiateInitialViewController;
        [self setUpOneChildViewController:_tradeVC image:self.imagesArray[2] selectImage:self.selctedImagesArray[2]];
        _tradeVC.title = LocalizedString(@"k_TradeViewController_title");
    }
    return _tradeVC;
}


-(NSArray *)imagesArray
{
    if (_imagesArray == nil) {
        _imagesArray = @[@"tab_icon2",@"tab_icon3",@"tab_icon5",@"tab_icon7",@"tab_icon9"];

    }
    return _imagesArray;
}
-(NSArray *)selctedImagesArray
{
    if (_selctedImagesArray == nil) {
//        _selctedImagesArray = @[@"home_kuai",@"faxian_kuai",@"zxun_kuai",@"user_kuai"];
        _selctedImagesArray = @[@"tab_icon1",@"tab_icon4",@"tab_icon6",@"tab_icon8",@"tab_icon10"];

    }
    return _selctedImagesArray;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.selectedIndex != index) {
        [self playSound];//点击时音效
        [self animationWithIndex:index];
    }
}
-(void) playSound{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"like" ofType:@"caf"];
    SystemSoundID soundID;
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&soundID);
    AudioServicesPlaySystemSound(soundID);
}
// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.2];
    [[tabbarbuttonArray[index] layer]
     addAnimation:pulse forKey:nil];
    self.selectedIndex = index;
}

-(void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginOut) name:kLoginOutKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kLoginSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kTokenExpiredKey object:nil];
}
@end

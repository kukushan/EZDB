//
//  EZDBAppDelegate.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-14.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "EZDBAppDelegate.h"
#import "TabBarViewController.h"
#import "UserGuideViewController.h"
#import "AssetViewController.h"
#import "FinacialViewController.h"
#import "LoginViewController.h"
#import "Reachability.h"


//#define CHANGE_VC 1
typedef enum : NSUInteger {
    kUpdatedVersion = 11,
    kForcedUpdVersion,
    kNetReachable,
} kAlertViewType;

@implementation EZDBAppDelegate
{
    UIImageView *splashView;
    CGFloat currentVersion;
    CGFloat appVersion;
    CGFloat servVersion;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    NSLog(@"URL query: %@", annotation);

    return NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    id url=[launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    NSLog(@"url:%@",url);
    
   
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Override point for customization after application launch.
        /**
         检查网络
         */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
        Reachability *hostReach = [Reachability reachabilityWithHostName:@"http://22.188.12.106/apps/appdownload/1641"];//可以以多种形式初始化
        [hostReach startNotifier];  //开始监听,会启动一个run loop
        [self updateInterfaceWithReachability: hostReach];
        [self loadCtrl];
        
        return YES;
        

}

- (void)loadCtrl
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"第一次启动");
        //如果是第一次启动,使用UserGuideViewController (用户引导页面) 作为根视图
        UserGuideViewController *userGuideViewController = [[UserGuideViewController alloc]init];
        self.window.rootViewController = userGuideViewController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        [self loadingAnimation];
        
    }else{
        NSLog(@"不是第一次启动");
        //如果不是第一次启动,使用RootViewController作为根视图
#ifdef CHANGE_VC
        DEFINE_CONTROLLERS(RootViewController, nav);
        self.window.rootViewController = nav;
#else
        _tabBarCtl = [[TabBarViewController alloc]init];
        _tabBarCtl.viewControllers = [_tabBarCtl getViewcontrollers];
        self.window.rootViewController = _tabBarCtl;
        //隐藏系统的tabar view
        for (UIView * v in _tabBarCtl.view.subviews) {

            if ([v isKindOfClass:[UITabBar class]]) {
                v.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 49);
            }else{
                v.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }
        }

#endif
        self.window.userInteractionEnabled = NO;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        [self loadingAnimation];
    }
}
- (void)reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

- (void)updateInterfaceWithReachability: (Reachability*) curReach
{
    NSString * connectionKind = nil;
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            connectionKind = @"当前没有网络链接\n请检查你的网络设置";
            _isConnected = NO;
            break;
            
        case ReachableViaWiFi:
            connectionKind = @"当前使用的网络类型是WIFI";
            _isConnected = YES;
            break;
            
        case ReachableViaWWAN:
            connectionKind = @"您现在使用的是2G/3G网络\n可能会产生流量费用";
            _isConnected = YES;
            break;
            
        default:
            break;
    }
    if (status == NotReachable) {  //没有连接到网络就弹出提示框
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:connectionKind
                                                       delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = kNetReachable;
//        [alert show];
    }
}
//启动图片
- (void)loadingAnimation
{
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    
    if (IS_IPHONE4) {
        splashView.image = [UIImage imageNamed:@"Default"];
        splashView.userInteractionEnabled  = NO;
        
    }else if (IS_IPHONE5) {
        splashView.image = [UIImage imageNamed:@"Default-568h@2x"];
        splashView.userInteractionEnabled  = NO;
    }
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    //开始动画
    [UIView beginAnimations:@"splashView" context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    [UIView commitAnimations];
    
}

#pragma mark -
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"_______%@",response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *jsonDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",jsonDic);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.appUrl = jsonDic[@"appurl"];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"手机版本:%@",appCurVersion);
    NSArray *appArry = [appCurVersion componentsSeparatedByString:@"."];
    NSLog(@"app数组:%@",appArry);
    
    NSLog(@"服务器版本:%@",[jsonDic objectForKey:@"version"]);
    NSArray *servArry = [[jsonDic objectForKey:@"version"] componentsSeparatedByString:@"."];

    NSLog(@"ser数组:%@",servArry);
    
    if (servArry.count==3){
        servVersion=[[NSString stringWithFormat:@"%@%@%@",servArry[0],servArry[1],servArry[2]] floatValue];
        NSLog(@"%d",[[jsonDic objectForKey:@"need_update"] intValue]);
        if ([[jsonDic objectForKey:@"need_update"] intValue]==0){
            if (appArry.count==2) {
                appVersion=[[NSString stringWithFormat:@"%@%@",appArry[0],appArry[1]] floatValue]*100;
            }else if (appArry.count==3){
                appVersion=[[NSString stringWithFormat:@"%@%@%@",appArry[0],appArry[1],appArry[2]] floatValue]*10;
            }
            //非强制更新
            if ([[NSString stringWithFormat:@"%@%@%@",servArry[0],servArry[1],servArry[2]] floatValue]<1000) {
                servVersion = 10*([[NSString stringWithFormat:@"%@%@%@",servArry[0],servArry[1],servArry[2]] floatValue]);
            }
            NSLog(@"appVersion==%f",appVersion);
            NSLog(@"servVersion==%f",servVersion);
            if (appVersion<servVersion){
                self.isExisted = YES;
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您现在的版本不是最新版本, 是否下载最新版本？" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"前往下载", nil];
                alertView.tag = kUpdatedVersion;
                [alertView show];
                
            }else if (appVersion==servVersion){
                self.isExisted = NO;
            }else{
                self.isExisted = YES;
            }
            
        }else if ([[jsonDic objectForKey:@"need_update"] intValue]==1){
            //强制更新
            self.isExisted = YES;
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您现在的版本不是最新版本, 请下载最新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
            alertView.tag = kForcedUpdVersion;
            [alertView show];
        }
    }
}

#pragma mark -
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    //退出程序
    if ([animationID compare:@"exitApplication"] == 0){
        exit(0);
        //splashView动画
    }else if ([animationID compare:@"splashView"] == 0){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kFindVersion] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:120];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setValue:kAppBopKey forHTTPHeaderField:@"clentid"];
        [request setValue:@"" forHTTPHeaderField:@"userid"];
        [request setValue:@"1" forHTTPHeaderField:@"chnflg"];
        [request setValue:[MSUtil getyyyymmdd]forHTTPHeaderField:@"trandt"];
        [request setValue:[MSUtil gethhmmss] forHTTPHeaderField:@"trantm"];
        [request setValue:@"" forHTTPHeaderField:@"cookie"];
        [request setValue:@"" forHTTPHeaderField:@"uuid"];
        
        [request setHTTPMethod:@"GET"];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        [connection start];
        [self performSelector:@selector(removeSplashView) withObject:nil];
    }
}
- (void)removeSplashView{
    
    [splashView removeFromSuperview];
    self.window.userInteractionEnabled = YES;

}

#pragma mark - UIAertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.window.userInteractionEnabled = NO;
    
    if (alertView.tag == kUpdatedVersion) {
        switch (buttonIndex) {
            case 0:{
                //以后再说
                break;
            }
            case 1:{
                //前往下载
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.appUrl]];
                break;
            }
            default:
                break;
        }
        
    }else if(alertView.tag==kForcedUpdVersion){
        //    强制更新
        switch (buttonIndex) {
            case 0:{
                //取消
                [self exitApplication];
                break;
            }
            case 1:{
                //前往下载
                [self exitApplication];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://open.boc.cn"]];
                
                break;
            }
                
            default:
                break;
        }
    }else if (alertView.tag==kNetReachable){
        switch (buttonIndex) {
            case 0:
                //进入APP
                break;
                case 1:
                //无网络，强退APP
                [self exitApplication];
                break;
            default:
                break;
        }
        
    }
    self.window.userInteractionEnabled = YES;
}

- (void)exitApplication
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive__");

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground__");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground__");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive___");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate___");

}

+ (EZDBAppDelegate* )appDelegate
{
    return (EZDBAppDelegate*)[[UIApplication sharedApplication] delegate];
}



@end

//
//  UserInfoSample.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-14.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//


#import "UserInfoSample.h"
#import "Reachability.h"


@implementation UserInfoSample

#pragma mark - InitWithSingleton

+ (instancetype)shareInstance
{
    static UserInfoSample *bankUser = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        bankUser = [[UserInfoSample alloc]init];
        //        bankUser -> _hostReach = [Reachability reachabilityWithHostName:DBankReachAdress];
        bankUser -> _vcpEntity = [NSDictionary dictionary];
        bankUser -> _userItems = [NSDictionary dictionary];
        bankUser -> _custItems = [NSDictionary dictionary];
        
#ifdef DBDEBUG
        bankUser -> _logined = YES;
#endif
    });
    
    return bankUser;
}

#pragma mark - Public

- (void)notificationForConnection
{
    _hostReach = [Reachability reachabilityWithHostName:TestAddress];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    
    [_hostReach startNotifier];
}

#pragma mark - Private

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"联网失败，请检查手机网络状态" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

    }
    else
        _connected = YES;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (_hostReach) {
        [_hostReach stopNotifier]; //关闭网络检测
        _hostReach = nil;
    }
}

@end

//
//  UserInfoSample.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-14.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#define TestAddress @"www.baidu.com"

@class Reachability;

#import <Foundation/Foundation.h>

@interface UserInfoSample : NSObject

//网络连接
@property (nonatomic, strong) Reachability *hostReach;

@property (nonatomic) BOOL logined;

@property (nonatomic) BOOL isSetPayPwd;

@property (nonatomic, readonly) BOOL connected;

//超时时间
@property (nonatomic) double forceTime;

@property (nonatomic) double endTime;

//用户个人信息
@property (nonatomic, retain) NSDictionary *userItems;

//客户附加信息
@property (nonatomic, retain) NSDictionary *custItems;

//公告列表
@property (nonatomic, retain) NSDictionary *listItems;

//产品信息
@property (nonatomic, retain) NSDictionary *vcpEntity;

@property (nonatomic, retain) NSString *bankId;

@property (nonatomic, assign) BOOL isBind;

//单例实例化
+ (instancetype)shareInstance;
//监测网络状态
- (void)notificationForConnection;

@end

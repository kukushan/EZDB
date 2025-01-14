//
//  TabBarViewController.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-16.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TabBarViewController : UITabBarController

@property (nonatomic, strong) UIView *customTabbarView;
@property (nonatomic, strong) NSArray *arrayViewcontrollers;
@property (nonatomic, assign) CGFloat tabHeight;

- (NSArray *)getViewcontrollers;
//隐藏tabBar
- (void)hideMyTabBar;
//显示tabBar
- (void)showMyTabBar;

@end

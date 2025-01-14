//
//  STViewController.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-27.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBAlertView;
@class TabBarViewController;
@class NavView;
@protocol SwitchVControllerDelegate <NSObject>

- (void)buttonClickWithIndex:(NSInteger )index;

@end

@interface STViewController : UIViewController

@property (strong, nonatomic) NavView *navView;

@property (strong, nonatomic) TabBarViewController *tabBarVc;

@property (strong, nonatomic) UIButton *homeBtn;
@property (strong, nonatomic) UIButton *finaBtn;
@property (strong, nonatomic) UIButton *AssetBtn;
@property (strong, nonatomic) UIButton *setBtn;

@property (nonatomic,assign) id<SwitchVControllerDelegate>sDelegate;


/** 背景色 */
- (UIColor *)getBackGroundColor;

/** 设置状态栏 */
- (void)setStatusBar;

/** 返回首页 */
- (void)backHomeVc;

/** 设置导航栏 */
- (void)setNavBarWithtitle:(NSString *)title superView:(UIView *)superview backImg:(NSString *)lImgStr homeImg:(NSString *)rImgStr;

- (void)creatRgtBarWithViewController:(UIViewController *)viewController navTitle:(NSString *)title;

- (void)creatLftBarWithViewController:(UIViewController *)viewController navTitle:(NSString *)title;

- (void)creatBarWithViewController:(UIViewController *)viewController navTitle:(NSString *)title backImg:(NSString *)lImgStr homeImg:(NSString *)rImgStr;

- (void)showNBAlertWithAletTag:(NSInteger)tag Title:(NSString *)title content:(NSString *)content btnArray:(NSMutableArray *)array;

@end

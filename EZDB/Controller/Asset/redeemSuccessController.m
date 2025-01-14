//
//  redeemSuccessController.m
//  EZDB
//
//  Created by wenming.zheng on 14/11/17.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//
#import "BlankViewController.h"
#import "redeemSuccessController.h"
#import "AssetViewController.h"
#import "TransactionListController.h"

@interface redeemSuccessController ()

@end

@implementation redeemSuccessController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarWithtitle:@"赎回" superView:self.view backImg:kNavBackImgName homeImg:nil];
    self.view.backgroundColor=kViewBackGroudColor;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 我的资产 点击事件
- (IBAction)myAssetAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark - 交易明细 点击事件

- (IBAction)transactionDetailAction:(id)sender {
    
    NSArray * controllers=[EZDBAppDelegate appDelegate].tabBarCtl.viewControllers;
    UINavigationController * nav=controllers[2];
    [self.navigationController popToViewController:nav.childViewControllers[0]animated:YES];
    
}
@end

//
//  ChangeSuccessViewController.m
//  EZDB
//
//  Created by wenming.zheng on 14/11/11.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "ChangeSuccessViewController.h"

@interface ChangeSuccessViewController ()

@end

@implementation ChangeSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lineImageView.image=[UIImage imageNamed:@"line_change.png"];
    _messageLabel.text=@"基金公司将赎回资金转入到您更换的账户请稍后前往交易明细查看到账详情";
    _messageLabel.textColor=kBlackColor;
    [self setNavBarWithtitle:@"换卡" superView:self.view backImg:kNavBackImgName homeImg:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

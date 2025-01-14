//
//  NoCardPurVController.m
//  EZDB
//
//  Created by wenming.zheng on 14/11/11.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "NoCardPurVController.h"
#import "BorderSetBtn.h"

@interface NoCardPurVController ()<PopViewContrlDelegate>

@end

@implementation NoCardPurVController

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
    [self setNavBarWithtitle:kPurchaseTitle superView:self.view backImg:kNavBackImgName homeImg:kNavHomeImgName];
    [self.proName setTitleColor:kBLueColor forState:UIControlStateNormal];
    [self.proName setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [self.bindBtn.layer setBorderWidth:1];
    [self.bindBtn.layer setCornerRadius:2];
    [self.bindBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
- (void)popViewContrl:(NSInteger )index
{
    switch (index) {
        case 1:{
            NSLog( @"**  click");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - pro detail
- (IBAction)proDetailCheck:(UIButton *)sender
{
    //点击查看基金详情
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

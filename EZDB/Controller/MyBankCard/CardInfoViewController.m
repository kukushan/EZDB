//
//  CardInfoViewController.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-29.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "CardInfoViewController.h"
#import "QueryCardLimitRequest.h"
#import "ModifyCardNameRequest.h"
#import "LoginViewController.h"

#define kMaxLength 10

@interface CardInfoViewController ()

@end

@implementation CardInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - PopViewContrlDelegate
- (void)popViewContrl:(NSInteger )index{
    if (index==1) {
            [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [[EZDBAppDelegate appDelegate].tabBarCtl hideMyTabBar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initUI];
    
    
//    [self loadCardLimit];
}

- (void)initUI
{
    if (kDeviceVersion>=7.0) {
        self.navView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64) navTitle:@"银行卡详情" lBtnImg:kNavBackImgName rBtnImg:nil];
        for (UIView *aview in self.view.subviews) {
            CGRect rect = aview.frame;
            rect.origin.y += 20;
            aview.frame = rect;
        }
        if (IS_IPHONE4) {
            for (UIView *aview in self.view.subviews) {
                CGRect rect = aview.frame;
                rect.origin.y -= 20;
                aview.frame = rect;
            }
        }
    }else{
        self.navView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) navTitle:@"银行卡详情" lBtnImg:kNavBackImgName rBtnImg:nil];
        
        for (UIView *aview in self.view.subviews) {
            CGRect rect = aview.frame;
            rect.origin.y += 10;
            aview.frame = rect;
        }
    }
    self.navView.delegate = (id<PopViewContrlDelegate>)self;
    [self.view addSubview:self.navView];
    
    self.editView.layer.borderWidth = 1;
    self.editView.layer.cornerRadius = 5;
    self.editView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.logoView.layer.borderWidth = 1;
    self.logoView.layer.cornerRadius = 5;
    self.logoView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    self.singleView.layer.borderWidth = 1;
    self.singleView.layer.cornerRadius = 5;
    self.singleView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.dayView.layer.borderWidth = 1;
    self.dayView.layer.cornerRadius = 5;
    self.dayView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.cardTypeTF.delegate = self;
    self.cardTypeTF.text = self.typeString;
    self.numberLabel.text = self.NumberString;
    
    [self.view bringSubviewToFront:self.cardTypeTF];
    [self.sureButton addTarget:self action:@selector(changeCardName:) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton.selected =YES;
    [self.view bringSubviewToFront:self.sureButton];
    [self.sureButton setImage:[UIImage imageNamed:@"ico_ok.png"] forState:UIControlStateNormal];
    [self.sureButton setImage:[UIImage imageNamed:@"ico_modify.png"] forState:UIControlStateSelected];

    [MSUtil judgeBankLogoWith:self.logoString img:self.logoIV];

}
#pragma mark - 卡限额Request
//- (void)loadCardLimit
//{
//    BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
//    
//    QueryCardLimitRequest *request = [QueryCardLimitRequest requestWithHeaders:nil];
//    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
//    //报文头
//    request.headers = headers;
//    //参数
//    NSDictionary *bodyParameters = @{@"bankCode":self.logoString,
//                                     //                                     @"bankName":@"",
//                                     //                                     @"limitSingle":@"",
//                                     //                                     @"limitDay":@"",
//                                     };
//    request.postJSON = [bodyParameters JSONString];
//    
//    NSLog(@"header:%@",request.headers);
//    NSLog(@"bodyjson:%@",request.postJSON);
//
//    [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
//        if ([result[@"serviceResponse"][@"responseCode"]isEqualToString:_responseCode_Banklimit_Done]) {
//            NSLog(@" -- **limitSingle %@, limitDay %@",result[@"limitSingle"],result[@"limitDay"]);
//            self.singleLabel.text = [NSString stringWithFormat:@"¥%@元",result[@"bankOrgLimitDTO"][@"limitSingle"]];
//            self.everydayLabel.text = [NSString stringWithFormat:@"¥%@元",result[@"bankOrgLimitDTO"][@"limitDay"]];
//        }else if ([result[@"msgcde"]isEqualToString:@"ASR-000003"]||
//                  [result[@"msgcde"]isEqualToString:@"ASR-000005"]||
//                  [result[@"msgcde"]isEqualToString:@"invalid_token"]) {
//            [BOCOPLogin sharedInstance].isLogin = NO;
//            NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
//            [self showNBAlertWithAletTag:111 Title:@"温馨提示" content:result[@"rtnmsg"] btnArray:arr];
//        }else{
//            NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
//            [self showNBAlertWithAletTag:113 Title:@"温馨提示" content:result[@"serviceResponse"][@"responseMsg"] btnArray:arr];
//        }
//    }];
//    [request onRequestFailWithError:^(NSError *error) {
//        NSLog(@"error:%@",error);
//        __Login_Invailid_;
//    }];
//    [request connect];
//}
#pragma mark -textField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{


    self.sureButton.selected= NO;
    NSLog(@"textFieldDidBeginEditing");
    [self.sureButton setImage:[UIImage imageNamed:@"ico_ok.png"] forState:UIControlStateNormal];


    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    self.sureButton.selected= NO;

    [self.sureButton setImage:[UIImage imageNamed:@"ico_ok.png"] forState:UIControlStateNormal];

    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        return YES;
}


//#pragma mark - 确定修改卡别名
//- (void)changeCardName:(UIButton *)sender
//{
//
//    sender.selected = !sender.selected;
//
//    if (self.sureButton.isSelected) {
//        [self.view endEditing:YES];
//        int l = [MSUtil convertToInt:self.cardTypeTF.text];
//        NSLog(@"%d",l);
//        
//        if (l<=10) {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
//            
//            ModifyCardNameRequest *request = [ModifyCardNameRequest requestWithHeaders:nil];
//            NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
//            //报文头
//            request.headers = headers;
//            //参数[UserInfoSample shareInstance].userItems[@"uid"]
//            NSDictionary *bodyParameters = @{@"custNo":@"1234674652",
//                                             @"cardNo":self.cardNo,};
//            request.postJSON = [bodyParameters JSONString];
//            
//            NSLog(@"header:%@",request.headers);
//            NSLog(@"bodyjson:%@",request.postJSON);
//            
//            [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
//                NSLog(@"response:%@",result);
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                if ([result[@"serviceResponse"][@"responseCode"]isEqualToString:_responseCode_Card_Done]) {
//                    [MSUtil showHudMessage:@"卡别名修改成功！" hideAfterDelay:1.5 uiview:self.view];
//                    changeCardName(self.cardTypeTF.text);
////                    [self.sureButton setImage:[UIImage imageNamed:@"ico_modify.png"] forState:UIControlStateNormal];
//                }else if ([result[@"msgcde"]isEqualToString:@"ASR-000003"]||
//                          [result[@"msgcde"]isEqualToString:@"ASR-000005"]||
//                          [result[@"msgcde"]isEqualToString:@"invalid_token"]) {
//                    [BOCOPLogin sharedInstance].isLogin = NO;
//                    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
//                    [self showNBAlertWithAletTag:111 Title:@"温馨提示" content:result[@"rtnmsg"] btnArray:arr];
//                }else{
//                    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
//                    [self showNBAlertWithAletTag:113 Title:@"温馨提示" content:result[@"serviceResponse"][@"responseMsg"] btnArray:arr];
//                }
//            }];
//            
//            [request onRequestFailWithError:^(NSError *error) {
//                NSLog(@"error:%@",error);
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                [MSUtil showHudMessage:@"卡别名修改失败！" hideAfterDelay:1.5 uiview:self.view];
//                __Login_Invailid_;
//            }];
//            [request connect];
//        }else if (l>10){
//            [MSUtil showHudMessage:@"长度不可超过10位！" hideAfterDelay:1.5 uiview:self.view];
//        }
//
//    }else{
//        [self.cardTypeTF becomeFirstResponder];
//        [self.sureButton setImage:[UIImage imageNamed:@"ico_modify.png"] forState:UIControlStateSelected];
//
//
//    }
//    
//    NSLog(@"change name ");
//    
//
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.cardTypeTF resignFirstResponder];
    self.sureButton.selected = NO;
    [self.sureButton setImage:[UIImage imageNamed:@"ico_ok.png"] forState:UIControlStateNormal];

    return YES;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

    self.sureButton.selected = NO;
    [self.sureButton setImage:[UIImage imageNamed:@"ico_ok.png"] forState:UIControlStateNormal];
    

}

- (id)initWithBlock:(completeBlock)back
{
    self = [self init];
    if(self){
        changeCardName = back;
    }
    return self;
}
- (void)dealloc{
    
}
#pragma mark - NBAlertViewDelegate
- (void)NBAlertViewDialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==111) {
        [alertView close];
        GOTO_NEXTVIEWCONTROLLER(LoginViewController,
                                @"LoginViewController",
                                @"LoginViewController4");
    }else if([alertView tag]==113){
        [alertView close];
    }
}

@end

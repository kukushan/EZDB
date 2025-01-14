//
//  UpdPwdViewController.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-28.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "UpdPwdViewController.h"
#import "BorderSetLabel.h"
#import "RevisePayPwdDataRequest.h"
#import "ReviseSucVController.h"
#import "BorderSetBtn.h"
#import "ResetPwdVController.h"
#import "LoginViewController.h"
#import "PerCenterVController.h"
#import "GetServerRandomRequest.h"
#include "Base64Transcoder.h"

@interface UpdPwdViewController () 

@end

extern int __counter;

@implementation UpdPwdViewController

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
    [self setUI];
    NSLog(@"__counter %d",__counter);
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[EZDBAppDelegate appDelegate].tabBarCtl hideMyTabBar];
}

#pragma mark - PopViewContrlDelegate
- (void)popViewContrl:(NSInteger )index{
    if (index==1) {
        if ([BOCOPLogin sharedInstance].isLogin) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PerCenterVController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
    }else if(index==2){
       
    }
}

#pragma mark -
- (void)setUI
{

    [self setNavBarWithtitle:kUpdPayPwdTitle superView:self.view backImg:kNavBackImgName homeImg:nil];
    
    self.oldPwdTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.oldPwdTextField.secureTextEntry = YES;
    self.oldPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.oldPwdTextField.returnKeyType = UIReturnKeyDone;
    self.oldPwdTextField.backgroundColor = [UIColor clearColor];
    self.oldPwdTextField.clearsOnBeginEditing = YES;
    self.oldPwdTextField.font = [UIFont systemFontOfSize:14];
    self.oldPwdTextField.borderStyle = UITextBorderStyleNone;
    self.oldPwdTextField.randomeKey_S = @"MDAwMDAwMDAwMDAwMDk4Nw==";
    self.oldPwdTextField.passwordMaxLength=20;
    self.oldPwdTextField.passwordMinLength=6;
    self.oldPwdTextField.outputValueType=2;
    self.oldPwdTextField.passwordRegularExpression = @"[a-zA-Z0-9]*";
    self.oldPwdTextField.sipdelegate = self;
    
    self.pwdTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pwdTextfield.secureTextEntry = YES;
    self.pwdTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pwdTextfield.returnKeyType = UIReturnKeyDone;
    self.pwdTextfield.backgroundColor = [UIColor clearColor];
    self.pwdTextfield.clearsOnBeginEditing = YES;
    self.pwdTextfield.font = [UIFont systemFontOfSize:14];
    self.pwdTextfield.borderStyle = UITextBorderStyleNone;
    self.pwdTextfield.randomeKey_S = @"MDAwMDAwMDAwMDAwMDk4Nw==";
    self.pwdTextfield.passwordMaxLength=20;
    self.pwdTextfield.passwordMinLength=6;
    self.pwdTextfield.outputValueType=2;
    self.pwdTextfield.passwordRegularExpression = @"[a-zA-Z0-9!@#$%^&*_]*";
    self.pwdTextfield.sipdelegate = self;
    
    self.pwdAgainTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pwdAgainTextField.secureTextEntry = YES;
    self.pwdAgainTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pwdAgainTextField.returnKeyType = UIReturnKeyDone;
    self.pwdAgainTextField.backgroundColor = [UIColor clearColor];
    self.pwdAgainTextField.clearsOnBeginEditing = YES;
    self.pwdAgainTextField.font = [UIFont systemFontOfSize:14];
    self.pwdAgainTextField.borderStyle = UITextBorderStyleNone;
    self.pwdAgainTextField.randomeKey_S = @"MDAwMDAwMDAwMDAwMDk4Nw==";
    self.pwdAgainTextField.passwordMaxLength=20;
    self.pwdAgainTextField.passwordMinLength=6;
    self.pwdAgainTextField.outputValueType=2;
    self.pwdAgainTextField.passwordRegularExpression = @"[a-zA-Z0-9!@#$%^&*_]*";

    self.pwdAgainTextField.sipdelegate = self;
    
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fBtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - SubmitBtnClick
- (void)submitBtnClick:(BorderSetBtn *)sender
{
    NSLog(@"___ click");
    if ([self.oldPwdTextField.text isEqualToString:@""]) {
        [MSUtil showHudMessage:@"原密码不能为空" hideAfterDelay:1.5 uiview:self.view];
        
    }else if ([self.pwdTextfield.text isEqualToString:@""]) {
        [MSUtil showHudMessage:@"新密码不能为空" hideAfterDelay:1.5 uiview:self.view];
        
    }else if ([self.pwdAgainTextField.text isEqualToString:@""]) {
        [MSUtil showHudMessage:@"确认密码不能为空" hideAfterDelay:1.5 uiview:self.view];
        
    }else if(self.oldPwdTextField.text.length<6||self.oldPwdTextField.text.length>20){
        [MSUtil showHudMessage:@"原密码长度不符合" hideAfterDelay:1.5 uiview:self.view];
        
    }else if(self.pwdTextfield.text.length<6||self.pwdTextfield.text.length>20){
        [MSUtil showHudMessage:@"新密码长度不符合" hideAfterDelay:1.5 uiview:self.view];
        
    }else if(self.pwdAgainTextField.text.length<6||self.pwdAgainTextField.text.length>20){
        [MSUtil showHudMessage:@"确认密码长度不符合" hideAfterDelay:1.5 uiview:self.view];
        
    }else if(self.pwdTextfield.text.length!=self.pwdAgainTextField.text.length){
        [MSUtil showHudMessage:@"两次输入的新密码长度不匹配" hideAfterDelay:1.5 uiview:self.view];
        
    }else{
        [self getServerRadom];
    }
}

#pragma mark - 获取服务端随机数
- (void)getServerRadom
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
    GetServerRandomRequest *request = [GetServerRandomRequest requestWithHeaders:nil];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
    NSDictionary *params =@{@"AppName":@"ezdb"};
    request.headers = headers;
    request.postJSON = [params JSONString];
    [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
        self.serverRandNum = result[@"serverRandom"];
        NSLog(@"__serverRandNum %@",self.serverRandNum);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *base64RandomCode = [self getBase64RandomCode:self.serverRandNum];
            self.oldPwdTextField.sipdelegate = self;
            self.oldPwdTextField.randomeKey_S = base64RandomCode;
            [self.oldPwdTextField getValue];
        });
    }];
    [request onRequestFailWithError:^(NSError *error) {
        __Login_Invailid_;
    }];
    
    [request connect];
    
}

- (NSString *)getBase64RandomCode:(NSString*)randomCode
{
    int length = [randomCode lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    char inputData[length];
    
    [[randomCode dataUsingEncoding:NSUTF8StringEncoding] getBytes:inputData length:length];
    size_t inputDataSize = (size_t)[randomCode length];
    size_t outputDataSize = EstimateBas64EncodedDataSize(inputDataSize);//calculate the decoded data size
    char outputData[outputDataSize];//prepare a Byte[] for the decoded data
    Base64EncodeData(inputData, inputDataSize, outputData, &outputDataSize);//decode the data
    NSData *theData = [[NSData alloc] initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
	return base64EncodedResult;
}//
#pragma mark - delegate method
#ifdef FORPRODUCT

#else
- (void)actionAfterSip:(int)resultType
        passwordResult:(NSString *)passwordResult
         randomCResult:(NSString *)randomCResult
             errorCode:(NSString *)errorCode
          errorMessage:(NSString *)errorMessage
{
    if (resultType==0) {
        if (errorCode) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *errorInfo = @{@"error_code":errorMessage,@"error_description":errorMessage};
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"  message:errorInfo[@"error_description"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            if(__counter==1) {
                self.pdResult = passwordResult;
                self.randomResult = randomCResult;
                __counter++;
                NSLog(@"1--------%d",__counter);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *base64RandomCode = [self getBase64RandomCode:self.serverRandNum];
                    if(__counter==2){
                        self.pwdTextfield.sipdelegate = self;
                        self.pwdTextfield.randomeKey_S = base64RandomCode;
                        [self.pwdTextfield getValue];
                    }
                });
            }else if (__counter==2){
                NSLog(@"2--------%d",__counter);
                __counter++;
                self.pdResult2 = passwordResult;
                self.randomResult2 = randomCResult;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *base64RandomCode = [self getBase64RandomCode:self.serverRandNum];
                    if(__counter==3){
                        NSLog(@"3--------%d",__counter);
                        self.pwdAgainTextField.sipdelegate = self;
                        self.pwdAgainTextField.randomeKey_S = base64RandomCode;
                        [self.pwdAgainTextField getValue];
                    }
                });
            }else if(__counter==3){
                self.pdResult3 = passwordResult;
                self.randomResult3 = randomCResult;
                [self modifyPayPwd];
            }
        }
    }
}
#endif
    
#pragma mark - 修改支付密码
- (void)modifyPayPwd
{
    NSDictionary *data = @{@"OldPass":self.pdResult,
                           @"OldPass_RC":self.randomResult,
                           @"NewPass":self.pdResult2,
                           @"NewPass_RC":self.randomResult2,
                           @"ReNewPass":self.pdResult3,
                           @"ReNewPass_RC":self.randomResult3,
                           @"rs":self.serverRandNum};
    
    NSDictionary *passwordDTO=@{@"data":data};
    
    NSDictionary *params =@{@"custNo":[UserInfoSample shareInstance].userItems[@"uid"],
                            @"passwordDTO":passwordDTO};
    
    BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
    RevisePayPwdDataRequest *request = [RevisePayPwdDataRequest requestWithHeaders:nil];
    
    NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
    
    request.headers = headParameters;
    request.postJSON = [params JSONString];
    [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
        
        if ([result[@"responseCode"]isEqualToString:_responseCode_PayPwd_Done]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            ReviseSucVController *sucVc = [[ReviseSucVController alloc]initWithNibName:@"ReviseSucVController" bundle:nil];
            sucVc.titleStr = kUpdPayPwdTitle;
            sucVc.labelStr = @"恭喜您，修改成功";
            [self.navigationController pushViewController:sucVc animated:YES];
        }else if ([result[@"msgcde"]isEqualToString:@"ASR-000003"]||
                    [result[@"msgcde"]isEqualToString:@"ASR-000005"]||
                    [result[@"msgcde"]isEqualToString:@"invalid_token"]) {
            [BOCOPLogin sharedInstance].isLogin = NO;
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
            [self showNBAlertWithAletTag:111 Title:@"温馨提示" content:result[@"rtnmsg"] btnArray:arr];
        }else{
            NSLog(@"* >> %@",result[@"responseMsg"]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
            [self showNBAlertWithAletTag:113 Title:@"温馨提示" content:result[@"responseMsg"] btnArray:arr];
        }
       
    }];
    [request onRequestFailWithError:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        __Login_Invailid_;
    }];
    [request connect];

}
#pragma mark -  resetAction
- (void)resetAction:(UIButton *)sender
{
    if ([[UserInfoSample shareInstance].custItems[@"cusname"]isEqualToString:@""]) {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
        [self showNBAlertWithAletTag:113 Title:@"温馨提醒" content:@"您是非实名用户，无法重置支付密码" btnArray:arr];
        
    }else{
        ResetPwdVController *reSetVC = [[ResetPwdVController alloc]initWithNibName:@"ResetPwdVController" bundle:nil];
        [self.navigationController pushViewController:reSetVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - NBAlertViewDelegate
- (void)NBAlertViewDialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==111||
        [alertView tag]==112) {
        [alertView close];
        GOTO_NEXTVIEWCONTROLLER(LoginViewController,
                                @"LoginViewController",
                                @"LoginViewController4");
    }else if([alertView tag]==113){
        [alertView close];
    }
}
//键盘收起
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end

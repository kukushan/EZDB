//
//  ResetPwdVController.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-29.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "ResetPwdVController.h"
#import "ResetPayPwdDataRequest.h"
#import "ReviseSucVController.h"
#import "UpdPwdViewController.h"
#import "BindGetCodeRequest.h"
#import "LoginViewController.h"
#import "GetServerRandomRequest.h"
#import "VerifyMsgCodeRequest.h"
#include "Base64Transcoder.h"

@interface ResetPwdVController ()<AfterSipDelegator,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSTimer *counter;
}
@end

static int time_ = 59;
static int count_enc = 1;

@implementation ResetPwdVController

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
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [counter resumeTimerAfterTimeInterval:INT_MAX];
    [counter invalidate];
}
#pragma mark - PopViewContrlDelegate
- (void)popViewContrl:(NSInteger )index
{
    if (index==1) {
        if ([BOCOPLogin sharedInstance].isLogin) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[UpdPwdViewController class]]) {
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
    if (kDeviceVersion>=7.0) {
        self.navView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64) navTitle:@"重置支付密码" lBtnImg:kNavBackImgName rBtnImg:nil];
    }else{
        self.navView = [[NavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) navTitle:@"重置支付密码" lBtnImg:kNavBackImgName rBtnImg:nil];
        for (UIView *v in self.view.subviews) {
            CGRect rect = v.frame;
            rect.origin.y += 10;
            v.frame = rect;
        }
    }
    self.navView.delegate = (id<PopViewContrlDelegate>)self;
    self.codeTF.delegate = self;
    self.codeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.nPwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nPwdTF.secureTextEntry = YES;
    self.nPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nPwdTF.returnKeyType = UIReturnKeyDone;
    self.nPwdTF.backgroundColor = [UIColor clearColor];
    self.nPwdTF.clearsOnBeginEditing = YES;
    self.nPwdTF.font = [UIFont systemFontOfSize:14];
    self.nPwdTF.borderStyle = UITextBorderStyleNone;
    self.nPwdTF.randomeKey_S = @"MDAwMDAwMDAwMDAwMDk4Nw==";
    self.nPwdTF.passwordMaxLength=20;
    self.nPwdTF.passwordMinLength=6;
    self.nPwdTF.outputValueType=2;
    self.nPwdTF.passwordRegularExpression = @"[a-zA-Z0-9!@#$%^&*_]*";
    self.nPwdTF.sipdelegate = self;
    
    self.confirmPwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.confirmPwdTF.secureTextEntry = YES;
    self.confirmPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.confirmPwdTF.returnKeyType = UIReturnKeyDone;
    self.confirmPwdTF.backgroundColor = [UIColor clearColor];
    self.confirmPwdTF.clearsOnBeginEditing = YES;
    self.confirmPwdTF.font = [UIFont systemFontOfSize:14];
    self.confirmPwdTF.borderStyle = UITextBorderStyleNone;
    self.confirmPwdTF.randomeKey_S = @"MDAwMDAwMDAwMDAwMDk4Nw==";
    self.confirmPwdTF.passwordMaxLength=20;
    self.confirmPwdTF.passwordMinLength=6;
    self.confirmPwdTF.outputValueType=2;
    self.confirmPwdTF.passwordRegularExpression = @"[a-zA-Z0-9!@#$%^&*_]*";
    self.confirmPwdTF.sipdelegate = self;
    
    NSString *phone = [UserInfoSample shareInstance].custItems[@"mobileno"];
    if (phone.length==11) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4)withString:@"****"];
    }
    [self.phoneLabel setBackgroundColor:kViewBackGroudColor];
    [self.phoneLabel setText:phone];
    [self.fetchCodeBtn setBackgroundColor:kRegBackGroudColor];
    [self.fetchCodeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.navView];

}
#pragma mark -  UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // return NO to not change text
    if(textField==self.codeTF){
        if (range.location>=6) {
            return NO;
        }else
            return YES;
    }
    return YES;
}
#pragma mark - 获取验证码
- (void)getCode:(UIButton *)sender
{
//#warning 获取验证码需卡号 卡号获取不明 参数Varilble1待改
    if (self.phoneLabel.text.length==11) {
        [sender setTitle:[NSString stringWithFormat:@"重新获取(%d)",time_] forState:UIControlStateNormal];
        sender.userInteractionEnabled = NO;
        counter = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        NSDictionary *CustomerInfoDTO =@{@"relMobile":[UserInfoSample shareInstance].custItems[@"mobileno"]};
        
        //交易类型
        NSDictionary *SmsTempleteDataDTO =@{@"smsTempType":@"01",
                                            @"SmsTransType":@"032",
                                            @"Varilble1":@"",
                                            @"Varilble2":@"ezdb"};
        
        NSDictionary *params = @{@"customerInfoDTO":CustomerInfoDTO,
                                 @"smsTemplateDataDTO":SmsTempleteDataDTO,};
        
        BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
        BindGetCodeRequest *request = [BindGetCodeRequest requestWithHeaders:nil];
        
        NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
        
        request.headers = headParameters;
        request.postJSON = [params JSONString];
        
        NSLog(@"———— %@",request.postJSON);
        [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
            [MBProgressHUD hideHUDForView: self.view animated:YES];
            if ([result[@"serviceResponse"][@"responseCode"] isEqualToString:_responseCode_Msg_Done]) {
                NSLog(@"&& ^^ ** 获取短信验证码成功");
                
            }else if ([result[@"msgcde"]isEqualToString:@"ASR-000003"]||
                      [result[@"msgcde"]isEqualToString:@"ASR-000005"]||
                      [result[@"msgcde"]isEqualToString:@"invalid_token"]) {
                [BOCOPLogin sharedInstance].isLogin = NO;
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                [self showNBAlertWithAletTag:111 Title:@"温馨提示" content:result[@"rtnmsg"] btnArray:arr];
            }else{
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                [self showNBAlertWithAletTag:110 Title:@"温馨提示" content:result[@"serviceResponse"][@"responseMsg"] btnArray:arr];
            }
        }];
        
        [request onRequestFailWithError:^(NSError *error) {
            __Login_Invailid_;
        }];
        [request connect];

    }else{
        [MSUtil showHudMessage:@"手机号长度不符" hideAfterDelay:1.5 uiview:self.view];
    }
}
#pragma mark - 定时器changeTime
- (void)changeTime
{
    time_--;
    [self.fetchCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",time_] forState:UIControlStateNormal];
    if (time_==-1) {
        [counter invalidate];
        [self.fetchCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.fetchCodeBtn setUserInteractionEnabled:YES];
        time_ = 59;
    }
}

#pragma mark - delegate method
- (void)actionAfterSip:(int)resultType
        passwordResult:(NSString *)passwordResult
         randomCResult:(NSString *)randomCResult
             errorCode:(NSString *)errorCode
          errorMessage:(NSString *)errorMessage
{
    NSLog(@"actionAfterSip _");
    if (resultType==0) {
        if (errorCode) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *errorInfo = @{@"error_code":errorMessage,@"error_description":errorMessage};
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"  message:errorInfo[@"error_description"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            if(count_enc==1) {
                self.pdResult = passwordResult;
                self.randomResult = randomCResult;
                NSLog(@"1--------%d",count_enc);
                count_enc++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *base64RandomCode = [self getBase64RandomCode:self.serverRandNum];
                    NSLog(@"base64RandomCode %@",base64RandomCode);
                    self.confirmPwdTF.sipdelegate = self;
                    self.confirmPwdTF.randomeKey_S = base64RandomCode;
                    [self.confirmPwdTF getValue];
                });
            }else if (count_enc==2){
                NSLog(@"2--------%d",count_enc);
                self.pdResult2 = passwordResult;
                self.randomResult2 = randomCResult;
                NSLog(@"*******   second is %@",self.pdResult2);
                NSDictionary *data = @{@"OldPass":self.pdResult,
                                       @"OldPass_RC":self.randomResult,
                                       @"NewPass":self.pdResult2,
                                       @"NewPass_RC":self.randomResult2,
                                       @"rs":self.serverRandNum};
                
                NSDictionary *passwordDTO = @{@"data":data};
                NSDictionary *params = @{@"custNo":[UserInfoSample shareInstance].userItems[@"uid"],
                                        @"passwordDTO":passwordDTO,};
                BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
                ResetPayPwdDataRequest *request = [ResetPayPwdDataRequest requestWithHeaders:nil];
                
                NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
                
                request.headers = headParameters;
                request.postJSON = [params JSONString];
                //重置请求
                [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
                    if ([result[@"responseCode"]isEqualToString:_responseCode_PayPwd_Done]) {
                        count_enc = 1;
                        NSLog(@"result___________^^^^^  %@",result);
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        ReviseSucVController *sucVc = [[ReviseSucVController alloc]initWithNibName:@"ReviseSucVController" bundle:nil];
                        sucVc.titleStr = @"重置密码成功";
                        sucVc.labelStr = @"恭喜您，重置成功";
                        [self.navigationController pushViewController:sucVc animated:YES];
                        
                    }else if ([result[@"msgcde"]isEqualToString:@"ASR-000003"]||
                              [result[@"msgcde"]isEqualToString:@"ASR-000005"]||
                              [result[@"msgcde"]isEqualToString:@"invalid_token"]) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [BOCOPLogin sharedInstance].isLogin = NO;
                        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                        [self showNBAlertWithAletTag:111 Title:@"温馨提醒" content:result[@"rtnmsg"] btnArray:arr];
                    }else{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                        [self showNBAlertWithAletTag:110 Title:@"温馨提醒" content:result[@"responseMsg"] btnArray:arr];
                    }
                }];
                
                [request onRequestFailWithError:^(NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    __Login_Invailid_;
                }];
                [request connect];
            }
        }
    }
}

#pragma mark - submit Button
- (IBAction)submitBtn:(UIButton *)sender
{
    if ([self.nPwdTF.text isEqualToString:@""]) {
        [MSUtil showHudMessage:@"新密码不能为空" hideAfterDelay:1.5 uiview:self.view];
    }else if ([self.confirmPwdTF.text isEqualToString:@""]) {
        [MSUtil showHudMessage:@"确认密码不能为空" hideAfterDelay:1.5 uiview:self.view];
    }else if(self.nPwdTF.text.length<6||self.nPwdTF.text.length>20){
        [MSUtil showHudMessage:@"新密码长度不符合" hideAfterDelay:1.5 uiview:self.view];
    }else if(self.confirmPwdTF.text.length<6||self.confirmPwdTF.text.length>20){
        [MSUtil showHudMessage:@"确认密码长度不符合" hideAfterDelay:1.5 uiview:self.view];
    }else if(self.nPwdTF.text.length!=self.confirmPwdTF.text.length){
        [MSUtil showHudMessage:@"两次密码长度不匹配" hideAfterDelay:1.5 uiview:self.view];
    }else if(self.codeTF.text.length<6||self.codeTF.text.length>6){
        [MSUtil showHudMessage:@"验证码长度不匹配" hideAfterDelay:1.5 uiview:self.view];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        //先校验验证码
//        NSDictionary *customerInfoDTO = @{@"relMobile":[UserInfoSample shareInstance].custItems[@"mobileno"],
//                                          @"validCode":self.codeTF.text,};
//        NSDictionary *params = @{@"customerInfoDTO":customerInfoDTO};
//        
//        BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
//        VerifyMsgCodeRequest *request = [VerifyMsgCodeRequest requestWithHeaders:nil];
//        
//        NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
//        request.headers = headParameters;
//        request.postJSON = [params JSONString];
//        [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
//            if ([result[@"serviceResponse"][@"responseCode"] isEqualToString:_responseCode_Msg_Done]) {
                //短信验证码校验成功 再获取服务端随机数
                [self getServerRadom];
//            }else{
//                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
//                [self showNBAlertWithAletTag:110 Title:@"温馨提醒" content:result[@"serviceResponse"][@"responseMsg"] btnArray:arr];
//            }
//        }];
//        [request onRequestFailWithError:^(NSError *error) {
//            __Login_Invailid_;
//        }];
    }
}
#pragma mark - 获取服务端随机数
- (void)getServerRadom
{
    BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
    GetServerRandomRequest *request = [GetServerRandomRequest requestWithHeaders:nil];
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
    NSDictionary *params = @{@"AppName":@"ezdb"};
    request.headers = headers;
    request.postJSON = [params JSONString];
    [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
        self.serverRandNum = result[@"serverRandom"];
        NSLog(@"__serverRandNum %@",self.serverRandNum);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *base64RandomCode = [self getBase64RandomCode:self.serverRandNum];
            if (count_enc==1) {
                NSLog(@"base64RandomCode %@",base64RandomCode);
                self.nPwdTF.sipdelegate = self;
                self.nPwdTF.randomeKey_S = base64RandomCode;
                [self.nPwdTF getValue];
            }else if(count_enc==2){
                self.confirmPwdTF.sipdelegate = self;
                self.confirmPwdTF.randomeKey_S = base64RandomCode;
                [self.confirmPwdTF getValue];
            }
        });
    }];
    [request onRequestFailWithError:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        __Login_Invailid_;
    }];
    
    [request connect];
    
}
#pragma mark - base 64
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
}

//键盘收起
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    time_ = 59;
    counter = nil;
    NSLog(@"__counter dealloc");
}

#pragma mark - NBAlertViewDelegate
- (void)NBAlertViewDialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==111||
        [alertView tag]==112||
        [alertView tag]==113) {
        [alertView close];
        GOTO_NEXTVIEWCONTROLLER(LoginViewController,
                                @"LoginViewController",
                                @"LoginViewController4");
    }else if([alertView tag]==110){
        [alertView close];
    }
}

@end

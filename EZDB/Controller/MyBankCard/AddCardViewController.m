//
//  AddCardViewController.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-30.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "AddCardViewController.h"
#import "AddSuccessViewController.h"
#import "LoginViewController.h"
#import "BindCardSubmitRequest.h"
#import "BindCardDataRequest.h"
#import "BindGetCodeRequest.h"
#import "VerifyMsgCodeRequest.h"
#import "BindCardModel.h"
#import "ChooseCardCell.h"
#import <QuartzCore/QuartzCore.h>

static int timer = 59;

@interface AddCardViewController ()
{
    BOOL                    isSlectedCard;
    BOOL                    isBocCard;
    UIView                  *bottomView;
    UIView                  *hidePlusView;
    UIView                  *backView;
    NSTimer                 *counter;
    NSString                *btnTitle;
    NSString                *phoneNo;
    NSString                *notBocId;
    NSMutableArray          *nameArr;
    NSMutableArray          *logoArr;
    NSDictionary            *bankIdDic;
}

@end

@implementation AddCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}
#pragma mark - PopViewContrlDelegate
- (void)popViewContrl:(NSInteger )index{
//    if (index==1) {
//        if ([BOCOPLogin sharedInstance].isLogin) {
            [self.navigationController popViewControllerAnimated:YES];
    
//        }
//    }else if(index==2){
//    }
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self setTextField];
    [self hidePlusTextField];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [counter resumeTimerAfterTimeInterval:INT_MAX];
    [counter invalidate];
}
#pragma mark -隐藏多余的选项
- (void)hidePlusTextField
{
    [_avoidScrollView setBackgroundColor:[UIColor whiteColor]];
    if (IS_IPHONE4) {
        hidePlusView =[[UIView alloc]initWithFrame:CGRectMake(0,180, kScreenWidth, kScreenHeight)];
    }else{
        hidePlusView =[[UIView alloc]initWithFrame:CGRectMake(0,220, kScreenWidth, kScreenHeight)];
    }
    hidePlusView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:hidePlusView];
    [hidePlusView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton * showAllButton=[[UIButton alloc]initWithFrame:CGRectMake(15, 20, kScreenWidth-30, 40)];
    [showAllButton setBackgroundColor:kBtnBackGroudColor];
    [showAllButton setTitle:@"确定" forState:UIControlStateNormal];
    [showAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [showAllButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [showAllButton addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
    [showAllButton.layer setCornerRadius:5.0f];
    [hidePlusView addSubview:showAllButton];
    [_avoidScrollView addSubview:hidePlusView];
    
}
- (void)showAll:(UIButton *)button
{
    if ((self.cardNoTf.text.length>0)) {
    
        [UIView animateWithDuration:0.3 animations:^{
            hidePlusView.frame = CGRectMake(0, kScreenHeight, kScreenWidth,kScreenHeight);
        }];
        [button removeFromSuperview];
        [hidePlusView removeFromSuperview];
    }
    
}
#pragma mark - initUI
- (void)initUI
{
    nameArr = [NSMutableArray arrayWithObjects:
                                       @"中国银行",
                                       @"中国农业银行",
                                       @"中国工商银行",
                                       @"中国建设银行",
                                       @"兴业银行",
                                       @"中信银行",
                                       @"光大银行",nil];
    
    logoArr = [NSMutableArray arrayWithObjects:
                                       @"ico_boc",
                                       @"ico_abc",
                                       @"ico_icbc",
                                       @"ico_ccb",
                                       @"ico_cib",
                                       @"ico_citic",
                                       @"ico_ceb",nil];
    
    bankIdDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"102",@"中国工商银行",
                                     @"103",@"中国农业银行",
                                     @"105",@"中国建设银行",
                                     @"309",@"兴业银行",
                                     @"303",@"光大银行",
                                     @"302",@"中信银行",nil];
    
    if (IS_IPHONE4) {
        self.avoidScrollView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight-44);
    }
    else {
        self.avoidScrollView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    }

    [self.view setBackgroundColor:kViewBackGroudColor];
    [self setNavBarWithtitle:kBindCardTitle superView:self.view backImg:kNavBackImgName homeImg:nil];
    [self.fetchCodeBtn setBackgroundColor:kRegBackGroudColor];
//    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)setTextField
{
    //卡号
    self.cardNoTf.delegate = self;
    self.cardNoTf.keyboardType = UIKeyboardTypeNumberPad;
    //客户姓名
    self.custNameTf.delegate = self;
    //证件类型
    self.idTypeTf.delegate = self;
    //证件号码
    self.idNoTf.delegate = self;
    //手机号
    self.phoneNoTf.delegate = self;
    self.phoneNoTf.keyboardType = UIKeyboardTypePhonePad;
    //卡别名
    self.cardNameTf.delegate = self;
    //验证码
    self.codeTf.delegate = self;
    self.codeTf.keyboardType = UIKeyboardTypeNumberPad;
}
#pragma mark - 确定按钮点击
- (IBAction)submitClick:(BorderSetBtn *)sender
{
    [self.view endEditing:YES];
    if (isBocCard) {
        NSString *cardNo = [self.cardNoTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (self.custNameTf.text.length==0) {
            [MSUtil showHudMessage:@"持卡人姓名不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.idTypeTf.text.length==0){
            [MSUtil showHudMessage:@"证件类型不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.cardNoTf.text.length==0){
            [MSUtil showHudMessage:@"卡号不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.idNoTf.text.length==0) {
            [MSUtil showHudMessage:@"证件号码不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if([MSUtil convertToInt:self.cardNameTf.text]>10) {
            [MSUtil showHudMessage:@"卡别名长度不符" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.phoneNoTf.text.length==0) {
            [MSUtil showHudMessage:@"手机号不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.codeTf.text.length==0){
            [MSUtil showHudMessage:@"验证码不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.codeTf.text.length>6||self.codeTf.text.length<6){
            [MSUtil showHudMessage:@"验证码长度不符" hideAfterDelay:1.5 uiview:self.view];
        }else if(cardNo.length>19||cardNo.length<19){
            NSLog(@"—————— 卡号长度 %d",cardNo.length);
            [MSUtil showHudMessage:@"卡号长度不符" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.phoneNoTf.text.length>11||self.phoneNoTf.text.length<11){
            [MSUtil showHudMessage:@"手机号长度不符" hideAfterDelay:1.5 uiview:self.view];
        }else if(![MSUtil validateMobile:phoneNo]) {
            [MSUtil showHudMessage:@"不是有效手机号" hideAfterDelay:1.5 uiview:self.view];
            NSLog(@"! phoneNo. is %@",phoneNo);
        }else{
            [self isBoc_requestSubmit];
        }
    }else {
        NSString *cardNo = [self.cardNoTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (self.custNameTf.text.length==0) {
            [MSUtil showHudMessage:@"持卡人姓名不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.idTypeTf.text.length==0){
            [MSUtil showHudMessage:@"证件类型不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.cardNoTf.text.length==0){
            [MSUtil showHudMessage:@"卡号不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.idNoTf.text.length==0) {
            [MSUtil showHudMessage:@"证件号码不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if([MSUtil convertToInt:self.cardNameTf.text]>10) {
            [MSUtil showHudMessage:@"卡别名长度不符合" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.phoneNoTf.text.length==0) {
            [MSUtil showHudMessage:@"手机号不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.codeTf.text.length==0){
            [MSUtil showHudMessage:@"验证码不能为空" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.codeTf.text.length>6||self.codeTf.text.length<6){
            [MSUtil showHudMessage:@"验证码长度不符合" hideAfterDelay:1.5 uiview:self.view];
        }else if(cardNo.length>19||cardNo.length<19){
            NSLog(@"—————— 卡号长度 %d",cardNo.length);
            [MSUtil showHudMessage:@"卡号长度不符合" hideAfterDelay:1.5 uiview:self.view];
        }else if(self.phoneNoTf.text.length>11||self.phoneNoTf.text.length<11){
            [MSUtil showHudMessage:@"手机号长度不符合" hideAfterDelay:1.5 uiview:self.view];
        }else if(![MSUtil validateMobile:self.phoneNoTf.text]) {
            [MSUtil showHudMessage:@"不是有效手机号" hideAfterDelay:1.5 uiview:self.view];
        }else{
            [self isNotBoc_requestSubmit];
        }
    }
}
#pragma mark - 获取验证码
- (IBAction)getVerCode:(UIButton *)sender
{
    if (self.phoneNoTf.text.length==11) {
        NSLog(@"———————— self.phoneNoTf.text is%@",self.phoneNoTf.text);
        timer = 59;
        [sender setTitle:[NSString stringWithFormat:@"重新获取(%d)",timer] forState:UIControlStateNormal];
        sender.userInteractionEnabled = NO;
        counter = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        
        NSDictionary *CustomerInfoDTO =@{@"relMobile":self.phoneNoTf.text};
        
        NSString *pre_cardNo = [self.cardNoTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *lastFour =  [pre_cardNo substringFromIndex:(pre_cardNo.length-4)];
        NSLog(@"_currentCard No.last 4 %@",lastFour);
        NSDictionary *SmsTempleteDataDTO =@{@"smsTempType":@"01",
                                            @"SmsTransType":@"021",
                                            @"Varilble1":lastFour,
                                            @"Varilble2":@"ezdb"};

        NSDictionary *params = @{@"customerInfoDTO":CustomerInfoDTO,
                                 @"smsTempleteDataDTO":SmsTempleteDataDTO,};
        
        BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
        BindGetCodeRequest *request = [BindGetCodeRequest requestWithHeaders:nil];
        
        NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
        
        request.headers = headParameters;
        request.postJSON = [params JSONString];
        
        NSLog(@"———— %@",request.postJSON);
        [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
            NSLog(@"**** SSSS ___ %@, errMsg is %@",result[@"serviceResponse"][@"responseCode"],result[@"errMsg"]);
            if ([result[@"serviceResponse"][@"responseCode"] isEqualToString:_responseCode_Msg_Done]) {
                NSLog(@"&& ^^ ** 获取短信验证码成功");
            }else if ([result[@"msgcde"]isEqualToString:@"ASR-000003"]||
                      [result[@"msgcde"]isEqualToString:@"ASR-000005"]||
                      [result[@"msgcde"]isEqualToString:@"invalid_token"]) {
                [BOCOPLogin sharedInstance].isLogin = NO;
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                [self showNBAlertWithAletTag:16 Title:@"温馨提示" content:result[@"rtnmsg"] btnArray:arr];
            }else{
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                [self showNBAlertWithAletTag:19 Title:@"温馨提示" content:result[@"serviceResponse"][@"responseMsg"] btnArray:arr];
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
    timer--;
    NSLog(@"____ timer is %d",timer);
    [self.fetchCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",timer] forState:UIControlStateNormal];
    if (timer==-1) {
        [counter invalidate];
        [self.fetchCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.fetchCodeBtn.userInteractionEnabled = YES;
        timer = 59;
    }
}

#pragma mark - 选择开户行
- (IBAction)addNewCardBtn:(UIButton *)sender
{
#ifdef Debug
    
#else
    [self.view endEditing:YES];

    backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight/2)];
    [backView setTag:69];
    [backView setBackgroundColor:[UIColor clearColor]];
    [backView setUserInteractionEnabled:YES];
    
    UIView * clearTapView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, backView.frame.size.height-bottomView.frame.size.height)];
    [clearTapView setBackgroundColor:[UIColor clearColor]];
    [backView addSubview:clearTapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForHiding:)];
    [clearTapView addGestureRecognizer:tap];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    v.backgroundColor = [UIColor lightGrayColor];
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 25)];
    chooseLabel.font = [UIFont systemFontOfSize:16];
    chooseLabel.backgroundColor = [UIColor clearColor];
    chooseLabel.text = @"选择银行卡";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(kScreenWidth-80, 0, 80, 45)];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, v.frame.size.height, kScreenWidth, bottomView.frame.size.height-v.frame.size.height) style:UITableViewStylePlain];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setTag:68];
    [tableView setRowHeight:50];
    
    [tableView registerNib:[UINib nibWithNibName:@"ChooseCardCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [v addSubview:button];
    [v addSubview:chooseLabel];
    [bottomView addSubview:v];
    [bottomView addSubview:tableView];
    
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(0, kScreenHeight-kScreenHeight/2, kScreenWidth, kScreenHeight/2);
        [[UIApplication sharedApplication].keyWindow addSubview:backView];
        [backView addSubview:bottomView];
    }];
    
#endif
}
#pragma mark - popSubmitBtn 隐藏popView
- (void)tapForHiding:(UITapGestureRecognizer *)tap
{
    [self hidePopView];
}

- (void)popSubmitBtn:(UIButton *)sender
{
    [self hidePopView];
}

- (void)hidePopView
{
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 315);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [bottomView removeFromSuperview];
            [backView removeFromSuperview];
            bottomView = nil;
            backView = nil;
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.cardNoTf) {
        if ([string isEqualToString:@""]) { // 删除字符
            if ((textField.text.length-2)%5 == 0) {
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
            return YES;
            
        }else{
            if (textField.text.length%5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        if (range.location>=24){
            return NO;
        }else
            return YES;
        // 四位加一个空格
    }else if(textField==self.phoneNoTf){
        if (range.location>=11){
            return NO;
        }else
            return YES;
        
    }else if(textField==self.custNameTf){
        if (range.location>=8){
            return NO;
        }else
            return YES;
        
    }else if(textField==self.codeTf){
        if (range.location>=6) {
            return NO;
        }else
            return YES;
    }else if(textField==self.idNoTf){
        if (range.location>=18) {
            return NO;
        }else
            return YES;
    }else if(textField==self.cardNameTf){
        if (range.location>=10) {
            return NO;
        }else
            return YES;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(!isSlectedCard){// ** 没有选择开户卡
        [textField resignFirstResponder];
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
        [self showNBAlertWithAletTag:12 Title:@"温馨提示" content:@"您未选择开户行,请先选择" btnArray:arr];
        
        NSLog(@"—————— 未选择开户行卡");
    }else{    // ** 选择了开户卡
        if (isBocCard) {
            NSLog(@" ** 选择了中行卡");
            if ([self.cardNoTf.text isEqualToString:@""]) {
                self.idTypeTf.userInteractionEnabled = NO;
                self.custNameTf.userInteractionEnabled = NO;
                self.idNoTf.userInteractionEnabled = NO;
                self.phoneNoTf.userInteractionEnabled = NO;
            }else{
                self.cardNameTf.userInteractionEnabled = YES;
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (isSlectedCard) {
        btnTitle = [self.addCardBtn titleForState:UIControlStateNormal];
        if ([btnTitle isEqualToString:nameArr[0]]) {
            if (textField==self.cardNoTf) {
                if ([self.cardNoTf resignFirstResponder]) {
                    NSString *cardNo = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSLog(@"____textField %@",cardNo);
                    
                    if (cardNo.length!=16||cardNo.length!=19) {
                        [MSUtil showHudMessage:@"卡号长度不符" hideAfterDelay:1.5 uiview:self.view];
                    }else{
                        [self.cardNoTf resignFirstResponder];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#pragma mark - 本行卡校验
                        NSLog(@"…………………………%@",[UserInfoSample shareInstance].userItems[@"uid"]);
                        NSDictionary *cardServiceDTO = @{ @"custNo":[UserInfoSample shareInstance].userItems[@"uid"],@"cardNo":cardNo,};
                        NSDictionary *params = @{
                                                 @"type":@"validCardInfo",
                                                 @"cardServiceDTO":cardServiceDTO};
                        
                        BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
                        BindCardDataRequest *request = [BindCardDataRequest requestWithHeaders:nil];
                        
                        NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
                        
                        request.headers = headParameters;
                        request.postJSON = [params JSONString];
                        
                        [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            NSLog(@"____** result %@",result);
                            //判断客户证件类型
                            if ([result[@"serviceResponse"][@"responseCode"]isEqualToString:_responseCode_Card_Done]) {
                                NSString *name = result[@"custName"];
                                if(name.length>2){
                                    for (int i=0; i<name.length-1; i++) {
                                        name = [name stringByReplacingCharactersInRange:NSMakeRange(0, i+1) withString:@"*"];
                                    }
                                }else if(name.length==2){
                                    name = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
                                }
                                phoneNo = result[@"relMobile"];
                                NSString *phone = [result[@"relMobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                                NSString *idNo = result[@"custNo"];
                                if (idNo.length==18) {
                                    idNo = [idNo stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
                                }
                                
                                NSLog(@"_name is __ ** %@, _phone is %@",name,phone);
                                self.custNameTf.text = name;
                                self.idTypeTf.text = @"居民身份证";
                                self.phoneNoTf.text = phone;
                                self.idNoTf.text = idNo;
                                
                                self.custNameTf.userInteractionEnabled = NO;
                                self.idTypeTf.userInteractionEnabled = NO;
                                self.idNoTf.userInteractionEnabled = NO;
                                self.phoneNoTf.userInteractionEnabled = NO;
                                //                                显示全部栏目
                                [UIView animateWithDuration:0.3 animations:^{
                                    hidePlusView.frame = CGRectMake(0, kScreenHeight, kScreenWidth,kScreenHeight);
                                }];
                                _avoidScrollView.contentOffset=CGPointMake(0, 0);
                                [hidePlusView removeFromSuperview];

                            }else if ([result[@"msgcde"]isEqualToString:@"ASR-000003"]||
                                [result[@"msgcde"]isEqualToString:@"ASR-000005"]||
                                [result[@"msgcde"]isEqualToString:@"invalid_token"]) {
                                [BOCOPLogin sharedInstance].isLogin = NO;
                                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                                [self showNBAlertWithAletTag:13 Title:@"温馨提示" content:result[@"rtnmsg"] btnArray:arr];
                            }
//                            else if ([result[@"certType"]isEqualToString:@"01"]) {//改变了判定条件，注释掉}
                            else {
                                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                                [self showNBAlertWithAletTag:19 Title:@"温馨提示" content:result[@"serviceResponse"][@"responseMsg"] btnArray:arr];
                            }
                        }];
                        
                        [request onRequestFailWithError:^(NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            NSLog(@"____** %@",error);

                            NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                            [self showNBAlertWithAletTag:15 Title:@"温馨提示" content:[error userInfo][@"error_description"] btnArray:arr];
                        }];
                        [request connect];
                    }
                }else{
                    NSLog(@"*** ___ ***__ 未结束编辑 ");
                }
            }else {
                NSLog(@">>> 不是卡号输入框");
            }
        }else{
            NSLog(@"### ___ 他行卡");
            self.phoneNoTf.userInteractionEnabled = YES;
            self.cardNameTf.userInteractionEnabled = YES;

            if (textField==self.cardNoTf){
                if ([self.view endEditing:YES]) {
                    NSString *cardNo = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSLog(@"____textField 卡号长度 %d",cardNo.length);
                    if (cardNo.length!=16||cardNo.length!=19) {
                        [MSUtil showHudMessage:@"卡号长度不符" hideAfterDelay:1.5 uiview:self.view];
                    }else {
                        [self.cardNoTf resignFirstResponder];
                    }
                }
            }else if(textField==self.idNoTf){
                if(self.idNoTf.text.length>18||self.idNoTf.text.length<18) {
                    [MSUtil showHudMessage:@"证件号码长度不符合" hideAfterDelay:1.5 uiview:self.view];
                }else if(![MSUtil validateIdentityCard:self.idNoTf.text]) {
                    [MSUtil showHudMessage:@"不是有效身份证件" hideAfterDelay:1.5 uiview:self.view];
                }
            }else if(textField==self.cardNoTf){
                if(self.cardNoTf.text.length>10) {
                    [MSUtil showHudMessage:@"卡别名长度不符合" hideAfterDelay:1.5 uiview:self.view];
                    self.cardNameTf.text = @"";
                }
            }else if(textField==self.custNameTf){
                if(self.custNameTf.text.length>10) {
                    [MSUtil showHudMessage:@"持卡人姓名长度不符合" hideAfterDelay:1.5 uiview:self.view];
                }
            }
        }
    }else {
        NSLog(@"—————— 未选择开户行卡");
    }
}

#pragma mark - NBAlertViewDelegate
- (void)NBAlertViewDialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag]==11||
        [alertView tag]==18||
        [alertView tag]==19) {
        [alertView close];
    }else if([alertView tag]==12){
        [alertView close];
        self.cardNoTf.text = @"";
        self.cardNameTf.text = @"";
        self.idNoTf.text = @"";
        self.phoneNoTf.text = @"";
        self.custNameTf.text = @"";
        self.idTypeTf.text = @"";
    }else if([alertView tag]==13||
             [alertView tag]==111||
             [alertView tag]==16||
             [alertView tag]==17){
        [alertView close];
        [BOCOPLogin sharedInstance].isLogin = NO;;
        GOTO_NEXTVIEWCONTROLLER(LoginViewController,
                                @"LoginViewController",
                                @"LoginViewController4");
    }else if([alertView tag]==14){
        [alertView close];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([alertView tag]==15){
        [alertView close];
        [self backHomeVc];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.CardIcon.image = [UIImage imageNamed:logoArr[indexPath.row]];
    cell.CardName.text = nameArr[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSlectedCard = YES;
    [self.addCardBtn setTitle:nameArr[indexPath.row] forState:UIControlStateNormal];
    [self.addCardBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    if (![nameArr[indexPath.row] isEqualToString:nameArr[0]]) {
        //  ** 非本行卡
        notBocId = [bankIdDic objectForKey:nameArr[indexPath.row]];
        NSLog(@"非本行卡 bankId %@",notBocId);
        if ([[UserInfoSample shareInstance].custItems[@"cusname"] isEqualToString:@""]) {
            NSLog(@"___ 无客户信息");
            if (self.cardNoTf.text!=nil) {
                self.cardNameTf.text = @"";
                self.idNoTf.text = @"";
                self.phoneNoTf.text = @"";
                self.cardNoTf.text = @"";
                self.custNameTf.text = @"";
            }
            self.idTypeTf.text = @"居民身份证";
            self.custNameTf.userInteractionEnabled = YES;
            self.idTypeTf.userInteractionEnabled = NO;
            self.idNoTf.userInteractionEnabled = YES;
            self.phoneNoTf.userInteractionEnabled = YES;
            
        }else{
            NSLog(@"有客户信息___cusname %@,%@",[UserInfoSample shareInstance].custItems,[UserInfoSample shareInstance].custItems[@"cusname"]);
            NSString *name = [UserInfoSample shareInstance].custItems[@"cusname"];
            if(name.length>2){
                for (int i=0; i<name.length-1; i++) {
                    name = [name stringByReplacingCharactersInRange:NSMakeRange(0, i+1) withString:@"*"];
                }
            }else if(name.length==2){
                name = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            }
            NSString *idNo = [UserInfoSample shareInstance].custItems[@"idno"];
            if (idNo.length==18) {
                idNo = [idNo stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
            }else if(idNo.length>10||idNo.length<18){
                NSMutableString *string = [NSMutableString string];
                for (int i=0; i<idNo.length-6-4; i++) {
                    [string appendString:@"*"];
                }
                idNo = [idNo stringByReplacingCharactersInRange:NSMakeRange(6, idNo.length-6-4) withString:string];
            }
            
            if([[UserInfoSample shareInstance].custItems[@"idtype"] isEqualToString:@"01"]){
                  self.idTypeTf.text = @"居民身份证";
            }
            self.custNameTf.text = name;
            self.idNoTf.text = idNo;
            self.cardNoTf.text = @"";
            self.phoneNoTf.text = @"";
            
            self.phoneNoTf.userInteractionEnabled = YES;
            self.custNameTf.userInteractionEnabled = NO;
            self.idTypeTf.userInteractionEnabled = NO;
            self.idNoTf.userInteractionEnabled = NO;
        }
        isBocCard = NO;
    }else{
        isBocCard = YES;
        NSLog(@"本行卡___selected");
        self.cardNoTf.text = @"";
        self.idTypeTf.text = @"";
        self.idNoTf.text = @"";
        self.custNameTf.text = @"";
        self.phoneNoTf.text = @"";
        self.cardNameTf.text = @"";
        self.phoneNoTf.userInteractionEnabled = YES;
        self.idNoTf.userInteractionEnabled = YES;
        self.custNameTf.userInteractionEnabled = YES;
        self.idTypeTf.userInteractionEnabled = YES;
    }
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 315);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [bottomView removeFromSuperview];
            [backView removeFromSuperview];
            bottomView = nil;
            backView = nil;
        }
    }];

}

#pragma mark - 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    timer = 59;
    counter = nil;
    NSLog(@"__counter dealloc");
}

#pragma mark - 校验短信验证码与绑定卡请求

- (void)isBoc_requestSubmit
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSDictionary *customerInfoDTO = @{@"relMobile":self.phoneNoTf.text,
//                                      @"validCode":self.codeTf.text,};
//    NSDictionary *params = @{@"customerInfoDTO":customerInfoDTO};
////验证码校验
//    BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
//    VerifyMsgCodeRequest *request = [VerifyMsgCodeRequest requestWithHeaders:nil];
//    
//    NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
//    request.headers = headParameters;
//    request.postJSON = [params JSONString];
//    
//    [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
//        NSLog(@"__ message verify is %@",result[@"serviceResponse"][@"responseCode"]);
//        if ([result[@"serviceResponse"][@"responseCode"] isEqualToString:_responseCode_Msg_Done]) {
            NSLog(@"_卡号___ cardNo %@",self.cardNoTf.text);
            NSDictionary *params = [NSDictionary dictionary];
            if (kDeviceVersion>=7.0) {
                params = @{
                           @"custNo":[UserInfoSample shareInstance].userItems[@"uid"],
                           @"cardNo":self.cardNoTf.text,
                           @"actName":self.cardNameTf.text,
                           @"isBOCCard":@"true",
                           @"bankId":@"104",
                           @"relMobile":self.phoneNoTf.text,
                           @"validCode":self.codeTf.text,
                           @"certType":@"01",
                           @"certNo":self.idNoTf.text,
                           @"bindSrc":@"08",
                           @"validType":@"01",
                           @"authType":@"01",
                           @"authTerminal":@"01",
                           };
            }else{
                if ([self.cardNameTf.text isEqualToString:@""]) {
                    params = @{
                               @"custNo":[UserInfoSample shareInstance].userItems[@"uid"],
                               @"cardNo":self.cardNoTf.text,
                               @"actName":@"",
                               @"isBOCCard":@"true",
                               @"bankId":@"104",
                               @"relMobile":self.phoneNoTf.text,
                               @"validCode":self.codeTf.text,
                               @"certType":@"01",
                               @"certNo":self.idNoTf.text,
                               @"bindSrc":@"08",
                               @"validType":@"01",
                               @"authType":@"01",
                               @"authTerminal":@"01",};
                }
            }
            
            BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
            BindCardSubmitRequest *request = [BindCardSubmitRequest requestWithHeaders:nil];
            
            NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
            
            request.headers = headParameters;
            request.postJSON = [params JSONString];
            NSLog(@">>>> __ request json %@",request.postJSON);
            [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"____ suc %@_ ** status %@, errReason %@",result,result[@"status"],result[@"errReason"]);
                if (result[@"status"]) {
                    GOTO_NEXTVIEWCONTROLLER(AddSuccessViewController, @"AddSuccessViewController", @"AddSuccessViewController");
                }else{
                }
            }];
            
            [request onRequestFailWithError:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"____ fail %@_ ** status ",error);
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                [self showNBAlertWithAletTag:18 Title:@"温馨提示" content:[error userInfo][@"rtnmsg"] btnArray:arr];
            }];
            [request connect];

//        }else {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [MSUtil showHudMessage:result[@"serviceResponse"][@"responseMsg"] hideAfterDelay:1.5 uiview:self.view];
//        }
//    }];
//    
//    [request onRequestFailWithError:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        NSLog(@"错误信息 %@",[error userInfo]);
//        __Login_Invailid_;
//    }];
//    [request connect];
}

- (void)isNotBoc_requestSubmit
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *customerInfoDTO = @{@"relMobile":self.phoneNoTf.text,
                                      @"validCode":self.codeTf.text,};
    NSDictionary *params = @{@"customerInfoDTO":customerInfoDTO};
    
    BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
    VerifyMsgCodeRequest *request = [VerifyMsgCodeRequest requestWithHeaders:nil];
    
    NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
    request.headers = headParameters;
    request.postJSON = [params JSONString];
    
    [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
        NSLog(@"__ message verify is %@",result[@"serviceResponse"][@"responseCode"]);
        if ([result[@"serviceResponse"][@"responseCode"] isEqualToString:_responseCode_Msg_Done]) {
            NSLog(@"_卡号___ cardNo %@",self.cardNoTf.text);
            NSDictionary *params = [NSDictionary dictionary];
            
            if (kDeviceVersion>=7.0) {
                NSLog(@"bankId %@",notBocId);
                params = @{
                           @"custNo":[UserInfoSample shareInstance].userItems[@"uid"],
                           @"cardNo":self.cardNoTf.text,
                           @"actName":self.cardNameTf.text,
                           @"isBOCCard":@"false",
                           @"bankId":notBocId,
                           @"relMobile":self.phoneNoTf.text,
                           @"validCode":self.codeTf.text,
                           @"certType":@"01",
                           @"certNo":self.idNoTf.text,
                           @"bindSrc":@"08",
                           @"validType":@"01",
                           @"authType":@"01",
                           @"authTerminal":@"01",
                           };
            }else{
                if ([self.cardNameTf.text isEqualToString:@""]) {
                    params = @{@"custNo":[UserInfoSample shareInstance].userItems[@"uid"],
                               @"cardNo":self.cardNoTf.text,
                               @"actName":@"",
                               @"isBOCCard":@"false",
                               @"bankId":notBocId,
                               @"relMobile":self.phoneNoTf.text,
                               @"validCode":self.codeTf.text,
                               @"certType":@"01",
                               @"certNo":self.idNoTf.text,
                               @"bindSrc":@"08",
                               @"validType":@"01",
                               @"authType":@"01",
                               @"authTerminal":@"01",};
                }
            }
            
            BOCOPPayAuthorizeInfo *authorizeInfo = [BOCOPLogin sharedInstance].authInfo;
            BindCardSubmitRequest *request = [BindCardSubmitRequest requestWithHeaders:nil];
            
            NSMutableDictionary *headParameters = [NSMutableDictionary dictionaryWithDictionary:[request getBusinessRequestHeaderDictionary:authorizeInfo]];
            
            request.headers = headParameters;
            request.postJSON = [params JSONString];
            NSLog(@">>>> __ request json %@",request.postJSON);
            [request onRequestDidFinishLoadingWithResult:^(NSDictionary *result) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"____ suc %@_ ** status %@, errReason %@",result,result[@"status"],result[@"errReason"]);
                if (result[@"status"]) {
                    GOTO_NEXTVIEWCONTROLLER(AddSuccessViewController, @"AddSuccessViewController", @"AddSuccessViewController");
                }else{
                }
            }];
            
            [request onRequestFailWithError:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSLog(@"____ fail %@_ ** status ",result);
                NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];
                [self showNBAlertWithAletTag:18 Title:@"温馨提示" content:result[@"rtnmsg"] btnArray:arr];
            }];
            [request connect];
            
        }else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MSUtil showHudMessage:result[@"serviceResponse"][@"responseMsg"] hideAfterDelay:1.5 uiview:self.view];
        }
    }];
    
    [request onRequestFailWithError:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"错误信息 %@",[error userInfo]);
        __Login_Invailid_;
    }];
    [request connect];

}
@end

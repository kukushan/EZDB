//
//  PayViewController.h
//  EZDB
//
//  Created by wenming.zheng on 14/11/14.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "STViewController.h"
#import "BorderSetBtn.h"
//基金申购 输入支付密码和手机验证码页面
@interface PayViewController : STViewController <AfterSipDelegator,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CFCASip *passWordTextField; //支付密码
@property (weak, nonatomic) IBOutlet DBTextField *SMSCodeTextField;//短信验证码
@property (weak, nonatomic) IBOutlet BorderSetBtn *getSMSCodeButton;//获取


@property (copy, nonatomic) NSString *money;//传值的钱
@property (copy, nonatomic) NSString *cardSeq;//卡唯一标识
@property (copy, nonatomic) NSString *fundCode;//基金代码

@property (nonatomic,retain)NSString *serverRandNum;
@property (nonatomic,retain)NSString *pdResult;
@property (nonatomic,retain)NSString *randomResult;

@end

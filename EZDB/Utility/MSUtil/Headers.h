//
//  Headers.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-29.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#ifndef EZDB_Headers_h
#define EZDB_Headers_h

#import "DBTitleView.h"
#import "DBTextField.h"
#import "DBModalView.h"

#import "BOCOPLogin.h"
#import "BOCOPPayConstants.h"
#import "BOCOPLoginConstants.h"
#import "BOCOPPayDataRequest+HttpHeader.h"

#import "TabBarViewController.h"
#import "RootViewController.h"
#import "STViewController.h"
#import "EZDBAppDelegate.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"

#import "NavView.h"
#import "JSONKit.h"
#import "CONSTS.h"
#import "MSUtil.h"

#import "MBProgressHUD.h"
#import "UserInfoSample.h"
#import "NSTimer+Addition.h"
#import "UIImageView+WebCache.h"
//logo动画
#import "BOCHud.h"
//fileManager
#import "FileManager.h"

#define kBorderBackgroudColor [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1]
#define kRegBackGroudColor [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]
#define kBtnBackGroudColor [UIColor colorWithRed:165/255.0 green:0 blue:31/255.0 alpha:1]
#define kViewBackGroudColor [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]
//新添加颜色  只有颜色 如果有同一颜色不同深度 以hightlight区分
#define K204GrayColor [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define kBlackColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define kRedColor [UIColor colorWithRed:182/255.0 green:0 blue:42/255.0 alpha:1]
#define kRedHightColor [UIColor colorWithRed:230/255.0 green:0 blue:57/255.0 alpha:1]
#define kBLueColor [UIColor colorWithRed:0/255.0 green:78/255.0 blue:162/255.0 alpha:1]
#define kBtnBackGroudColor [UIColor colorWithRed:165/255.0 green:0 blue:31/255.0 alpha:1]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]

#define kNavbarHeight ((kDeviceVersion>=7.0)? 64 :44 )
#define IOS7DELTA   ((kDeviceVersion>=7.0)? 20 :0 )
#define kTabBarHeight 49
#define kCloseZero 0.000001f

#define _responseCode_Card_Done @"card.0000"
#define _responseCode_Banklimit_Done @"banklimit.0000"
#define _responseCode_Msg_Done @"msg.0000"
#define _responseCode_PayPwd_Done @"payPass.0000"
#define _responseCode_No_PayPwd @"payPass.0011"
#define _responseCode_Yes_PayPwd @"payPass.0010"


#define kNavBackImgName @"ico_back"
#define kNavHomeImgName @"ico_home"
#define kNavNoticeImgName @"ico_notice"
#define kHelpCenterTitle @"帮助中心"
#define kPerCenterTitle @"个人中心"
#define kBindCardTitle @"绑定银行卡"
#define kRegisterTitle @"注册"
#define kPurchaseTitle @"购买"
#define kSetPayPwdTitle @"设置支付密码"
#define kUpdPayPwdTitle @"修改支付密码"



#define IS_IPHONE5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )



#define DEFINE_CONTROLLERS(Controller,nav)\
UINavigationController *nav = nil;\
do { \
Controller *Ctr = [[Controller alloc]init];\
nav = [[UINavigationController alloc]initWithRootViewController:Ctr];\
}while(0)

#define GOTO_NEXTVIEWCONTROLLER(__targetViewController,__35nibName,__4nibName)\
do{\
__targetViewController *VC=nil;\
if (IS_IPHONE4) {\
VC = [[__targetViewController alloc]initWithNibName:__35nibName bundle:nil];\
}else if (IS_IPHONE5){\
VC = [[__targetViewController alloc]initWithNibName:__4nibName bundle:nil];\
}\
[self.navigationController pushViewController:VC animated:YES];\
}while(0)

#define __Login_Invailid_ \
do {\
if ([[error userInfo][@"error_code"]isEqualToString:@"ASR-000003"]||[[error userInfo][@"error_code"] isEqualToString:@"ASR-000005"]||[[error userInfo][@"error_code"] isEqualToString:@"invalid_token"]) {\
    [BOCOPLogin sharedInstance].isLogin = NO;\
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];\
    [self showNBAlertWithAletTag:111 Title:@"温馨提示" content:[error userInfo][@"error_description"] btnArray:arr];\
}else {\
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"确定", nil];\
    [self showNBAlertWithAletTag:112 Title:@"温馨提示" content:[error userInfo][@"error_description"] btnArray:arr];\
}\
}while(0)


//正则
#define MOBILE_REG "^1[0-9]{10}$"                                                   /* 手机号正则表达式     */
#define EMAIL_REG  "^[a-zA-Z0-9_+.-]{2,}@([a-zA-Z0-9-]+[.])+[a-zA-Z0-9]{2,4}$"      /* 邮箱正则表达式       */
#define USRNAM_REG "^[A-Za-z0-9_]{6,20}$"                                           /* 用户名正则表达式     */



#endif

//
//  PwdManageVController.h
//  EZDB
//
//  Created by wenming.zheng on 14/11/11.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "STViewController.h"

@interface PwdManageVController : STViewController

/* 先覆盖界面 */
@property (weak, nonatomic) IBOutlet UIView *coverView;

/* 支付密码按钮 */
@property (weak, nonatomic) IBOutlet UIButton *payPwdBtn;

@property (copy, nonatomic) NSString *nameStr;

@end

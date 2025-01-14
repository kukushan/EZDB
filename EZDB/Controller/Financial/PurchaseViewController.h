//
//  PurchaseViewController.h
//  EZDB
//
//  Created by wenming.zheng on 14/11/11.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "STViewController.h"
#import "PayViewController.h"

// 基金申购页面
@interface PurchaseViewController : STViewController<
                                    UITableViewDataSource,
                                    UITableViewDelegate,
                                    UITextFieldDelegate>

/* 协议勾选框 */
@property (weak, nonatomic) IBOutlet UIButton *signBtn;

@property (weak, nonatomic) IBOutlet DBTextField *moneyTf;

/* 选择银行卡 */
@property (weak, nonatomic) IBOutlet UIButton *chooseCard;

@property (strong,nonatomic)NSString * sumOfMoney;// 购买金额   从未支付详情进入时传值
@property (strong,nonatomic)NSString * cardInfo;// 支付方式   从未支付详情进入时传值

/** 基金代码 */
@property (strong,nonatomic)NSString * fundCode;

/** 协议按钮 */
@property (weak, nonatomic) IBOutlet UIButton *protocol;

/** 基金名字 */
@property (weak, nonatomic) IBOutlet UIButton *proName;

@end

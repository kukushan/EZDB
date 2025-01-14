//
//  RedeemViewController.h
//  EZDB
//
//  Created by wenming.zheng on 14/11/17.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "STViewController.h"

@interface RedeemViewController : STViewController
@property (weak, nonatomic) IBOutlet UILabel *fundNameLabel;//基金名字
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;//全部金额
@property (weak, nonatomic) IBOutlet UIButton *redeemRuleButton;//赎回规则
@property (weak, nonatomic) IBOutlet UIButton *redeemTypeButton;//赎回方式
@property (weak, nonatomic) IBOutlet UIButton *chooseBankCardButton;//选择银行卡
@property (weak, nonatomic) IBOutlet DBTextField *redeemMoneyTF;//赎回金额

- (IBAction)redeemAll:(id)sender;                           //全部赎回
- (IBAction)chooseBankCardAction:(id)sender;                //选择银行卡点击事件
- (IBAction)chooseRedeemTypeAction:(id)sender;              //选择赎回方式点击事件
- (IBAction)submitAction:(id)sender;                        //确定赎回点击事件


// 带入数据
@property(retain,nonatomic)NSString * fundName;//基金名字
@property(retain,nonatomic)NSString * allMoney;//全部金额
@property(retain,nonatomic)NSString * fundCode;//基金代码

@end

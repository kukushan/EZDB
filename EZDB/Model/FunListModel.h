//
//  FunListModel.h
//  EZDB
//
//  Created by wenming.zheng on 14-10-30.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunListModel : BOCOPPayBaseModelObject


/* 基金产品总条数 */
@property (nonatomic,assign)    NSInteger fundCount;

/* 基金代码 */
@property (nonatomic,copy)      NSString *fundCode;

/* 基金简称 */
@property (nonatomic,copy)      NSString *fnSNam;

/* 基金全称 */
@property (nonatomic,copy)      NSString *fnLNam;

/* 申购上限 */
@property (nonatomic,copy)      NSString *buyUplim;

/* 申购下限 */
@property (nonatomic,copy)      NSString *buyLowLim;

/* 货币基金七日年化收益 */
@property (nonatomic,copy)      NSString *yield;

/* 货币基金万份收益 */
@property (nonatomic,copy)      NSString *fundIncome;



@end

//
//  ChartData.h
//  EZDB
//
//  Created by wenming.zheng on 14/11/24.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "BOCOPPayBaseModelObject.h"

@interface ChartData : BOCOPPayBaseModelObject


/* 基金代码 */
@property (nonatomic,copy) NSString *fundCode;

/* 货币基金七日年化收益 */
@property (nonatomic,copy) NSString *yield;

/* 货币基金七日年化收益正负 */
@property (nonatomic,copy) NSString *yieldFlag;

/* 净值日期  */
@property (nonatomic,copy) NSString *navDate;

/* 货币基金万份收益 */
@property (nonatomic,copy) NSString *fundIncome;

/* 货币基金万份收益正负  */
@property (nonatomic,copy) NSString *fundIncomeFlag;




@end

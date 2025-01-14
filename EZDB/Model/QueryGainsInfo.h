//
//  QueryGainsInfo.h
//  EZDB
//
//  Created by wenming.zheng on 14-11-13.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//


#import "BOCOPPayBaseModelObject.h"

@interface QueryGainsInfo : BOCOPPayBaseModelObject

/** 七日年化收益率 */
@property (nonatomic, copy) NSString *yield;

/** 万份收益 */
@property (nonatomic, copy) NSString *fundincome;

/** 日期 */
@property (nonatomic, copy) NSString *currentdate;

/** 基金状态 */
@property (nonatomic, copy) NSString *fundstatus;

@end

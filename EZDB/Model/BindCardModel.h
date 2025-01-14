//
//  BindCardModel.h
//  EZDB
//
//  Created by wenming.zheng on 14-11-3.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindCardModel : BOCOPPayBaseModelObject

/** 客户号 */
@property (nonatomic,copy) NSString *custNo;

/** 证件号码 */
@property (nonatomic,copy) NSString *certNo;

/** 证件类型 */
@property (nonatomic,copy) NSString *certType;

/** 客户姓名 */
@property (nonatomic,copy) NSString *custName;

/** 手机号 */
@property (nonatomic,copy) NSString *relMobile;

/** 错误原因 */
@property (nonatomic,copy) NSString *errReason;

@end

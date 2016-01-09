//
//  FundListDataRequest.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-30.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "FundListDataRequest.h"

@implementation FundListDataRequest

- (NSString*)getURLString
{
    return BOCOPPAY_URL_FUNDLISTCHECK;

//  return @"http://openapi.boc.cn/ezdb/unlogin/fund/query_fund_list";
}

- (BOCOPPayHttpRequestMethod)getHttpMethod
{
    return BOCOPPayHttpRequestMethodPost;
}

@end

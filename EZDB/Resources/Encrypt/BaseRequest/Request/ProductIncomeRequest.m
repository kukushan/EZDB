//
//  ProductIncomeRequest.m
//  EZDB
//
//  Created by wenming.zheng on 14/11/21.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "ProductIncomeRequest.h"

@implementation ProductIncomeRequest

- (NSString*)getURLString
{
    return BOCOPPAY_URL_PRODUCT_INCOME;
}

- (BOCOPPayHttpRequestMethod)getHttpMethod
{
    return BOCOPPayHttpRequestMethodPost;
}

@end

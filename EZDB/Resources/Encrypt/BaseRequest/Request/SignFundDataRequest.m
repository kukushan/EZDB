//
//  SignFundDataRequest.m
//  EZDB
//
//  Created by wenming.zheng on 14/11/20.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "SignFundDataRequest.h"

@implementation SignFundDataRequest

- (NSString*)getURLString
{
    return BOCOPPAY_URL_SIGN_FUND;
}

- (BOCOPPayHttpRequestMethod)getHttpMethod
{
    return BOCOPPayHttpRequestMethodPost;
}

@end

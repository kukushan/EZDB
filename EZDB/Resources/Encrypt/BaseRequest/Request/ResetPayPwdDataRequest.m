//
//  ResetPayPwdDataRequest.m
//  EZDB
//
//  Created by wenming.zheng on 14-10-29.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "ResetPayPwdDataRequest.h"

@implementation ResetPayPwdDataRequest

- (NSString*)getURLString
{
    return BOCOPPAY_URL_RESETPAYPWD;
}

- (BOCOPPayHttpRequestMethod)getHttpMethod
{
    return BOCOPPayHttpRequestMethodPost;
}

@end

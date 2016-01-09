//
//  VerifyMsgCodeRequest.m
//  EZDB
//
//  Created by wenming.zheng on 14-11-3.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "VerifyMsgCodeRequest.h"

@implementation VerifyMsgCodeRequest

- (NSString*)getURLString
{
    return BOCOPPAY_URL_VERIFYCODE;
}

- (BOCOPPayHttpRequestMethod)getHttpMethod
{
    return BOCOPPayHttpRequestMethodPost;
}

@end
//
//  RedeemRequest.m
//  EZDB
//
//  Created by wenming.zheng on 14/11/20.
//  Copyright (c) 2014年 Pactera. All rights reserved.
//

#import "RedeemRequest.h"

@implementation RedeemRequest
- (NSString*)getURLString
{
    return BOCOPPAY_URL_REDEEM;
}

- (BOCOPPayHttpRequestMethod)getHttpMethod
{
    return BOCOPPayHttpRequestMethodPost;
}
@end
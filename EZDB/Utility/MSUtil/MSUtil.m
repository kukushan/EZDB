//
//  MSServiceContent.m
//  EggplantAlbums
//
//  Created by yeby on 13-8-6.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//
#define KFacialSizeWidth    32

#define KFacialSizeHeight   32

#define KCharacterWidth     8

#define VIEW_LINE_HEIGHT    32

#define VIEW_LEFT           0

#define VIEW_RIGHT          5

#define VIEW_TOP            8

#define VIEW_WIDTH_MAX      238

#define FACE_NAME_HEAD  @"["

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   4
#import "MSUtil.h"

#import "BOCOPLogin.h"

#import "MBProgressHUD.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>

#include <ctype.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <dirent.h>
#import <CommonCrypto/CommonDigest.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/sockio.h>

//#import "MobClick.h"
//#import "MessageView.h"
//#import "FaceBoard.h"

#define PATTERN_STR         @"\\[[^\\[\\]]*\\]"

@implementation MSUtil

+(NSDictionary*)dictionaryFromBundleWithName:(NSString*)fileName withType:(NSString*)typeName
{
    NSDictionary * dict = nil;
    NSString *infoPlist = [[NSBundle mainBundle] pathForResource:fileName ofType:typeName];

    if ([[NSFileManager defaultManager] isReadableFileAtPath:infoPlist]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:infoPlist];
        return dict;
    }
    return dict;
}


//MD5转换
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

+(void)removeLoadingViewAndLabelInView:(UIView*)viewToLoadData
{
    //viewToLoadData.hidden = NO;
    UIActivityIndicatorView * breakingLoadingView = (UIActivityIndicatorView*)[viewToLoadData  viewWithTag:10087];
    [breakingLoadingView stopAnimating];
    
    [[viewToLoadData  viewWithTag:10086] removeFromSuperview];
}

//推荐为10
+(void)addLoadingViewAndLabelInView:(UIView*)viewToLoadData
{
    [MSUtil addLoadingViewAndLabelInView:viewToLoadData usingOrignalYPosition:kScreenHeight];
}

+(void)addLoadingViewAndLabelInView:(UIView*)viewToLoadData usingOrignalYPosition:(CGFloat)yPosition
{
    //viewToLoadData.hidden = YES;
    
    UIView * loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, yPosition, viewToLoadData.frame.size.width , 60)];
    loadingView.tag = 10086;
    
    
    UIFont * labelFont = [UIFont systemFontOfSize:14.0f];
  
//    NSString *string = @"加载中";
    CGSize  labelSize = [@"加载中" sizeWithFont:labelFont];
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]};
//    CGSize labelSize = [string sizeWithAttributes:attributes];
    if (![viewToLoadData viewWithTag:10087]) {
        UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.frame = CGRectMake(( loadingView.frame.size.width - labelSize.width-20-5)/2, 15.0f, 20.0f, 20.0f);
        activityIndicatorView.tag = 10087;
        [loadingView addSubview:activityIndicatorView];
          [activityIndicatorView startAnimating];
    }

    
    if (![viewToLoadData viewWithTag:10088]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([loadingView viewWithTag:10087] .frame.origin.x + 20+5, 10.0f, labelSize.width, 30.0f)];
        label.tag = 10088;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = labelFont;
        label.textColor = [UIColor whiteColor];
        // label.shadowColor = [UIColor colorWithWhite:.9f alpha:1.0f];
        //label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = UITextAlignmentLeft;
        label.text = @"加载中";
        [loadingView addSubview:label];
    }
    [viewToLoadData addSubview:loadingView];
  
}



#pragma mark - Only ActivityView

+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle usingColor:(UIColor*)color
{
    UIActivityIndicatorView * breakingLoadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:aStyle];
    breakingLoadingView.tag = 99;
    breakingLoadingView.center = CGPointMake( (viewToLoadData.frame.size.width-40)/2+20, (viewToLoadData.frame.size.height-40)/2+20);
    breakingLoadingView.color = color;
    [breakingLoadingView startAnimating];
    [viewToLoadData addSubview:breakingLoadingView];
    
    
}


+(void)addLoadingViewInView:(UIView*)viewToLoadData usingUIActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)aStyle
{

    [self addLoadingViewInView:viewToLoadData usingUIActivityIndicatorViewStyle:aStyle usingColor:[UIColor redColor]];
}

+(void)removeLoadingViewInView:(UIView*)viewToLoadData
{
    UIActivityIndicatorView * breakingLoadingView = (UIActivityIndicatorView*)[viewToLoadData  viewWithTag:99];
    [breakingLoadingView stopAnimating];
    [breakingLoadingView removeFromSuperview];
}


+(NSDictionary * )getURLs
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPaht=[paths objectAtIndex:0];
    
    //取得完整的文件名
    NSString *fileName=[plistPaht stringByAppendingString:@"/apiPages.plist"];
    
    //MSDebug(@"%@",);
    return [NSDictionary dictionaryWithContentsOfFile:fileName];
}


+ (NSDate *)getNowTime
{
    return [NSDate date];
}
+(NSString *)getyyyymmdd{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyyMMdd";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;

}
+(NSString *)gethhmmss{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatTime = [[NSDateFormatter alloc] init];
    formatTime.dateFormat = @"HHmmss";
    NSString *timeStr = [formatTime stringFromDate:now];
    
    return timeStr;

}
+(NSDictionary *)getHeaders
{
    NSDictionary *headers = @{@"clentid":kAppBopKey,
                              @"userid":[BOCOPLogin sharedInstance].userName,
                              @"chnflg":@"1",
                              @"trandt":[MSUtil getyyyymmdd],
                              @"trantm":[MSUtil gethhmmss],
                              @"cookie":@"",
                              @"uuid":@""};
    return headers;
}

+ (void)showTipsWithHUD:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[[[UIApplication sharedApplication] delegate] window]] ;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = labelText;
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}

+ (void)showTipsWithView:(UIView *)uiview labelText:(NSString *)labelText showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:uiview] ;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = labelText;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [uiview addSubview:hud];
    
    [hud hide:YES afterDelay:time];
}
+ (void)showProgessInView:(UIView *)view withExtBlock:(void (^)())exBlock withComBlock:(void (^)())comBlock
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    hud.color = [UIColor colorWithWhite:0.8 alpha:0.6];
    //    hud.dimBackground = NO;
    [view addSubview:hud];
    hud.dimBackground = YES;
    hud.labelText = @"正在加载...";
    if (exBlock) {
        [hud showAnimated:YES whileExecutingBlock:exBlock completionBlock:^{
            if (comBlock) {
                comBlock();
            }
            [hud removeFromSuperview];
        }];
        
    }else
        [hud showAnimated:YES whileExecutingBlock:exBlock completionBlock:^{
            [hud removeFromSuperview];
        }];
}

+ (void) showHudMessage:(NSString*) msg hideAfterDelay:(NSInteger) sec uiview:(UIView *)uiview
{
    
    MBProgressHUD* hud2 = [MBProgressHUD showHUDAddedTo:uiview animated:YES];
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = msg;
    hud2.margin = 12.0f;
    hud2.yOffset = 20.0f;
    hud2.removeFromSuperViewOnHide = YES;
    [hud2 hide:YES afterDelay:sec];
}


+ (NetworkStatus)getCurrentNetworkStatusForLocal
{
    Reachability *tempReach = [Reachability reachabilityForInternetConnection];
    [tempReach startNotifier];
    
    return tempReach.currentReachabilityStatus;
}

+ (void)showNotReachabileTips
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"与服务端连接已断开,请检查您的网络连接是否正常."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

+(NSDate *)dateFromString:(NSString *)dateString usingFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;

}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSString *)stringFromDate:(NSDate *)date usingFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
+ (NSString *)getDeviceOSType
{
    NSString *systemVersion =  [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]];
	return systemVersion;
}
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation //图片旋转
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//将图片保存到应用程序沙盒中去,imageNameString的格式为 @"upLoad.png"
+ (void)saveImagetoLocal:(UIImage*)image imageName:(NSString *)imageNameString 
{
    if (image == nil || imageNameString.length == 0) {
        return;
    }
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *saveImagePath=[documentsDirectory stringByAppendingPathComponent:imageNameString];
    NSData *imageDataJPG=UIImageJPEGRepresentation(image, 0);//将图片大小进行压缩
//    NSData *imageData=UIImagePNGRepresentation(image);
    [imageDataJPG writeToFile:saveImagePath atomically:YES];
}

+ (NSString *)getFlag
{
    return @"xxx";
}
//md5转换
+ (NSString *) fileMd5sum:(NSString * )filename
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filename];
    if( handle== nil ) {
		return nil;
	}
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
	
	return s;
}


#pragma mark - 将字符串中的文字和表情解析出来
+ (NSMutableArray *)decorateString:(NSString *)string
{
    NSMutableArray *array =[NSMutableArray array];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:PATTERN_STR
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:string options:0
                                       range:NSMakeRange(0, [string length])];
    NSMutableArray *matchRanges = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in chunks) {
        NSString *resultStr = [string substringWithRange:[result range]];
        
        if ([resultStr hasPrefix:@"["] && [resultStr hasSuffix:@"]"]) {
            NSString *name = [resultStr substringWithRange:NSMakeRange(1, [resultStr length]-2)];
            name=[NSString stringWithFormat:@"[%@]",name];
            NSLog(@"name:%@",name);
            NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
            if ([[faceMap allValues] containsObject:name]) {
                //                [array addObject:name];
                [matchRanges addObject:[NSValue valueWithRange:result.range]];
            }
        }
    }
    
    NSRange r = NSMakeRange([string length], 0);
    [matchRanges addObject:[NSValue valueWithRange:r]];
    
    NSUInteger lastLoc = 0;
    for (NSValue *v in matchRanges) {
        
        NSRange resultRange = [v rangeValue];
        if (resultRange.location==0) {
            NSString *faceString = [string substringWithRange:resultRange];
            NSLog(@"aaaaaaaaa:faceString:%@",faceString);
            if (faceString.length!=0) {
                [array addObject:faceString];
            }
            
            NSRange normalStringRange = NSMakeRange(lastLoc, resultRange.location - lastLoc);
            NSString *normalString = [string substringWithRange:normalStringRange];
            lastLoc = resultRange.location + resultRange.length;
            NSLog(@"aaaaaaa:normalString:%@",normalString);
            if (normalString.length!=0) {
                [array addObject:normalString];
            }
        }else{
            NSRange normalStringRange = NSMakeRange(lastLoc, resultRange.location - lastLoc);
            NSString *normalString = [string substringWithRange:normalStringRange];
            lastLoc = resultRange.location + resultRange.length;
            NSLog(@"bbbbbbb:normalString:%@",normalString);
            if (normalString.length!=0) {
                [array addObject:normalString];
            }
            
            NSString *faceString = [string substringWithRange:resultRange];
            NSLog(@"bbbbbbbb:faceString:%@",faceString);
            if (faceString.length!=0) {
                [array addObject:faceString];
            }
        }
    }
    if ([matchRanges count]==0) {
        if (string.length!=0) {
            [array addObject:string];
        }
    }
    NSLog(@"array:%@",array);
    
    return array;
}

#pragma mark - 获取文本尺寸
/*
+ (CGFloat)getContentSize:(NSArray *)messageRange
{    
    @synchronized ( self ) {
        CGFloat upX;
        
        CGFloat upY;
        
        CGFloat lastPlusSize;
        
        CGFloat viewWidth;
        
        CGFloat viewHeight;
        
        BOOL isLineReturn;
        
        //        RelayBottleList *mineBottleListObject = [relayBottleArray objectAtIndex:indexPath.row];
        //        NSArray *messageRange = mineBottleListObject.messageRange;
        
        NSDictionary *faceMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
        
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        
        isLineReturn = NO;
        
        upX = VIEW_LEFT;
        upY = VIEW_TOP;
        
        for (int index = 0; index < [messageRange count]; index++) {
            
            NSString *str = [messageRange objectAtIndex:index];
            if ( [str hasPrefix:FACE_NAME_HEAD] ) {
                
                //NSString *imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                
                NSArray *imageNames = [faceMap allKeysForObject:str];
                NSString *imageName = nil;
                NSString *imagePath = nil;
                
                if ( imageNames.count > 0 ) {
                    
                    imageName = [imageNames objectAtIndex:0];
                    imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
                }
                
                if ( imagePath ) {
                    
                    if ( upX > ( VIEW_WIDTH_MAX - KFacialSizeWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    
                    upX += KFacialSizeWidth;
                    
                    lastPlusSize = KFacialSizeWidth;
                }
                else {
                    
                    for ( int index = 0; index < str.length; index++) {
                        
                        NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                        
                        CGSize size = [character sizeWithFont:font
                                            constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                        
                        if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
                            
                            isLineReturn = YES;
                            
                            upX = VIEW_LEFT;
                            upY += VIEW_LINE_HEIGHT;
                        }
                        
                        upX += size.width;
                        
                        lastPlusSize = size.width;
                    }
                }
            }
            else {
                
                for ( int index = 0; index < str.length; index++) {
                    
                    NSString *character = [str substringWithRange:NSMakeRange( index, 1 )];
                    
                    CGSize size = [character sizeWithFont:font
                                        constrainedToSize:CGSizeMake(VIEW_WIDTH_MAX, VIEW_LINE_HEIGHT * 1.5)];
                    
                    if ( upX > ( VIEW_WIDTH_MAX - KCharacterWidth ) ) {
                        
                        isLineReturn = YES;
                        
                        upX = VIEW_LEFT;
                        upY += VIEW_LINE_HEIGHT;
                    }
                    
                    upX += size.width;
                    
                    lastPlusSize = size.width;
                }
            }
        }
        
        if ( isLineReturn ) {
            
            viewWidth = VIEW_WIDTH_MAX + VIEW_LEFT * 2;
        }
        else {
            
            viewWidth = upX + VIEW_LEFT;
        }
        
        viewHeight = upY + VIEW_LINE_HEIGHT + VIEW_TOP;
        
        NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake( viewWidth, viewHeight )];
        NSLog(@"%@",sizeValue);
        //        [sizeList setObject:sizeValue forKey:indexPath];
        //        [sizeList addObject:sizeValue];
        return viewHeight;
    }
}
*/
//正则表达式判断～～～
//#define MOBILE_REG "^1[0-9]{10}$"                                                /* 手机号正则表达式     */
//#define EMAIL_REG  "^[a-zA-Z0-9_+.-]{2,}@([a-zA-Z0-9-]+[.])+[a-zA-Z0-9]{2,4}$"    /* 邮箱正则表达式       */
//#define USRNAM_REG "^[A-Za-z0-9_]{6,20}$"                                         /* 用户名正则表达式     */

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";

    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//用户名
+ (BOOL) validateUserName:(NSString *)name
{
//    NSString *userNameRegex = @"^[A-Za-z0-9]{4,20}+$";
    NSString *userNameRegex = @"^[A-Za-z0-9_]{6,20}$";

    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,5})(&middot;[\u4e00-\u9fa5]{2,5})*";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber
{
    BOOL flag;
    if (bankCardNumber.length != 4) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
//CVN
+ (BOOL) validateCVNCode: (NSString *)cvnCode
{
    BOOL flag;
    if (cvnCode.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{3})";
    NSPredicate *cvnCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [cvnCodePredicate evaluateWithObject:cvnCode];
}
//month
+ (BOOL) validateMonth: (NSString *)month
{
    BOOL flag;
    if (!month.length == 2) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"(^(0)([0-9])$)|(^(1)([0-2])$)";
    NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [monthPredicate evaluateWithObject:month];
}
//year
+ (BOOL) validateYear: (NSString *)year
{
    BOOL flag;
    if (!year.length == 2) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([1-3])([0-9])$";
    NSPredicate *yearPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [yearPredicate evaluateWithObject:year];
}
//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode
{
    BOOL flag;
    if (!verifyCode.length == 6) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{6})";
    NSPredicate *verifyCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [verifyCodePredicate evaluateWithObject:verifyCode];
}

+ (void)judgeBankIDWith:(NSString *)str img:(UIImageView *)img
{
    if ([str isEqualToString:@"104"]) {
        //    101　　　　　　　中国银行
        img.image = [UIImage imageNamed:@"ico_boc.png"];
        
    }else if ([str isEqualToString:@"105"]){
        //    CCB　　　　　　　建设银行
        img.image = [UIImage imageNamed:@"ico_ccb.png"];
        
    }else if ([str isEqualToString:@"309"]){
        //    CIB　　　　　　　兴业银行
        img.image = [UIImage imageNamed:@"ico_cib.png"];
        
    }else if ([str isEqualToString:@"103"]){
        //    ABOC　　　　　　农业银行
        img.image = [UIImage imageNamed:@"ico_abc.png"];
        
    }else if ([str isEqualToString:@"102"]){
        //    ICBC          工商银行
        img.image = [UIImage imageNamed:@"ico_icbc.png"];
        
    }else if ([str isEqualToString:@"303"]){
        //    CEB           光大银行
        img.image = [UIImage imageNamed:@"ico_ceb.png"];
        
    }else if ([str isEqualToString:@"302"]){
        //    CCBK　　　　　　中信银行
        img.image = [UIImage imageNamed:@"ico_citic.png"];
        
    }else if ([str isEqualToString:@"SPDB"]){
        //    SPDB　　　　　　浦发银行
        img.image = [UIImage imageNamed:@"ico_spdb.png"];
    }
}

+ (void)judgeBankLogoWith:(NSString *)str img:(UIImageView *)img
{
    if ([str isEqualToString:@"104"]) {
        //    101　　　　　　　中国银行
        img.image = [UIImage imageNamed:@"logo_boc.png"];
        
    }else if ([str isEqualToString:@"105"]){
        //    CCB　　　　　　　建设银行
        img.image = [UIImage imageNamed:@"logo_ccb.png"];
        
    }else if ([str isEqualToString:@"309"]){
        //    CIB　　　　　　　兴业银行
        img.image = [UIImage imageNamed:@"logo_cib.png"];
        
    }else if ([str isEqualToString:@"103"]){
        //    ABOC　　　　　　农业银行
        img.image = [UIImage imageNamed:@"logo_abc.png"];
        
    }else if ([str isEqualToString:@"102"]){
        //    ICBC          工商银行
        img.image = [UIImage imageNamed:@"logo_icbc.png"];
        
    }else if ([str isEqualToString:@"303"]){
        //    CEB           光大银行
        img.image = [UIImage imageNamed:@"logo_ceb.png"];
        
    }else if ([str isEqualToString:@"302"]){
        //    CCBK　　　　　　中信银行
        img.image = [UIImage imageNamed:@"logo_citic.png"];
        
    }else if ([str isEqualToString:@"SPDB"]){
        //    SPDB　　　　　　浦发银行
        img.image = [UIImage imageNamed:@"logo_spdb.png"];
    }
}
//加载XIB
+(id)loadFromXIB:(NSString *)XIBName{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:XIBName owner:nil options:nil];
    if (array && [array count]) {
        return array[0];
    }else {
        return nil;
    }
}
+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }else {
            p++;
        }
    }
    return strlength;
}

- (int)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

@end

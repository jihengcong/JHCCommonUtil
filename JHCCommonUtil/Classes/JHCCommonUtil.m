//
//  JHCCommonUtil.m
//  JHCCommonUtil
//
//  Created by 冀恒聪 on 2022/1/13.
//

#import "JHCCommonUtil.h"


@implementation JHCCommonUtil

/*
 @method
 @abstract 判断字符串是否为空或nil
 @param str 要判断的字符串
 @result YES 字符串为nil或空  NO 字符串非空
 */
+ (BOOL)isStringNilOrEmpty:(NSString *)str
{
    if(str == nil || [@"" isEqualToString:str] || [@"(null)" isEqualToString:str] || [str isEqual:[NSNull null]]){
        return YES;
    }else{
        return NO;
    }
}

/*
 @method
 @abstract 手机号码合法型正则表达式判断
 @param phoneNumber 要判断的字符串
 @result YES 合法  NO 不合法
 */
+ (BOOL)isValidatePhoneNum:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((1(3|4|5|6|7|8|9)[0-9]))\\d{8}$";//@"\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{11}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

/*
@method
@abstract 身份证合法型正则表达式判断
@param identifierNumber 要判断的字符串
@result YES 合法  NO 不合法
*/
+ (BOOL)isValidateIdentifierNum:(NSString *)identifierNumber
{
    if (identifierNumber.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identifierNumber]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identifierNumber substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identifierNumber substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        
        if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return YES;
        }else
        {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

/*
 @method
 @abstract 密码合法型正则表达式判断
 @param password 要判断的字符串
 @result YES 合法  NO 不合法
 */
+ (BOOL)isValidatePassword:(NSString *)password
{
    return (password.length>=8 && password.length<=20);
}

/** 是否是中文 */
+ (BOOL)isChineseWord:(NSString *)word
{
    NSString *regularStr = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularStr];
    
    if ([regextestA evaluateWithObject:word] == YES)
    {
        return YES;
    }
    return NO;
}

-(BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string;
{
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
            return NO;
    }
    return YES;
}

/*
 * 是否包含emoji
 */
+ (BOOL)isContainEmoji:(NSString *)string
{
    BOOL isEmoji = NO;
    for (NSInteger i = 0; i < string.length; i++)
    {
        unichar hs = [string characterAtIndex:i];
        if (0xd800 <= hs && hs <= 0xdbff)
        {
            if (string.length > 1)
            {
                unichar ls = [string characterAtIndex:i+1];
                int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f)
                {
                    return YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b)
            {
                return YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                return YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                return YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                return YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                return YES;
            }
            if (!isEmoji && string.length > 1 && i < string.length -1) {
                unichar ls = [string characterAtIndex:i+1];
                if (ls == 0x20e3) {
                    return YES;
                }
            }
        }
    }
    return isEmoji;
}


// 根据钱包地址生成二维码
+ (UIImage *)createAddressQcodeWithOriginText:(NSString *)originText
{
    //1.将字符串转出NSData
    NSData *img_data = [originText dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.将字符串变成二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //  条形码 filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    //3.恢复滤镜的默认属性
    [filter setDefaults];
    
    //4.设置滤镜的 inputMessage
    [filter setValue:img_data forKey:@"inputMessage"];
    
    //5.获得滤镜输出的图像
    CIImage *img_CIImage = [filter outputImage];
    
    //6.此时获得的二维码图片比较模糊，通过下面函数转换成高清
    UIImage *qcodeImage = [self changeImageSizeWithCIImage:img_CIImage andSize:150];
    
    return qcodeImage;
}

// 拉伸二维码图片，使其清晰
+ (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

// 根据现在的时间格式生成指定的时间格式
+ (NSString *)createTimeString:(NSString *)timeString targetFormatter:(NSString *)targetFormatter currentFormatter:(NSString *)currentFormatter
{
    // 当前日期转化 NSString to NSDate
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:currentFormatter];
    NSDate * date = [formatter dateFromString:timeString];
    
    // 转换成目标格式
    [formatter setDateFormat:targetFormatter];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

// 根据UTC时间格式生成本地指定的时间格式
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcStr
{
    NSString *millonSecond = @"";
    if ([JHCCommonUtil isStringNilOrEmpty:utcStr]) return millonSecond;
    if ([utcStr containsString:@"."]) {
        NSArray *array = [utcStr componentsSeparatedByString:@"."];
        millonSecond = [NSString stringWithFormat:@".%@", array[1]];
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = [NSString stringWithFormat:@"%@%@", @"yyyy-MM-dd'T'HH:mm:ss", millonSecond];
    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    NSDate *utcDate = [format dateFromString:utcStr];
    format.timeZone = [NSTimeZone localTimeZone];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [format stringFromDate:utcDate];
    return dateString;
}


/**
 * @brief 根据日期返回对应格式的字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)dateFormat
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    outputFormatter.dateFormat = dateFormat;
    outputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    return [outputFormatter stringFromDate:date];
}

/**
 * @brief 返回当前日期的format格式化时间
 */
+ (NSString *)currentDateStringWithFormat:(NSString *)dateFormat
{
    NSDate *currentDate = [self currentDate];
    return [self stringWithDate:currentDate format:dateFormat];
}

#pragma mark - 返回当前时间
+ (NSDate *)currentDate
{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

//获取当前时间戳字符串 10位
+ (NSString *)getTimestampSince1970
{
    NSDate *datenow = [NSDate date];//现在时间
    NSTimeInterval interval = [datenow timeIntervalSince1970];//13位的*1000
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",interval];
    return timeSp;
}

// 根据指定的格式把时间戳改为日期
+ (NSString *)getDateStringWithFormat:(NSString *)dateFormat timeStamp:(NSString *)timeStamp
{
    timeStamp = @(timeStamp.doubleValue).stringValue;
    if (timeStamp.length == 13)
    {
        timeStamp = [timeStamp substringWithRange:NSMakeRange(0, 10)];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

// 根据指定的时间和倒计时时间，返回时间差
+ (NSTimeInterval)differTimeSinceNowWithTargetTime:(NSString *)targetTime keepTime:(NSTimeInterval)keepTime
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *targetDate=[date dateFromString:targetTime];
    NSTimeInterval targetLate=[targetDate timeIntervalSince1970]*1;

    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [nowDate timeIntervalSince1970]*1;
    
    NSTimeInterval diff = now - targetLate;
    
    if (diff > keepTime) { // 超过倒计时时间
        return 0;
    }
    
    NSTimeInterval last = keepTime - diff;
    return last;
}

/**
 * 获取距离指定时间之后某个时间
 */
+ (NSString *)getLaterTimeWithCurrentTime:(NSString *)currentTime afterTime:(NSTimeInterval)afterTime
{
    // 格式化当前时间
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.000"];
    NSDate *currentDate = [date dateFromString:currentTime];
    
    NSDate *afterDate = [NSDate dateWithTimeInterval:afterTime sinceDate:currentDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:afterDate];
    return dateString;
}


// 压缩图片尺寸
+ (UIImage *)compressionImage:(UIImage *)image size:(CGSize)size
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    UIImage *resultImage = [UIImage imageWithData:data];
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

// 压缩图片体积
+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage
{
    //进行图像的画面质量压缩
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(sourceImage, compression);
    NSInteger maxLength = 0.2* 1024 * 1024;//图片不大于200k
    while (data.length > maxLength && compression > 0) {
        compression -= 0.02;
        data = UIImageJPEGRepresentation(sourceImage, compression);
        // When compression less than a value, this code dose not work
    }
    return data;
}

// 创建一张纯色图片
+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// 创建一张渐变色图片
+ (UIImage *)createImageSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(JHCGradientType)gradientType
{
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    //    NSUInteger capacity = percents.count;
    //    CGFloat locations[capacity];
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case JHCGradientType_TopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case JHCGradientType_LeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case JHCGradientType_LeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case JHCGradientType_LeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)circleImageWithOriginImage:(UIImage *)originImage
{
    // 1.开启上下文
    CGFloat imageW = originImage.size.width;
    CGFloat imageH = originImage.size.height;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 2.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = imageW * 0.5; // 圆心
    CGFloat centerY = imageH * 0.5;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    // 4.小圆
    CGFloat smallRadius = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [originImage drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height)];
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 8.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)circleImageWithOriginImage:(UIImage *)originImage cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = (CGRect){0.f, 0.f, originImage.size.width, originImage.size.width};
    // size——同UIGraphicsBeginImageContext,参数size为新创建的位图上下文的大小
    // opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
    // scale—–缩放因子
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(originImage.size.width, originImage.size.width), NO, 0);
    // 根据矩形画带圆角的曲线
    
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [originImage drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}


/*
@method
@abstract 获取当前跟控制器
@result 顶层控制器
*/
+ (UIViewController *)getCurrentTopViewController
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    //从根控制器开始查找
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activityVC = nil;
    
    while (true) {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            activityVC = [(UINavigationController *)rootVC visibleViewController];
        } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
            activityVC = [(UITabBarController *)rootVC selectedViewController];
        } else if (rootVC.presentedViewController) {
            activityVC = rootVC.presentedViewController;
        }else {
            break;
        }
        rootVC = activityVC;
    }
    return activityVC;
}

/*!
@method
@abstract 获取当前窗口的控制器
*/
+ (UIViewController *)getRootViewController
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    //从根控制器开始查找
    UIViewController *rootVC = window.rootViewController;
    return rootVC;
}

// tabbar的选中
+ (void)tabbarSelectIndexWith:(NSInteger)index
{
    UITabBarController *TabBarController = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([TabBarController.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
       BOOL select =  [TabBarController.delegate tabBarController:TabBarController shouldSelectViewController:TabBarController.viewControllers[index]];
        if (select)
        {
            TabBarController.selectedIndex = index;
        }
    }
}

// NSData转Hex
+ (NSString *)hexStringFromData:(NSData *)data
{
    return [NSString stringWithFormat:@"0x%@", [self hexStringFromDataWithout0x:data]];
}

+ (NSString *)hexStringFromDataWithout0x:(NSData *)data
{
    Byte *bytes = (Byte *)[data bytes];
    //下面是Byte转换为16进制。
    NSString *hexStr = @"";
    for (int i = 0; i < [data length]; i ++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];///16进制数
        if ([newHexStr length] == 1)
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr, newHexStr];
    }
    return hexStr;
}


// Hex转NSData
+ (NSData*)dataWithHexString:(NSString*)hexStr
{
    if (!hexStr || [hexStr length] == 0) return nil;
    
    if ([hexStr hasPrefix:@"0x"]) {
        hexStr = [hexStr substringFromIndex:2];
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([hexStr length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [hexStr length]; i += 2)
    {
        unsigned int anInt;
        NSString *hexCharStr = [hexStr substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        NSString *hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

// 十六进制转二进制
+ (NSString *)getBinaryByHex:(NSString *)hex
{
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    if ([hex hasPrefix:@"0x"]) hex = [hex substringFromIndex:2];
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}

// 十进制转二进制
+ (NSString *)getBinaryByDecimal:(NSInteger)num
{
    NSInteger remainder = 0;      //余数
    NSInteger divisor = 0;        //除数
    NSString * prepare = @"";
    while (true){
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",remainder];
        if (divisor == 0){
            break;
        }
    }
    while (prepare.length < 11) { // 不够11位，补齐0
        prepare = [prepare stringByAppendingString:@"0"];
    }
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --){
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    return result;
}

// 二进制转十六进制
+ (NSString *)getHexByBinary:(NSString *)binary
{
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0)
    {
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}


/**
 *  计算富文本字体高度
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 */
+ (CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width originText:(NSString *)originText
{
    if ([self isStringNilOrEmpty:originText]) return 0.f;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpeace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.2};
    CGSize size = [originText boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

/** html文字富文本, 行间距默认是10 */
+ (NSMutableAttributedString *)getHtmlStringWithString:(NSString *)string font:(UIFont *)font
{
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)};
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
    // 设置段落格式
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = 10;
    [attStr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attStr.length)];
    // 设置文本的Font
    [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attStr.length)];
    
    return attStr;
}

/** 文字富文本, 行间距默认是8 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string
{
    return [self getAttributedStringWithString:string lineSpace:8];
}

/** 文字富文本, 自定义行间距 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(NSInteger)lineSpace
{
    if ([self isStringNilOrEmpty:string]) string = @"";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSKernAttributeName value:@1.2 range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

/** 文字富文本, 自定义行间距和文字位置 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(NSInteger)lineSpace alignment:(NSTextAlignment)alignment
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [paragraphStyle setAlignment:alignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

@end

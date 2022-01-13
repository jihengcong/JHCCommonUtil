//
//  JHCCommonUtil.h
//  JHCCommonUtil
//
//  Created by 冀恒聪 on 2022/1/13.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHCGradientType)
{
    JHCGradientType_TopToBottom = 0,
    JHCGradientType_LeftToRight,
    JHCGradientType_LeftTopToRightBottom,
    JHCGradientType_LeftBottomToRightTop
};

@interface JHCCommonUtil : NSObject

/*
 @method
 @abstract 判断字符串是否为空或nil
 @param str 要判断的字符串
 @result YES 字符串为nil或空  NO 字符串非空
 */
+ (BOOL)isStringNilOrEmpty:(NSString *)str;

/** 是否包含中文 */
+ (BOOL)isChineseWord:(NSString *)word;

/*
 @method
 @abstract 手机号码合法型正则表达式判断
 @param phoneNumber 要判断的字符串
 @result YES 合法  NO 不合法
 */
+ (BOOL)isValidatePhoneNum:(NSString *)phoneNumber;

/*
@method
@abstract 身份证合法型正则表达式判断
@param identifierNumber 要判断的字符串
@result YES 合法  NO 不合法
*/
+ (BOOL)isValidateIdentifierNum:(NSString *)identifierNumber;


/*
 @method
 @abstract 密码合法型正则表达式判断
 @param password 要判断的字符串
 @result YES 合法  NO 不合法
 */
+ (BOOL)isValidatePassword:(NSString *)password;

/*
 * 是否包含emoji
 */
+ (BOOL)isContainEmoji:(NSString *)string;


// 根据钱包地址生成二维码
+ (UIImage *)createAddressQcodeWithOriginText:(NSString *)originText;

/*
 * 根据现在的时间格式生成指定的时间格式
 * @"yyyy-MM-dd HH:mm:ss" == > @"HH:mm MM/dd"
*/
+ (NSString *)createTimeString:(NSString *)timeString targetFormatter:(NSString *)targetFormatter currentFormatter:(NSString *)currentFormatter;

/**
 * 根据UTC时间格式生成本地指定的时间格式
 */
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcStr;

/**
 * @brief 根据日期返回对应格式的字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)dateFormat;

/**
 * @brief 返回当前日期的format格式化时间
 */
+ (NSString *)currentDateStringWithFormat:(NSString *)dateFormat;

/**
 * @brief 根据指定的格式把时间戳改为日期
 */
+ (NSString *)getDateStringWithFormat:(NSString *)dateFormat timeStamp:(NSString *)timeStamp;


/**
 * @brief 获取当前时间
 */
+ (NSString *)currentDate;

/**
 * @brief 获取当前时间戳字符串 10位
 */
+ (NSString *)getTimestampSince1970;

/**
 * @brief 根据指定的时间和倒计时时间，返回时间差
 * targetTime: 距离指定的时间，过去的某个时间
 * keepTime: 倒计时的时间，比如15分钟,需换算成秒
 */
+ (NSTimeInterval)differTimeSinceNowWithTargetTime:(NSString *)targetTime keepTime:(NSTimeInterval)keepTime;

/**
 * 获取距离指定时间之后某个时间
 */
+ (NSString *)getLaterTimeWithCurrentTime:(NSString *)currentTime afterTime:(NSTimeInterval)afterTime;


/*
 * 压缩图片尺寸
*/
+ (UIImage *)compressionImage:(UIImage *)image size:(CGSize)size;

/*
 * 压缩图片体积
*/
+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;

/*
 * 创建一张纯色图片
*/
+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size;

/*
 * 创建一张渐变色图片
*/
+ (UIImage *)createImageSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(JHCGradientType)gradientType;


/*
 * 图片切圆
 * originImage: 原图
*/
+ (UIImage *)circleImageWithOriginImage:(UIImage *)originImage;

/*
 * 图片切圆
 * originImage: 原图
 * cornerRadius: 圆角度数
*/
+ (UIImage *)circleImageWithOriginImage:(UIImage *)originImage cornerRadius:(CGFloat)cornerRadius;

/*
@method
@abstract 获取当前跟控制器
@result 顶层控制器
*/
+ (UIViewController *)getCurrentTopViewController;

/*
@method
@abstract 获取当前窗口的控制器
*/
+ (UIViewController *)getRootViewController;


/*
@method
@abstract tabbar的选中
*/
+ (void)tabbarSelectIndexWith:(NSInteger)index;


/*
@method
@abstract NSData转Hex, 0x开头
*/
+ (NSString *)hexStringFromData:(NSData *)data;
+ (NSString *)hexStringFromDataWithout0x:(NSData *)data;


/*
@method
@abstract Hex转NSData
*/
+ (NSData*)dataWithHexString:(NSString*)hexStr;

/*
@method
@abstract 十六进制转换为普通字符串的。
*/
+ (NSString *)stringFromHexString:(NSString *)hexString;

/** 十进制转二进制 */
+ (NSString *)getBinaryByDecimal:(NSInteger)num;

/** 十六进制转二进制 */
+ (NSString *)getBinaryByHex:(NSString *)hex;

/** 二进制转十六进制 */
+ (NSString *)getHexByBinary:(NSString *)binary;

/**
 *  计算富文本字体高度
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 */
+ (CGFloat)getSpaceLabelHeightwithSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width originText:(NSString *)originText;

/** html文字富文本, 行间距默认是8 */
+ (NSMutableAttributedString *)getHtmlStringWithString:(NSString *)string font:(UIFont *)font;

/** 文字富文本, 行间距默认是8 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string;

/** 文字富文本, 自定义行间距 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(NSInteger)lineSpace;

/** 文字富文本, 自定义行间距和文字位置 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(NSInteger)lineSpace alignment:(NSTextAlignment)alignment;



@end

NS_ASSUME_NONNULL_END

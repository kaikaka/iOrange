//
//  NSStringEx.h
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringEx)

BOOL IsValidUrlStrinf(NSString *url);

BOOL IsValidMobilePhoneNum(NSString *phoneNum);
BOOL IsValidEmail(NSString *emailStr, BOOL strictFilter);

NSString * UnicodeStrToUtf8Str(NSString *unicodeStr);
NSString * Utf8StrToUnicodeStr(NSString *utf8Str);

- (NSString*)md5;
- (NSString*)trimSpaceAndReturn;

+ (NSString*)md5:(NSString*)str; 

- (NSString*)fileNameMD5WithExtension:(NSString*)extension;

/**
 * 与当前时间戳比较
 * @return	间隔描述文本, 日期+时间
 */
+ (NSString *)datetimeStrWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 * 与当前时间戳比较
 * @return	间隔描述文本, 不包含时间
 */
+ (NSString *)dateStrWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 * 生成参数签名
 */
+ (NSString *)signWithParams:(NSDictionary *)dic;

- (NSString *)getLinkWithText;

@end


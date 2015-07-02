//
//  NSStringEx.m
//

#import "NSStringEx.h"
#import "NSString+URL.h"
#import <CommonCrypto/CommonDigest.h>

// MD5
@implementation NSString (NSStringEx)

BOOL IsValidUrlStrinf(NSString *url)
{
    NSString *urlRegEx = @"^http(s)?://([\\w-]+\\.)+[\\w-]+[^\\s]+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:url];
}
// 手机号码验证
BOOL IsValidMobilePhoneNum(NSString *phoneNum) {
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNum];
}

// 邮箱格式验证
//  strictFilter 是否严格
BOOL IsValidEmail(NSString *emailStr, BOOL strictFilter) {
    NSString *emailRegex;
    if (strictFilter) {
        emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    }
    else {
        emailRegex = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailStr];
}

// Unicode 转换成中文
NSString * UnicodeStrToUtf8Str(NSString *unicodeStr) {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData   *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

// 中文转换成 Unicode
NSString * Utf8StrToUnicodeStr(NSString *utf8Str) {
    NSMutableString *returnStr = [NSMutableString string];
    for (int i = 0;i < utf8Str.length; i++) {
        unichar _char = [utf8Str characterAtIndex:i];
        //判断是否为英文和数字
        if ((_char=='.') || (_char<='9' && _char>='0')
            || (_char>='a' && _char<='z')
            || (_char>='A' && _char<='Z')) {
            [returnStr appendFormat:@"%C", _char];
        }
        else {
            [returnStr appendFormat:@"\\u%x", _char];
        }
    }
    
    return returnStr;
}

- (NSString *)md5 {
	return [NSString md5:self];
}

+ (NSString *)md5:(NSString*)str {
	const char *cStr = [str?str:@"" UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	return [[NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]] lowercaseString];
}

/**
 * 与当前时间戳比较
 秒：
 00 00:00:01 - 00 00:00:03：刚刚
 00 00:00:04 - 00 00:00:59：4-59 秒前
 分：
 00 00:01:00 - 00 00:59:59：1-59:59 分钟前
 时：
 00 01:00:00 - 00 23:59:59：1-23 小时前
 天：
 01 00:00:00 - 01 23:59:59：昨天
 02 00:00:00 - 03 23:59:59：2-3 天前
 04 00:00:00 - ...：2012-02-23 20:45:09（显示具体时间）
 * @param containTime 是否包含时间
 * @return 间隔描述文本
 */
+ (NSString *)stringByTimeInterval:(NSTimeInterval)timeInterval containTime:(BOOL)containTime {
    NSString *result = nil;
    
    NSInteger dis = [[NSDate date] timeIntervalSince1970]-timeInterval;
    if (dis<=3) {
        result = @"刚刚";
    }
    else if (dis>=4 && dis<=59) {
        result = [NSString stringWithFormat:@"%ld秒前", (long)dis];
    }
    else if (dis>=1*60 && dis<=1*60*60-1) {
        result = [NSString stringWithFormat:@"%ld分钟前", dis/60];
    }
    else if (dis>=1*60*60 && dis<=24*60*60-1) {
        result = [NSString stringWithFormat:@"%ld小时前", dis/60/60];
    }
    else if (dis>=24*60*60 && dis<=2*24*60*60-1) {
        result = @"昨天";
    }
    else if (dis>=2*24*60*60 && dis<=3*24*60*60-1) {
        result = [NSString stringWithFormat:@"%ld天前", dis/24/60/60];
    }
    else if (dis>=3*24*60*60-1 && dis<=24*60*60*31) {
        result = [NSString stringWithFormat:@"%ld 星期前", dis/24/60/60/7 + 1];
    }
    else {
        NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];
        [dfmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"]];
        [dfmt setDateFormat:(containTime?@"MM-dd HH:mm":@"yyyy-MM-dd")];
        result = [dfmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    
    return result;
}

+ (NSString *)datetimeStrWithTimeInterval:(NSTimeInterval)timeInterval {
    return [self stringByTimeInterval:timeInterval containTime:YES];
}

+ (NSString *)dateStrWithTimeInterval:(NSTimeInterval)timeInterval {
    return [self stringByTimeInterval:timeInterval containTime:NO];
}

- (NSString *)trimSpaceAndReturn {
	if ([self length]==0) {
		return @"";
	}
	NSInteger index = [self length]-1;
	NSRange range = {index, 1};
	NSString *tmp=nil;
	do {
		range.location = index;
		tmp = [self substringWithRange:range];
		if ([tmp isEqualToString:@" "]||[tmp isEqualToString:@"\r"]||[tmp isEqualToString:@"\n"]){
			index--;
			if (index<0) 
				return @"";
		}
		else 
			break;
	} while (YES);
    
	return [self substringToIndex:index+1];
}

// md5 加密 得到制定的 后缀名 的文件名
- (NSString *)fileNameMD5WithExtension:(NSString *)extension {
    NSString *filename = [[self md5] stringByAppendingPathExtension:extension?extension:extension?extension:@""];
    return filename;
}

/**
 * 生成参数签名
 */
+ (NSString *)signWithParams:(NSDictionary *)dic {
    NSMutableString *str = [NSMutableString string];
    NSArray *keys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        id value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [str appendString:value];
        }
        else {
            [str appendString:[value stringValue]];
        }
    }
    
    return [str md5];
}

- (NSString *)getLinkWithText {
    NSString *url;
    //自动补全 URL
    NSString *link = [self urlEncodeNormal];
    if (!([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"])) {
        link = [NSString stringWithFormat:@"http://%@",link];
    }
    if (IsValidUrlStrinf(link)) {
        url = link;
    }else{
        //如果不是合法的URL ，则搜索
        NSString *link = @"http://m.baidu.com/s?word=";
        
        NSString *searchKeyBoard = [self urlEncodeNormal];
        if (IsValidUrlStrinf(searchKeyBoard)) {
            searchKeyBoard = [searchKeyBoard urlEncodeNormal];
        }
        
        link = [NSString stringWithFormat:@"%@%@",link,searchKeyBoard];
        url = link;
    }
    return url;
}

@end

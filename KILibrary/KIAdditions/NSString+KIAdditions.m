//
//  NSString+KIString.m
//  Kitalker
//
//  Created by chen on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+KIAdditions.h"

@implementation NSString (KIAdditions)



- (NSString *)md5 {
    if (!self) {
        return nil;
    }
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)sha1 {
    if (!self) {
        return nil;
    }
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", digest[i]];
    }
    return outString;
}

- (NSString *)base64Encoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64Encoded];
}

- (NSString *)base64Decoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:[data base64Decoded] encoding:NSUTF8StringEncoding];
}

//新浪微博的方式
//- (NSString *)URLEncodedString {
//    return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8) autorelease];
//}

//旧的
- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

/*PostValueEncoded*/
- (NSString *)postValueEncodedString{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8));
}


//- (NSString *)URLEncodedString {
//    NSString *encodedString = (NSString *)
//    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                            (CFStringRef)self,
//                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
//                                            CFSTR("+"),
//                                            kCFStringEncodingUTF8);
//    return [encodedString autorelease];
//}


- (NSString *)URLDecodedString {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8));
	return result;
}

- (int)actualLength {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:encoding];
    return (int)[data length];
}

- (NSString *)trimWhitespace {
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimLeftAndRightWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimHTMLTag {
    NSString *html = self;
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return [html trimWhitespace];
}


- (BOOL)isMatchesRegularExp:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEmail {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)URLRegularExp {
    static NSString *urlRegEx = @"((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\\w\\d:#@%/;$()~_?\\+-=\\\\.&]*)";;
    return urlRegEx;
}

- (BOOL)isURL {
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [self URLRegularExp]];
    return [urlTest evaluateWithObject:self];
}

- (NSArray *)URLList {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:[self URLRegularExp]
                                                                         options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators
                                                                           error:nil];
    NSArray *matches = [reg matchesInString:self
                                    options:NSMatchingReportCompletion
                                      range:NSMakeRange(0, self.length)];
    
    NSMutableArray *URLs = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *result in matches) {
        [URLs addObject:[self substringWithRange:result.range]];
    }
    return URLs;
}

//- (BOOL)isIP {
//    NSString *ipRegex = @"((^1([0-9]\\d{0,2}))|(^2([0-5\\d{0,2}])))";
//    NSPredicate *ipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegex];
//    return [ipTest evaluateWithObject:self];
//}

- (BOOL)isCellPhoneNumber {
    NSString *cellPhoneRegEx = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSPredicate *cellPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cellPhoneRegEx];
    return [cellPhoneTest evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    NSString *phoneRegEx= @"((^0(10|2[0-9]|\\d{2,3})){0,1}-{0,1}(\\d{6,8}|\\d{6,8})$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegEx];
    return [phoneTest evaluateWithObject:self];
}
//非负整数
- (BOOL)validateUnsignedInt
{
	NSString *stringRegex = @"^\\d+$";
	NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
	return [stringTest evaluateWithObject:self];
}
- (BOOL)isZipCode {
    NSString *zipCodeRegEx = @"[1-9]\\d{5}$";
    NSPredicate *zipCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegEx];
    return [zipCodeTest evaluateWithObject:self];
}

//- (BOOL)isHTMLTag {
//    NSString *htmlTagRegex = @"<(S*?)[^>]*>.*?|<.*? />";
//    NSPredicate *htmlTagText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", htmlTagRegex];
//    return [htmlTagText evaluateWithObject:self];
//}

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width {
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX)];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size {
    return [self sizeWithFont:font maxSize:size inset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width inset:(UIEdgeInsets)inset {    
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) inset:inset];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size inset:(UIEdgeInsets)inset {
    if (font == nil) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    CGFloat width = size.width - inset.left - inset.right;
    CGFloat height = size.height - inset.top - inset.bottom;
    size = [self sizeWithFont:font
            constrainedToSize:CGSizeMake(width, height)
                lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (CGFloat)heightWithFont:(UIFont *)font {
    CGSize size = [self sizeWithFont:font];
    return size.height;
}

- (id)jsonObject:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:error];
}

- (NSComparisonResult)numericCompare:(NSString *)string {
    NSString *leftString = self;
    NSString *rightString = string;
    
    NSScanner *leftScanner = [NSScanner scannerWithString:leftString];
    NSScanner *rightScanner = [NSScanner scannerWithString:rightString];
    
    NSInteger leftNumber, rightNumber;
    
    if ([leftScanner scanInteger:&leftNumber] && [rightScanner scanInteger:&rightNumber]) {
        if (leftNumber < rightNumber) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
        
//        leftString = [leftString substringFromIndex:[leftScanner scanLocation]];
//        rightString = [rightString substringFromIndex:[rightScanner scanLocation]];
    }
    return [leftString caseInsensitiveCompare:rightString];
}

/*是否是整数*/
- (BOOL)isInteger{
    if (self) {
        NSScanner* scan = [NSScanner scannerWithString:self];
        NSInteger val;
        return [scan scanInteger:&val] && [scan isAtEnd];
    }
    else {
        return NO;
    }
}

/*是否是整数*/
- (BOOL)isValuableInteger{
    
    if ([self isInteger]) {
        
        NSString *AA = [NSString stringWithFormat:@"%ld",(long)[self integerValue]];
        //        NSString *BB = [NSString stringWithFormat:@"%ld",NSIntegerMax];
        
        if ([AA isEqualToString:self]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

/*是否是浮点数*/
- (BOOL)isFloat{
    
    NSString *clearString = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (![clearString isInteger]) {
        return NO;
    }
    else{
        NSRange stringRange = NSMakeRange(0, [self length]);
        NSRegularExpression* pointRegular = [NSRegularExpression regularExpressionWithPattern:@"[.]"
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:nil];
        NSArray *matches = [pointRegular matchesInString:self  options:NSMatchingReportCompletion range:stringRange];
        
        if ([matches count]==1) {
            return YES;
        }
        else{
            return NO;
        }
        //        for (NSTextCheckingResult *match in matches) {
        //            NSRange numberRange = [match range];
        //            [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
        //                                     value:(id)specialTextColor.CGColor
        //                                     range:numberRange];
        //        }
    }
}


+ (NSString*)stringWithInteger:(NSInteger)intValue{
    return [NSString stringWithFormat:@"%ld",(long)intValue];
}

+ (NSString*)stringWithFloat:(CGFloat)floatValue{
    return [NSString stringWithFormat:@"%f",floatValue];
}


+ (NSString*)stringWithDouble:(double)doubleValue{
    return [NSString stringWithFormat:@"%lf",doubleValue];
}

+ (NSString*)stringWithBool:(BOOL)boolValue{
    if (boolValue) {
        return @"1";
    }else{
        return @"0";
    }
}


@end




@implementation NSMutableString (Ext_51Job)

//追加字符串 nil不会crash 追加空值
- (void)appendStringEx:(NSString *)aString {
    if (aString == nil) { // 为 nil 时就不用管它了
        return;
    }
    
    [self appendString:aString];
}

@end


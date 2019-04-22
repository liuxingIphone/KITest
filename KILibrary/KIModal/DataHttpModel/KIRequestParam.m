//
//  KIRequestParam.m
//  kitest
//
//  Created by Bear on 15/2/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "KIRequestParam.h"
#import <objc/runtime.h>
#import "NSObject+KIAdditions.h"
#import "NSString+KIAdditions.h"


@implementation KIRequestParam


@synthesize urlString           = _urlString;
@synthesize method              = _method;
@synthesize timeout             = _timeout;
@synthesize requestType         = _requestType;

- (id)init {
    if (self =[super init]) {
        _method = kHttpPost;
        _timeout = 60.0f;
        _requestType = KIRequestTypeOfRemote;
    }
    return self;
}

- (BOOL)isGet {
    if ([_method isEqualToString:kHttpGet]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPost {
    if ([_method isEqualToString:kHttpPost]) {
        return YES;
    }
    return NO;
}

- (BOOL)isDelete {
    if ([_method isEqualToString:kHttpDelete]) {
        return YES;
    }
    return NO;
}

- (NSString *)urlString {
    if (self.requestType != KIRequestTypeOfLocal) {
        NSString *urlString = kServerDomain;
        if (_urlString != nil) {
            if ([self isGet]) {
                urlString = [NSString stringWithFormat:@"%@%@%@", kServerDomain, _urlString, [self paramOfGet]];
            }else if ([self isPost]){
                urlString = [NSString stringWithFormat:@"%@%@", kServerDomain, _urlString];
            }else{
                
            }
        }
        return urlString;
    }
    return _urlString;
}

- (NSMutableDictionary *)postFiles {
    if (_postFiles == nil) {
        _postFiles = [[NSMutableDictionary alloc] init];
    }
    return _postFiles;
}

- (void)addParam:(NSString *)key withValue:(id)value {
    if (_dynamicParam == nil) {
        _dynamicParam = [[NSMutableDictionary alloc] init];
    }
    
    if (value == nil) {
        //value = @"";
        return;
    }
    
    if (value != nil && key != nil) {
        [_dynamicParam setObject:value forKey:key];
    }
    
}

- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath] && fileKey != nil) {
#ifdef DEBUG
        NSLog(@"%@", filePath);
#endif
        [[self postFiles] setObject:filePath forKey:fileKey];
    }
}

- (void)removeFileWithKey:(NSString *)fileKey {
    [[self postFiles] removeObjectForKey:fileKey];
}

- (void)removeAllFile {
    [[self postFiles] removeAllObjects];
}

- (NSString *)paramOfGet {
    NSDictionary *param = [self paramOfPost];
    
    NSString *paramString = @"?";
    NSRange range = [_urlString rangeOfString:@"?"];
    if (range.length > 0) {
        paramString = @"&";
    }
    if (param != nil) {
        int length = (int)[[param allKeys] count];
        
        NSString    *key;
        id          value;
        NSString    *separate = @"&";
        
        for (int i=0; i<length; i++) {
            key = [[param allKeys] objectAtIndex:i];
            
            if ([key isEqualToString:@"urlString"]
                || [key isEqualToString:@"method"]
                || [key isEqualToString:@"timeout"]
                || [key isEqualToString:@"requestType"]
                || [key isEqualToString:@"command"]) {
                continue;
            }
            
            value = [param valueForKey:key];
            if (i == length-1) {
                separate = @"";
            }
            paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, value, separate];
        }
    }
    
    NSLog(@"请求参数[GET]：%@", paramString);
    
    return paramString;
}

- (NSDictionary *)paramOfPost {
    if (_postParam == nil) {
        _postParam = [[NSMutableDictionary alloc] init];
    }
    
    [_postParam removeAllObjects];
    
    NSString *propertyName = nil;
    NSString *propertyValue = nil;
    
    NSArray *propertyList = [self attributeList];
    NSUInteger count = propertyList.count;
    
    for (int i=0; i<count; i++) {
        propertyName = [propertyList objectAtIndex:i];
        
        if ([propertyName isEqualToString:@"urlString"]
            || [propertyName isEqualToString:@"method"]
            || [propertyName isEqualToString:@"timeout"]
            || [propertyName isEqualToString:@"requestType"]) {
            continue;
        }
        
        propertyValue =[self valueForKey:propertyName];
        
        if (propertyValue == nil) {
            propertyValue = @"";
            //            continue;
        }
        [_postParam setObject:propertyValue forKey:propertyName];
    }
    
    if (_dynamicParam != nil) {
        for (NSString *key in [_dynamicParam allKeys]) {
            id value = [_dynamicParam objectForKey:key];
            if (value == nil) {
                value = @"";
            }
            [_postParam setObject:value forKey:key];
        }
    }
    
    if ([self isPost]) {
#ifdef DEBUG
        NSLog(@"请求参数[POST]：\n%@", _postParam);
#endif
    }
    return _postParam;
}

- (NSString *)paramStringOfPost{
    NSDictionary *param = [self paramOfPost];
    
    NSString *paramString = @"";
    NSRange range = [_urlString rangeOfString:@"?"];
    if (range.length > 0) {
        paramString = @"&";
    }
    if (param != nil) {
        int length = (int)[[param allKeys] count];
        
        NSString    *key;
        id          value;
        NSString    *separate = @"&";
        
        for (int i=0; i<length; i++) {
            key = [[param allKeys] objectAtIndex:i];
            
            if ([key isEqualToString:@"urlString"]
                || [key isEqualToString:@"method"]
                || [key isEqualToString:@"timeout"]
                || [key isEqualToString:@"requestType"]
                || [key isEqualToString:@"command"]) {
                continue;
            }
            
            value = [param valueForKey:key];
            if (i == length-1) {
                separate = @"";
            }
            paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, value, separate];
        }
    }
    
    NSLog(@"请求参数[GET]：%@", paramString);
    
    return paramString;
}

+ (NSURL*)kImageURL:(NSString*)url{
    
    NSString *returnString = kImageURLString(url);
    NSURL *returnURL = [NSURL URLWithString:[returnString URLEncodedString]];
    return returnURL;
}

+ (NSString*)kImageURLString:(NSString*)url{
    //如果是完整的URL链接，则不需要拼接http头
    NSString *lowString = [url lowercaseString];
    if ([lowString hasPrefix:@"http://"]) {
        return url;
    }
    
    
    NSString *returnString = nil;
    
    NSString *lastPathComponent = [[url lastPathComponent] lowercaseString];
    if ([lastPathComponent hasSuffix:@"gif"]) {
        NSString *head = kServerDomain;
        NSString *tail = [url stringByReplacingOccurrencesOfString:[url lastPathComponent] withString:@""];
        if ([head hasSuffix:@"/"] && [tail hasPrefix:@"/"]) {
            tail = [tail substringFromIndex:1];
        }
        else if (![head hasSuffix:@"/"] && ![tail hasPrefix:@"/"]){
            head = [head stringByAppendingString:@"/"];
        }
        returnString = [NSString stringWithFormat:@"%@%@", head,tail];
        returnString = [returnString stringByAppendingString:[url lastPathComponent]];
    }
    else{
        NSString *head = kServerDomain;
        NSString *tail = url;
        if ([head hasSuffix:@"/"] && [tail hasPrefix:@"/"]) {
            tail = [tail substringFromIndex:1];
        }
        else if (![head hasSuffix:@"/"] && ![tail hasPrefix:@"/"]){
            head = [head stringByAppendingString:@"/"];
        }
        returnString = [NSString stringWithFormat:@"%@%@", head,tail];
    }
    return returnString;
}



@end

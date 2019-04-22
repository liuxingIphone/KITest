//
//  KIRequestParam.h
//  kitest
//
//  Created by Bear on 15/2/11.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DefaultNetWorkTimeOut 30.0f
//服务器地址
#define ServerEnvironment 0
#define ServerEnvironment_Development 0
#define ServerEnvironment_Release 1

#if (ServerEnvironment == ServerEnvironment_Development)
#define kServerDomain @"http://115.28.134.4/"//开发环境
#define kServerPath @"api"
#elif (ServerEnvironment == ServerEnvironment_Release)
#define kServerDomain @"http://www.baidu.com/"//正式环境
#define kServerPath @"api"
#else
#error 服务器连接未知
#endif



#define kHttpPost @"POST"
#define kHttpGet @"GET"
#define kHttpDelete @"DELETE"

typedef enum {
    KIRequestTypeOfRemote,
    KIRequestTypeOfLocal,
    KIRequestTypeOfAll
} KIRequestType;

#define kImageWithURL(url)   [KIRequestParam kImageURL:url]
#define kImageURLString(url) [KIRequestParam kImageURLString:url]


@interface KIRequestParam : NSObject{
    NSString            *_urlString;
    NSString            *_method;
    NSTimeInterval      _timeout;
    KIRequestType       _requestType;
    
    /*上传文件*/
    NSMutableDictionary *_postFiles;
    
    /*datas*/
    NSMutableDictionary *_postParam;
    
    /*动态添加的字段*/
    NSMutableDictionary *_dynamicParam;
}

@property (nonatomic, retain) NSString              *urlString;
@property (nonatomic, retain) NSString              *method;
@property (nonatomic, assign) NSTimeInterval        timeout;
@property (nonatomic, assign) KIRequestType         requestType;

- (BOOL)isGet;

- (BOOL)isPost;

- (BOOL)isDelete;

- (NSString *)paramOfGet;

- (NSDictionary *)paramOfPost;

- (NSString *)paramStringOfPost;

- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey;

- (void)removeFileWithKey:(NSString *)fileKey;

- (void)removeAllFile;

- (NSMutableDictionary *)postFiles;

- (void)addParam:(NSString *)key withValue:(id)value;

+ (NSURL*)kImageURL:(NSString*)url;
+ (NSString*)kImageURLString:(NSString*)url;



@end

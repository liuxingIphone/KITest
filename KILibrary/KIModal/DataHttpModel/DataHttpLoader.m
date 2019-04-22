//
//  DataHttpLoader.m
//  kitest
//
//  Created by Bear on 14/12/1.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "DataHttpLoader.h"


@implementation DataHttpLoader


@synthesize tag;
@synthesize delegate;


- (id)initParam:(KIRequestParam *)requestParam delegate:(id<DataHttpLoaderDelegate>)target{
    self = [super init];
    
    if(nil != self){
        delegate = target;
        _requestParam = requestParam;
        tag = 0;
        _conn   = [[DataHttpConnection alloc] initWithParam:_requestParam delegate:self];
    }
    
    return self;
}



/** Delegate: 网络连接出错时调用该方法 **/
- (void)connection:(DataHttpConnection *)conn onError:(NSError *)error {
    if (error) {
        NSLog(@"%@",error);
    }
    [self onFinished];
}

/** Delegate: 网络数据加载完成后调用该方法，并开始解析数据 **/
- (void)connection:(DataHttpConnection *)conn onReceived:(NSData *)data {
    _resultData = [[RespondData alloc]initWithResponseData:data];
    
    [self onFinished];
}

/**
 * 数据装载事件完成后调用的函数，自动释放一次
 */
- (void)onFinished {
    @synchronized(self){
        
        if (nil != delegate) {
            [delegate dataHttpLoader:self respondData:_resultData];
        }
    }
}

- (void)stopRequest{
    delegate = nil;
    
    if (nil != _conn) {
        _conn.isBeginRequest = NO;
        [_conn stopLoading];
    }
    
    //[self onFinished];
}

- (void)startRequest{
    _conn.isBeginRequest = YES;
    [_conn start];
}


#pragma mark - 网络请求



+ (DataHttpLoader *)get_artisans_list:(NSString *)order_by sort:(NSString *)sort page:(NSString *)page page_size:(NSString *)page_size name:(NSString *)name delegate:(id<DataHttpLoaderDelegate>)delegate{
    
    
    KIRequestParam *param = [[KIRequestParam alloc]init];
    
    [param setMethod:kHttpGet];
    [param setUrlString:@"api/banners"];
    
    DataHttpLoader *sender = [[DataHttpLoader alloc]initParam:param delegate:delegate];
    //[param release];
    return sender;
}

+ (DataHttpLoader *)register_user:(id<DataHttpLoaderDelegate>)delegate{
    KIRequestParam *requetParam = [[KIRequestParam alloc] init];
    [requetParam setMethod:kHttpPost];
    [requetParam setUrlString:@"api/user/register"];
    
    [requetParam addParam:@"mobile" withValue:@"13244442222"];
    [requetParam addParam:@"checkcode" withValue:@"2044"];
    
    return [[DataHttpLoader alloc]initParam:requetParam delegate:delegate];
}



+ (id)post_order_addEvaluate:(id<DataHttpLoaderDelegate>)delegate communication_rank:(NSInteger)communication_rank content:(NSString *)content fileArrar:(NSArray *)fileArrar object_id:(NSString *)object_id professional_rank:(NSInteger)professional_rank punctual_rank:(NSInteger)punctual_rank rating:(NSInteger)rating order_no:(NSString *)order_no{
    KIRequestParam *param = [[KIRequestParam alloc]init];
    
    [param addParam:@"communication_rank" withValue:[NSString stringWithInteger:communication_rank]];
    [param addParam:@"content" withValue:content];
    [param addParam:@"object_id" withValue:object_id];
    [param addParam:@"professional_rank" withValue:[NSString stringWithInteger:professional_rank]];
    [param addParam:@"punctual_rank" withValue:[NSString stringWithInteger:punctual_rank]];
    [param addParam:@"rating" withValue:[NSString stringWithInteger:rating]];
    [param addParam:@"order_no" withValue:order_no];
    if ([fileArrar isKindOfClass:[NSArray class]] && fileArrar) {
        for (int i = 0; i < fileArrar.count; i++) {
            NSString *filePath = [fileArrar objectAtIndex:i];
            [param addParam:@"file" withValue:[filePath lastPathComponent]];
            [param addFile:filePath forKey:[NSString stringWithFormat:@"multipart%d", i+1]];
        }
    }
    
    [param setUrlString:@"/evaluate/add"];
    
    return [[DataHttpLoader alloc]initParam:param delegate:delegate];
}

@end
//
//  DataHttpLoader.h
//  kitest
//
//  Created by Bear on 14/12/1.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataHttpConnection.h"
#import "RespondData.h"
#import "KIRequestParam.h"

@class DataHttpLoader;
@protocol DataHttpLoaderDelegate <NSObject>


- (void)dataHttpLoader:(DataHttpLoader *)DataHttpLoader respondData:(RespondData *)respondData;

@end


@interface DataHttpLoader : NSObject <DataHttpConnectionDelegate>{
@private
    DataHttpConnection *_conn;
    id<DataHttpLoaderDelegate> delegate;
    RespondData     *_resultData;
    
}

@property (assign) NSInteger tag;
@property (readonly) id<DataHttpLoaderDelegate> delegate;
@property (nonatomic,strong) KIRequestParam *requestParam;

- (void)stopRequest;

- (void)startRequest;



+ (DataHttpLoader *)get_artisans_list:(NSString *)order_by sort:(NSString *)sort page:(NSString *)page page_size:(NSString *)page_size name:(NSString *)name delegate:(id<DataHttpLoaderDelegate>)delegate;

+ (DataHttpLoader *)register_user:(id<DataHttpLoaderDelegate>)delegate;

+ (id)post_order_addEvaluate:(id<DataHttpLoaderDelegate>)delegate communication_rank:(NSInteger)communication_rank content:(NSString *)content fileArrar:(NSArray *)fileArrar object_id:(NSString *)object_id professional_rank:(NSInteger)professional_rank punctual_rank:(NSInteger)punctual_rank rating:(NSInteger)rating order_no:(NSString *)order_no;

@end



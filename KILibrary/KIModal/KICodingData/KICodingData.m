//
//  KICodingData.m
//  kitest
//
//  Created by Bear on 15/2/3.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "KICodingData.h"
#import "NSString+KIAdditions.h"

@implementation KICodingData
@synthesize dictData = _dictData;
@synthesize codeObject = _codeObject;

#pragma mark - 序列化处理

/* 当前对象序列化到NSData数据流中 */
- (NSData *)toData {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [self encodeWithCoder:archiver];
    [archiver finishEncoding];
    
    return data;
}

/* 序列化函数 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_codeObject];
}

/* 从NSData数据流中反序列化出一个 DataItemDetail 对象 */
+ (KICodingData *)fromData:(NSData*)data {
    if (nil == data) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    KICodingData *item = [[KICodingData alloc] initWithCoder:unarchiver];
    
    [unarchiver finishDecoding];
    
    return item;
}

/* 反序列化函数 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if(nil != self){
        _codeObject = [aDecoder decodeObject];
        
    }
    
    
    return self;
}


#pragma mark -  初始化


/* 清除所有元素 */
- (id)newData{
    return [[KICodingData alloc]initWithObject:nil];
}

/* 初始化 */
- (id)initWithObject:(id)object{
    self = [super init];
    if (self) {
        _codeObject = object;
    }
    return self;
}


@end

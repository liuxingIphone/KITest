//
//  KICodingData.h
//  kitest
//
//  Created by Bear on 15/2/3.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KICodingData : NSObject <NSCoding> {
@private
    NSMutableDictionary *_dictData;
    id _codeObject;
}

@property (readonly) NSMutableDictionary *dictData;
@property (readonly) id codeObject;


/* 当前对象序列化到NSData数据流中 */
- (NSData *)toData;

/* 从NSData数据流中反序列化出一个 DataItemDetail 对象 */
+ (KICodingData *)fromData:(NSData*)data;


/* 清除所有元素 */
- (id)newData;

/* 初始化 */
- (id)initWithObject:(id)object;


/*
 NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:self.DataArray];
 [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:@"DataArray"];
 
 NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataArray"];
 self.dataList = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
 */

@end

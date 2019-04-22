//
//  RespondData.m
//  Assistant
//
//  Created by bearmac on 14-5-6.
//  Copyright (c) 2014年 beartech. All rights reserved.
//

#import "RespondData.h"
#import "NSString+KIAdditions.h"


@implementation RespondData
@synthesize allData = _allData;
@synthesize stacode = _stacode;
@synthesize message = _message;
@synthesize status = _status;
@synthesize data = _data;


- (RespondData *)initWithResponseData:(NSData *)data {
    if (self = [super init]) {
        
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        self.allData = jsonObject;
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            self.stacode = [NSString stringWithInteger:[[jsonObject objectForKey:@"stacode"] integerValue]];
            self.message = [jsonObject objectForKey:@"message"];
            
            self.status = [NSString stringWithInteger:[[jsonObject objectForKey:@"status"] integerValue]];
            self.data = [jsonObject objectForKey:@"data"];
        } else {
            self.stacode = ParseError;
            self.message = @"返回数据错误";
            self.status = ParseError;
            self.data = nil;
        }
        
        
        if (![_data isKindOfClass:[NSDictionary class]] && ![_data isKindOfClass:[NSArray class]]) {
            _data = nil;
        }
        
#ifdef DEBUG
        NSLog(@"RespondData---_allData:%@", _allData);
#endif

    }
    return self;
}

- (BOOL)isSucceed {
    if ([self.stacode isEqualToString:SucceedCode]) {
        return YES;
    }
    return NO;
}



@end

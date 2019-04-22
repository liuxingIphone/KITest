//
//  RespondData.h
//  Assistant
//
//  Created by bearmac on 14-5-6.
//  Copyright (c) 2014年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>


#define Succeed @"1"
#define SucceedCode @"1000"
#define Failure @"0"
#define ParseError @"-1"
#define TokenErrorNotification @"kTokenErrorNotification"


@interface RespondData : NSObject {
    NSString    *_stacode;
    NSString    *_message;
    NSString    *_status;
    id          _data;
    id          _allData;
}

@property (nonatomic, retain) NSString      *stacode;
@property (nonatomic, retain) NSString      *message;
@property (nonatomic, retain) NSString      *status;
@property (nonatomic, retain) id            data;
@property (nonatomic, retain) id            allData;


- (RespondData *)initWithResponseData:(NSData *)data;

- (BOOL)isSucceed;

@end

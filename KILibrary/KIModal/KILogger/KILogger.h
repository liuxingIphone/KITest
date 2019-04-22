//
//  KILogger.h
//  Kitalker
//
//  Created by chen on 13-4-18.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    KILogLevelDebug=1,
    KILogLevelWarning=2,
    KILogLevelError=3,
    KILogLevelInfo=4,
} KILogLevel;

@interface KILogger : NSObject

void KILogEnable(BOOL enable);
BOOL KIIsLogEnable();

void KILogShowDateInfo(BOOL enable);

void KILog(NSString *format, ...);

/*普通调试消息*/
void KILogDebug(NSString *format, ...);

/*警告消息*/
void KILogWarning(NSString *format, ...);

/*错误消息*/
void KILogError(NSString *format, ...);

/*普通消息*/
void KILogInfo(NSString *format, ...);

@end

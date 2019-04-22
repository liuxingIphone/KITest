//
//  KILogger.m
//  Kitalker
//
//  Created by chen on 13-4-18.
//
//

#import "KILogger.h"

static BOOL _enable = YES;
static BOOL _showDate = YES;

@implementation KILogger

void KILogEnable(BOOL enable) {
    _enable = enable;
}

BOOL KIIsLogEnable() {
    return _enable;
}

void KILogShowDateInfo(BOOL enable) {
    _showDate = enable;
}

NSString *GetStringFormat(KILogLevel level, NSString *format, va_list args) {
    NSString *text = [[NSString alloc] initWithFormat:format arguments:args];
    return text;
}

NSString *GetDateFormatter() {
    NSDate *date = [NSDate date];
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
	    static NSString *dateFormatString = @"yyyy-MM-dd hh:mm:ss.FFF ";
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatString];
    }
    return [dateFormatter stringFromDate:date];
}

NSString *GetLogLevelString(KILogLevel level) {
    switch (level) {
        case KILogLevelDebug: {
            return @"[D] ";
        }
            break;
        case KILogLevelWarning: {
            return @"[W] ";
        }
            break;
        case KILogLevelError: {
            return @"[E] ";
        }
            break;
        case KILogLevelInfo: {
            return @"[I] ";
        }
            break;
        default: {
            return @"[D] ";
        }
            break;
    }
}

void KILogFormat(KILogLevel level, NSString *format, va_list args) {
    if (_enable == NO || format==nil) {
        return;
    }
    
    NSMutableString *text = [[NSMutableString alloc] init];
    
    //打印时间信息
    if (_showDate) {
        [text appendString:GetDateFormatter()];
    }
    
    //打印程序信息
//    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
//    [text appendString:[processInfo processName]];
    
    //打印log类型
    [text appendString:GetLogLevelString(level)];
    
    //打印log
    [text appendString:GetStringFormat(KILogLevelDebug, format, args)];
    
    [text appendString:@"\n"];
    
    fprintf(stderr, [text UTF8String], NULL);

}

//void KILog(NSString *format, ...) {
//	if (_enable) {
//		va_list args;
//		va_start(args, format);
//		KILogFormat(KILogLevelDebug, format, args);
//		va_end(args);
//	}
//}

/*普通调试消息*/
void KILogDebug(NSString *format, ...) {
	if (_enable) {
		va_list args;
		va_start(args, format);
		KILogFormat(KILogLevelDebug, format, args);
		va_end(args);
	}
}

/*警告消息*/
void KILogWarning(NSString *format, ...) {
	if (_enable) {
		va_list args;
		va_start(args, format);
		KILogFormat(KILogLevelWarning, format, args);
		va_end(args);
	}
}

/*错误消息*/
void KILogError(NSString *format, ...) {
	if (_enable) {
		va_list args;
		va_start(args, format);
		KILogFormat(KILogLevelError, format, args);
		va_end(args);
	}
}

/*普通消息*/
void KILogInfo(NSString *format, ...) {
	if (_enable) {
		va_list args;
		va_start(args, format);
		KILogFormat(KILogLevelInfo, format, args);
		va_end(args);
	}
}

@end

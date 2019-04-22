


#import "KIAppCoreInfo.h"
#import "KIRequestParam.h"


/* 网络连接用到的常量 */
#define APPCONFIG_CONN_ERROR_MSG_DOMAIN     @"DataHttpConnectionError"  // 连接出错信息标志
#define TWITTERFON_FORM_BOUNDARY_            @"0xKhTmLbOuNdArY"

static NSString * const FORM_FLE_INPUT = @"file";

@class DataHttpConnection;

/**
 * DataHttpConnection 协议
 * 该协议用于约束响应 DataHttpConnection 事件的类，确保其拥有 onError 和 onReceived 两个方法。
 */
@protocol DataHttpConnectionDelegate <NSObject>

@required

/* onError 方法，在 DataHttpConnection 请求出错时回调的方法 */
- (void)connection:(DataHttpConnection *)conn onError:(NSError *)error;

/* onReceived 方法，在 DataHttpConnection 数据加载完成后回调的方法 */
- (void)connection:(DataHttpConnection *)conn onReceived:(NSData *)data;

@end



/**
 *   DataHttpConnection 类
 *
 *   1.该类用于响应网络请求。
 *   2.该类会封装超时时间，用户代理和处理请求异常。
 */
@interface DataHttpConnection : NSURLConnection {
@private
	NSMutableData *_data;
	id<DataHttpConnectionDelegate> _delegate;
    BOOL _finished;
    NSInteger statusCode;
}

@property (strong) NSString *requestURL;
@property (assign) BOOL isBeginRequest;


- (id)initWithParam:(KIRequestParam *)requestParam delegate:(id<DataHttpConnectionDelegate>)delegate;

/* 终止数据加载 */
- (void)stopLoading;

- (void)start;

@end

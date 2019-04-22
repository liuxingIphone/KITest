


#import "DataHttpConnection.h"
#import "NSString+KIAdditions.h"
#import "UIDevice+KIAdditions.h"

@implementation DataHttpConnection

@synthesize requestURL;



- (id)initWithParam:(KIRequestParam *)requestParam delegate:(id<DataHttpConnectionDelegate>)delegate{
	NSMutableURLRequest *theRequest;
    
    self.requestURL = requestParam.urlString;

    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestParam.urlString]
                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                     timeoutInterval:requestParam.timeout];
	/* 不支持cookies */
    [theRequest setHTTPShouldHandleCookies:NO];

    /* 设置POST的表单数据 */
    [theRequest setHTTPMethod:requestParam.method];
    if ([requestParam.method isEqualToString:kHttpPost]) {
        NSMutableData *myRequestData = [NSMutableData data];
        [myRequestData appendData:[NSJSONSerialization dataWithJSONObject:[requestParam paramOfPost] options:NSJSONWritingPrettyPrinted error:nil ]];
        
        
//        NSDictionary *postFiles = [requestParam postFiles];
//        for (NSString *key in postFiles) {
//            UIImage *image = [UIImage imageWithContentsOfFile:[postFiles objectForKey:key]];
//            NSData *imageData = nil;
//            //判断图片是不是png格式的文件
//            if (UIImagePNGRepresentation(image)) {
//                //返回为png图像。
//                imageData = UIImagePNGRepresentation(image);
//            }else {
//                //返回为JPEG图像。
//                imageData = UIImageJPEGRepresentation(image, 1.0);
//            }
//            [myRequestData appendData:imageData];
//        }
        
        [theRequest setHTTPBody:myRequestData];
    }
    
    theRequest = [DataHttpConnection postRequestWithParems:requestParam];
	/* 初始化HTTP连接 */
    if (self = [super initWithRequest:theRequest delegate:self]) {
        _data = [[NSMutableData alloc] initWithCapacity:0];
        _finished = NO;
        _delegate = delegate;

		[KIAppCoreInfo showNetworkIndicator];
    }
    
    
    return self;
}




#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)conn didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response{
    [_data setLength:0];

    /** Get response code **/
    statusCode = [(NSHTTPURLResponse *)response statusCode];

    if (statusCode >= 400) {
        [self cancel];
        [self onHttpStatusCodeError];
    }
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn{
    [self onFinished:nil];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error{
    if (nil != error) {
        [self onFinished:error];
    } else {
        [self onHttpStatusCodeError];
    }
}

//http error statusCode
- (void)onHttpStatusCodeError {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (statusCode > 0) {
        NSString *statusError = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
        
        if (nil != statusError) {
            userInfo[APPCONFIG_CONN_ERROR_MSG_DOMAIN] = statusError;
        }
    }
    
    [self onFinished:[NSError errorWithDomain:APPCONFIG_CONN_ERROR_MSG_DOMAIN code:statusCode userInfo:userInfo]];
}

#pragma mark - 请求结束处理

- (void)onFinished:(NSError *)error {
    if (_finished) {
        return;
    }
    _finished = YES;
    
    [KIAppCoreInfo hiddenNetworkIndicator];
    
    if(nil != _delegate){
        if (nil != error) {
            [_delegate connection:self onError:error];
        } else {
            [_delegate connection:self onReceived:_data];
        }
    }
}

#pragma mark - 网络操作处理

- (void)start{
    if (_finished || !_isBeginRequest) {
        return;
    }
    
    [super start];
}

- (void)stopLoading {
	_delegate = nil;

	[self cancel];

	[self onFinished:nil];
}

- (void)cancel {
    if (_finished) {
        return;
    }
    
    [super cancel];
}




+ (NSMutableURLRequest *)postRequestWithParems:(KIRequestParam *)requestParam
{
    //根据url初始化request
    NSMutableURLRequest* request = nil;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestParam.urlString]
                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                     timeoutInterval:requestParam.timeout];
    //分割符
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    
    
    NSDictionary *postParems = [requestParam paramOfPost];
    //http 参数body的字符串
    NSMutableString *paraBody=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    //遍历keys
    for(int i = 0; i < [keys count] ; i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [paraBody appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [paraBody appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [paraBody appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"参数%@ == %@",key,[postParems objectForKey:key]);
    }
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[paraBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSDictionary *postFiles = [requestParam postFiles];
    for (NSString *key in postFiles) {
        UIImage *image = [UIImage imageWithContentsOfFile:[postFiles objectForKey:key]];
        NSMutableString *imageBody = [[NSMutableString alloc] init];
        NSData *imageData = nil;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image))
        {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(image);
        }else
        {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
        
        NSString *imagePath = [postFiles objectForKey:key];
        NSString *name = [imagePath lastPathComponent];
        NSString *fileNmae = [imagePath lastPathComponent];
        //添加分界线，换行
        [imageBody appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [imageBody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileNmae];
        //声明上传文件的格式
        [imageBody appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
        //将image的data加入
        
        [myRequestData appendData:[imageBody dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:[[NSData alloc] initWithData:imageData]];
        [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    return request;
}


+(NSString *)postRequestWithURL:(NSString *)url postParems:(NSMutableDictionary *)postParems picFilePath:(NSString *)picFilePath picFileName:(NSString *)picFileName{
    
    NSString * TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //得到图片的data
    
    NSData* data;
    
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        
        //判断图片是不是png格式的文件
        
        if (UIImagePNGRepresentation(image)) {
            
            //返回为png图像。
            
            data = UIImagePNGRepresentation(image);
            
        }else {
            
            //返回为JPEG图像。
            
            data = UIImageJPEGRepresentation(image, 1.0);
            
        }
        
    }
    
    //http body的字符串
    
    NSMutableString *body=[[NSMutableString alloc]init];
    
    //参数的集合的所有key的集合
    
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    
    for(int i=0;i<[keys count];i++)
        
    {
        
        //得到当前key
        
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //添加字段名称，换2行
        
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        
        //添加字段的值
        
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
        
    }
    
    if(picFilePath){
        
        ////添加分界线，换行
        
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        
        //声明上传文件的格式
        
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
        
    }
    
    //声明结束符：--AaB03x--
    
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
    //声明myRequestData，用来放入http body
    
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    if(picFilePath){
        
        //将image的data加入
        
        [myRequestData appendData:data];
        
    }
    
    //加入结束符--AaB03x--
    
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    
    //设置HTTPHeader
    
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //设置Content-Length
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    
    [request setHTTPBody:myRequestData];
    
    //http method
    
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponese = nil;
    
    NSError *error = [[NSError alloc]init];
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        
        NSLog(@"返回结果=====%@",result);
        
        return result;
        
    }
    
    return nil;
    
    
}


@end

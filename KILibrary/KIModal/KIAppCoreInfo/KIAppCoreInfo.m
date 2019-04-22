/*
#####################################################################
# File    : KIAppCoreInfo.m
# Project : ios_51job
# Created : 2011-12-14
# DevTeam : 51job Development Team
# Author  : solomon (xmwen@126.com)
# Notes   :
#####################################################################
### Change Logs   ###################################################
#####################################################################
---------------------------------------------------------------------
# Date  :
# Author:
# Notes :
#
#####################################################################
*/

#import "KIAppCoreInfo.h"
#import "UIDevice+KIAdditions.h"
#import "FSManager.h"
#import "UIAlertView+KIAdditions.h"
#import "UIDevice+KIAdditions.h"
#import "RegexKitLite.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>

@implementation KIAppCoreInfo

@synthesize controllerStack = _controllerStack;
@synthesize netWorkIndicatorCount = _netWorkIndicatorCount;
@synthesize clientSign = _clientSign;
@synthesize udidFor51Job = _UDIDFor51Job;
@synthesize uuidFor51Job = _UUIDFor51Job;
@synthesize isOldUser = _isOldUser;
@synthesize systemVersionCode = _systemVersionCode;

KIOBJECT_SINGLETON_IMPLEMENT(KIAppCoreInfo);

/* 初始化变量和数据库 */
- (id)init {
    self = [super init];

    _isOldUser = NO;
//    _UDIDFor51Job = [[UIDevice getUDID] copy];
//    _UUIDFor51Job = [[_UDIDFor51Job md5] copy];

    // 获取当前系统浮点型版本号
    self.systemVersionCode = [[[UIDevice currentDevice] systemVersion] floatValue];

    // 初始化应用生命期间内相关的一揽子变量
    _netWorkIndicatorCount = 0;

    _clientSign = [[FSManager stringFromResource:@"Config/client.sign"] trimWhitespace];
    _controllerStack = [[NSMutableArray alloc] initWithCapacity:0];

    return self;
}

/* 记录 Controller 到堆栈中 */
- (void)recordControllerToStack:(UIViewController *)ctrl {
    if(nil == ctrl || ![ctrl isKindOfClass:[UIViewController class]]){
        return;
    }
    
    NSNumber *ctrl_flag = @((long)ctrl);
    NSString *ctrl_name = @(object_getClassName(ctrl));
    NSMutableDictionary *save_item = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (NSDictionary *ctrl_item in _controllerStack) {
        NSNumber *item_flag = ctrl_item[@"flag"];
        
        if ([item_flag isEqualToNumber:ctrl_flag]) {
            [_controllerStack removeObject:ctrl_item];
            [_controllerStack addObject:ctrl_item];
            goto exe_print;
        }
    }
    
    save_item[@"flag"] = ctrl_flag;
    save_item[@"name"] = ctrl_name;
    
    [_controllerStack addObject:save_item];
    
exe_print:

    #if DEBUG_UIViewControllers_Stack_Print
        // 打印当前 UIViewController 路径到命令行，若需查看当前栈路径，则可打开此处注释
        NSLog(@"UIViewController Path: %@", [[KIAppCoreInfo sharedKIAppCoreInfo] getControllerStackPath]);
    #endif

    return;
}

/* 从堆栈中移除 Controller */
- (void)removeControllerFromStack:(UIViewController *)ctrl {
    if(nil == ctrl || ![ctrl isKindOfClass:[UIViewController class]]){
        return;
    }
    
    NSNumber *ctrl_flag = @((long)ctrl);
    NSString *ctrl_name = @(object_getClassName(ctrl));
    
    for (NSDictionary *ctrl_tmp in _controllerStack) {
        NSNumber *item_flag = ctrl_tmp[@"flag"];
        NSString *item_name = ctrl_tmp[@"name"];
        
        if ([item_flag isEqualToNumber:ctrl_flag] && [ctrl_name isEqualToString:item_name]) {
            [_controllerStack removeObject:ctrl_tmp];
            return;
        }
    }
}

/* 获取 Controller 最新激活的 */
- (UIViewController *)getLastActiveController {
    if (nil == _controllerStack) {
        return nil;
    }
    
    NSDictionary *ctrl_item = [_controllerStack lastObject];
    NSNumber *ctrl_flag = ctrl_item[@"flag"];
    
    return (UIViewController *)[NSNumber numberWithLong:[ctrl_flag longValue]];
}

/* 获取 Controller 堆栈信息 */
- (NSString *)getControllerStackPath {
    NSMutableString *path = [NSMutableString stringWithCapacity:0];
    
    for (NSDictionary *ctrl_tmp in _controllerStack) {
        NSString *item_name = ctrl_tmp[@"name"];
        [path appendFormat:@"/%@", item_name];
    }
    
    return path;
}

/* 在状态栏上显示网络连接状态的转子 */
+ (void)showNetworkIndicator {
    [KIAppCoreInfo sharedKIAppCoreInfo].netWorkIndicatorCount++;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    /* 注释掉禁止锁频 原因：有在底层循环的网络链接请求，如果不注释掉，手机将永远常亮 add by thomas*/
    // [UIApplication sharedApplication].idleTimerDisabled = YES;
}

/* 在状态栏上隐藏网络连接状态的转子 */
+ (void)hiddenNetworkIndicator {
    if ([KIAppCoreInfo sharedKIAppCoreInfo].netWorkIndicatorCount > 0) {
        [KIAppCoreInfo sharedKIAppCoreInfo].netWorkIndicatorCount--;

        if ([KIAppCoreInfo sharedKIAppCoreInfo].netWorkIndicatorCount < 1) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            /* 注释掉禁止锁频 原因：有在底层循环的网络链接请求，如果不注释掉，手机将永远常亮 add by thomas*/
            // [UIApplication sharedApplication].idleTimerDisabled = NO;
        }
    }
}

@end

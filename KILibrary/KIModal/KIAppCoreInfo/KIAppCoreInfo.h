/*
#####################################################################
# File    : KIAppCoreInfo.h
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

#import "KIObjectSingleton.h"
#import "NSString+KIAdditions.h"

/**
 *
 * KIAppCoreInfo 类
 *
 *   1.管理应用的数据库对象
 *   2.封装一些常用的方法
 *
 * @InterfaceName:   KIAppCoreInfo
 * @Copyright:       51job Wireless Dev (c) 2011
 * @date:            2011-12-14
 */
@interface KIAppCoreInfo : NSObject {
@private
    NSInteger _netWorkIndicatorCount;            // 加载网络的个数

    NSString *_clientSign;                       // 渠道信息，推广用
    NSString *_UDIDFor51Job;                     // 前程无忧专用UDID, 主要是保证应用被卸载后重装该值不会发生变化
    NSString *_UUIDFor51Job;                     // 前程无忧专用UUID, UDID 的 md5 值

    NSMutableArray *_controllerStack;            // 当前 Controller 堆栈

    BOOL _isOldUser;                             // 用以标识当前版本客户端是否是从旧版升级过来的（默认为NO，从 v2.1.0开始使用）
    
}

@property (readonly) NSMutableArray *controllerStack;
@property (assign) NSInteger netWorkIndicatorCount;
@property (readonly) NSString *clientSign;
@property (readonly) NSString *udidFor51Job;
@property (readonly) NSString *uuidFor51Job;
@property (assign) BOOL isOldUser;
@property (assign) float systemVersionCode; //当前系统浮点型版本号

KIOBJECT_SINGLETON_DEFINE(KIAppCoreInfo);


/* 记录 Controller 到堆栈中 */
- (void)recordControllerToStack:(UIViewController *)ctrl;

/* 从堆栈中移除 Controller */
- (void)removeControllerFromStack:(UIViewController *)ctrl;

/* 获取 Controller 堆栈信息 */
- (NSString *)getControllerStackPath;

/* 获取 Controller 最新激活的 */
- (UIViewController *)getLastActiveController;

/* 在状态栏上显示网络连接状态的转子 */
+ (void)showNetworkIndicator;

/* 在状态栏上隐藏网络连接状态的转子 */
+ (void)hiddenNetworkIndicator;


@end

//
//  NSArray+KIAdditions.h
//  Kitalker
//
//  Created by chen on 12-11-29.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KKUDID.h"

@interface UIDevice (KIAdditions)

/* 获取设备的UUID，统一32位长 */
+ (NSString *)getUUID;

/* 获取设备的UDID */
+ (NSString *)getUDID;

/* 获取设备的 deviceType */
+ (NSString *)getDeviceType;

/* 获取本地设备的操作系统 */
+ (NSString *)getOSName;

/* 获取设备的类型 */
+ (NSString *)getDeviceName;

/* 获取字符形式的应用版本号 */
+ (CGFloat)getSystemVersion;

/* 获取整数型应用版本号 */
+ (NSInteger)getSystemVerIntValue;


//获得iPhone的MAC地址
+ (NSString *)getMacAddress;

/* 获取经过格式化的当前时间 */
+ (NSString *)currentDateByFormat;

/* 获取经过格式化的当前时间 */
+ (NSString *)currentDateByFormat:(NSString *)format;

//获得网络运营商的名称
+ (NSString *)getNetworkOperators;


@end

//
//  NSArray+KIAdditions.m
//  Kitalker
//
//  Created by chen on 12-11-29.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import "UIDevice+KIAdditions.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import "RegexKitLite.h"
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (KIAdditions)

/* 获取设备的UUID，统一32位长 */
+ (NSString *)getUUID {
    return [KKUDID UDID];
}

/* 获取设备的UDID */
+ (NSString *)getUDID {
    return [KKUDID UDID];
}

/* 获取设备的 deviceType */
+ (NSString *)getDeviceType {
    struct utsname systemInfo;
    
    memset(&systemInfo, 0, sizeof(systemInfo));
    
    uname(&systemInfo);
    
    systemInfo.machine[sizeof(systemInfo.machine) - 1] = 0;
    
    return @(systemInfo.machine);
}

/* 获取本地设备的操作系统 */
+ (NSString *)getOSName {
    return [[UIDevice currentDevice] systemName];
}


/* 获取设备的类型 */
+ (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = @(systemInfo.machine);
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

/* 获取字符形式的应用版本号 */
+ (CGFloat)getSystemVersion {
    return [[[UIDevice currentDevice]systemVersion] floatValue];
}

/* 获取整数型应用版本号 */
+ (NSInteger)getSystemVerIntValue {
    return [[[[UIDevice currentDevice]systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
}



//获得iPhone的MAC地址
+ (NSString *)getMacAddress{
    
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

/* 获取经过格式化的当前时间 */
+ (NSString *)currentDateByFormat {
    time_t tm_t;
    struct tm tm_current;
    
    time(&tm_t);
    memcpy(&tm_current, localtime(&tm_t), sizeof(tm_current));
    
    NSString *currentTime=[NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",
                           tm_current.tm_year+1900,
                           tm_current.tm_mon+1,
                           tm_current.tm_mday,
                           tm_current.tm_hour,
                           tm_current.tm_min,
                           tm_current.tm_sec];
    
    return currentTime;
}

/* 获取经过格式化的当前时间 */
+ (NSString *)currentDateByFormat:(NSString *)format {
    if ([format length] < 1) {
        return [self currentDateByFormat];
    }
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = format;
    
    return [formater stringFromDate:[NSDate date]];
}

//获得网络运营商的名称
+ (NSString *)getNetworkOperators{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (carrier == nil) {
        return @"";
    }else{
        
        /*   carrier的内容
         CTCarrier (0x140dc0) {
         Carrier name: [中华电信]
         Mobile Country Code : [466]
         Mobile Network Code:[92]
         ISO Country Code:[tw]
         Allows VOIP? [YES]
         }
         */
        //正则表达式配出来
        NSString *carrDesc = [carrier description];
        NSString *regexPatten = @"Carrier name: \\[(.+)\\]";
        NSString *carrierStr = [carrDesc stringByMatching:regexPatten capture:1];
        return carrierStr;
    }
    
    return nil;
}



@end

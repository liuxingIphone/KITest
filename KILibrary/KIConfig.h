//
//  KIConfig.h
//  KiTest
//
//  Created by bearmac on 14-11-13.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#ifndef KIConfig_h
#define KIConfig_h

#import "KIAdditions.h"

#import "KILogger.h"
#import "KIThemeManager.h"
#import "DataHttpConnection.h"
#import "DataHttpLoader.h"
#import "RespondData.h"
#import "KICodingData.h"

#import "KIWaitingView.h"
#import "KICollectionView.h"
#import "KITableView.h"

#import "KINavigationController.h"
#import "KIViewController.h"


#define LSRGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB_COLOR_String(string)  [UIColor colorWithHexString:string]

//屏幕尺寸获取
#define KIApplicationWidth [[UIScreen mainScreen] applicationFrame].size.width
#define KIApplicationHeight [[UIScreen mainScreen] applicationFrame].size.height
#define KIScreenScale  (KIApplicationWidth/320.0f)
#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE            (SCREEN_WIDTH/320.0f)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_STATUS_HEIGHT    (IS_IPHONE_X ? 44.0f : 20.0f)
#define SCREEN_TOP_HEIGHT       (44.0f + SCREEN_STATUS_HEIGHT)
#define SCREEN_BOTTOM_HEIGHT    (IS_IPHONE_X ? 34.0f : 0.0f)
#define SCREEN_SAFE_HEIGHT      (SCREEN_HEIGHT - SCREEN_TOP_HEIGHT - SCREEN_BOTTOM_HEIGHT)
#define SCREEN_TABBAR_HEIGHT     (49.0f)




/* Dump 一个 Rect 结构 */
#define CGRectDump(rect)  NSLog(@"%s = CGRectMake(%f, %f, %f, %f) ", ""#rect"", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)




/*在Bulid Settings的other C Flags的Debug中加入-DDEBUG就可以在代码中的任何位置使用DLog了
 1) __VA_ARGS__ 是一个可变参数的宏，这个可变参数的宏是新的C99规范中新增的，目前似乎只有gcc支持（VC6.0的编译器不支持）。宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉,否则会编译出错。
 2) __FILE__ 宏在预编译时会替换成当前的源文件名
 3) __LINE__宏在预编译时会替换成当前的行号
 4) __FUNCTION__宏在预编译时会替换成当前的函数名称
 
 %@ 对象
 %d, %i 整数
 %hi 短整型
 %lli 长整型
 %u   无符整形
 %f 浮点/双字
 %0.2f  精度浮点数,且只保留两位小数
 %x, %X 二进制整数
 %o 八进制整数
 %zu size_t
 %p 指针
 %e   浮点/双字 （科学计算）
 %g   浮点/双字  科学技术法(用最简短的方式)
 %s C （char*）字符串
 %.*s Pascal字符串
 %c 字符
 %C unichar
 %lld 64位长整数（long long）
 %llu   无符64位长整数
 %Lf 64位双字
 %lu   sizeof(i)内存中所占字节数
 */
#ifdef DEBUG
#define KILog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define KILog(...)
#endif

#endif

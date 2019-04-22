//
//  KIThemeTest.h
//  kitest
//
//  Created by HuamoMac on 15/4/15.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kThemeDidChange @"themeDidChange"

#define KIThemeTestImage(key) [KIThemeTest imageWithKey:key]
#define KIThemeStretchableImage(key, width, height) [KIThemeImage(key) stretchableImageWithLeftCapWidth:width topCapHeight:height]

#define KIThemeColor(key) [KIThemeManager colorWithKey:key]
#define KIThemeFont(key) [KIThemeManager fontWithKey:key];




@interface KIThemeTest : NSObject

+ (KIThemeTest *)sharedInstance;




+ (UIImage *)imageWithKey:(NSString *)key;


@end

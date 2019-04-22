//
//  KIThemeManager.h
//  Kitalker
//
//  Created by chen on 12-8-14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kThemeDidChange @"themeDidChange"

#define KIThemeImage(key) [KIThemeManager imageWithKey:key]
#define KIThemeStretchableImage(key, width, height) [KIThemeImage(key) stretchableImageWithLeftCapWidth:width topCapHeight:height]

#define KIThemeColor(key) [KIThemeManager colorWithKey:key]
#define KIThemeFont(key) [KIThemeManager fontWithKey:key];

#define KIButtonImage(button, key) @autoreleasepool {\
    if ([button isKindOfClass:[UIButton class]]) {\
        UIImage *imageN = KIThemeImage(key);\
        if (imageN==nil) {imageN = KIThemeImage([key stringByAppendingString:@"N"]);}\
        UIImage *imageH = KIThemeImage([key stringByAppendingString:@"H"]);\
        UIImage *imageS = KIThemeImage([key stringByAppendingString:@"S"]);\
        UIImage *imageD = KIThemeImage([key stringByAppendingString:@"D"]);\
        if (imageN) {[button setImage:imageN forState:UIControlStateNormal];}\
        if (imageH) {[button setImage:imageH forState:UIControlStateHighlighted];}\
        if (imageS) {[button setImage:imageS forState:UIControlStateSelected];}\
        if (imageD) {[button setImage:imageD forState:UIControlStateDisabled];}\
    }\
}\

#define KIButtonBackgroundImage(button, key) @autoreleasepool {\
    if ([button isKindOfClass:[UIButton class]]) {\
        UIImage *imageN = KIThemeImage(key);\
        if (imageN==nil) {imageN = KIThemeImage([key stringByAppendingString:@"N"]);}\
        UIImage *imageH = KIThemeImage([key stringByAppendingString:@"H"]);\
        UIImage *imageS = KIThemeImage([key stringByAppendingString:@"S"]);\
        UIImage *imageD = KIThemeImage([key stringByAppendingString:@"D"]);\
        if (imageN) {[button setBackgroundImage:imageN forState:UIControlStateNormal];}\
        if (imageH) {[button setBackgroundImage:imageH forState:UIControlStateHighlighted];}\
        if (imageS) {[button setBackgroundImage:imageS forState:UIControlStateSelected];}\
        if (imageD) {[button setBackgroundImage:imageD forState:UIControlStateDisabled];}\
    }\
}\

#define KIButtonTitleColor(button, key) @autoreleasepool {\
    if ([button isKindOfClass:[UIButton class]]) {\
        UIColor *colorN = KIThemeColor(key);\
        if (colorN==nil) {colorN = KIThemeColor([key stringByAppendingString:@"N"]);}\
        UIColor *colorH = KIThemeColor([key stringByAppendingString:@"H"]);\
        UIColor *colorS = KIThemeColor([key stringByAppendingString:@"S"]);\
        UIColor *colorD = KIThemeColor([key stringByAppendingString:@"D"]);\
        if (colorN) {[button setTitleColor:colorN forState:UIControlStateNormal];}\
        if (colorH) {[button setTitleColor:colorH forState:UIControlStateHighlighted];}\
        if (colorS) {[button setTitleColor:colorS forState:UIControlStateSelected];}\
        if (colorD) {[button setTitleColor:colorD forState:UIControlStateDisabled];}\
    }\
}\


@interface KIThemeManager : NSObject

+ (KIThemeManager *)sharedInstance;

/*返回当前所有的主题名称列表*/
- (NSMutableArray *)themeList;

- (void)clearMemory;
    
/*添加一个主题到当前主题库中
 *
 *  name  主题名称
 *  bundlePath 存放主题文件的bundle，例如  ../Applications/9CA82C55-7210-4346-A209-35077FD932D5/Documents/test.bundle
 */
- (void)addTheme:(NSString *)name bundle:(NSString *)bundlePath;

/*设置主题，调用该方法后，将更新主题*/
- (void)changeTheme:(NSString *)name;

/*返回当前所使用的主题名称*/
- (NSString *)currentTheme;

+ (NSString *)currentTheme;

+ (void)changeTheme:(NSString *)name;

+ (UIImage *)imageWithKey:(NSString *)key;

+ (UIColor *)colorWithKey:(NSString *)key;

+ (UIFont *)fontWithKey:(NSString *)key;

@end

//
//  KIThemeTest.m
//  kitest
//
//  Created by HuamoMac on 15/4/15.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "KIThemeTest.h"
#define kThemeConfigFile @"themeConfig.plist"
#define kThemeFile @"theme.plist"

#define kCurrentTheme @"currentTheme"
#define kThemeList @"themeList"

@interface KIThemeTest()
@property (nonatomic, retain) NSString  *themePath;
@property (nonatomic, retain) NSMutableDictionary *resourcesDic;

@end

@implementation KIThemeTest {
    NSString            *_currentTheme;
    NSMutableDictionary *_themeConfig;
    NSMutableDictionary *_theme;
    NSMutableDictionary *_resourcesDic;
    NSString            *_themePath;
}


@synthesize themePath = _themePath;
@synthesize resourcesDic = _resourcesDic;

+ (KIThemeTest *)sharedInstance {
    static KIThemeTest *KITHEME_MANAGER = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KITHEME_MANAGER = [[self alloc] init];
    });
    return KITHEME_MANAGER;
}

- (id)init {
    self = [super init];
    if (self) {
        _resourcesDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSMutableDictionary*)resourcesDictionary{
    if (_resourcesDic) {
        return _resourcesDic;
    }
    else{
        _resourcesDic = [[NSMutableDictionary alloc]init];
        return _resourcesDic;
    }
}



- (NSString *)themePath {
    if (_themePath == nil) {
        _themePath = [NSString stringWithFormat:@"%@/default.bundle/",
                      [[NSBundle mainBundle] bundlePath]];
    }
    return _themePath;
}



+ (UIImage *)imageWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *imageName = key;
    
    
    UIImage *image = [[[KIThemeTest sharedInstance] resourcesDictionary] objectForKey:key];
    
    if (image == nil || ![image isKindOfClass:[UIImage class]]) {
        
        NSString* folderPath = [[KIThemeTest sharedInstance] themePath];
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:folderPath]) return 0;
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:[[KIThemeTest sharedInstance] themePath]] objectEnumerator];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                                  fileAbsolutePath,
                                  imageName];
            
            image = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            if (image == nil) {
                image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", key]];
            }
            
            if (image != nil) {
                [[[KIThemeTest sharedInstance] resourcesDictionary] setObject:image forKey:key];
                break;
            }
        }
        
        
#ifdef DEBUG
        //        KILog(@"image: %@, %@", filePath, image);
#endif
    }
    return image;
}









@end

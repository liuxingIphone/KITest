//
//  KIThemeManager.m
//  Kitalker
//
//  Created by chen on 12-8-14.
//
//

#import "KIThemeManager.h"

#define kThemeConfigFile @"themeConfig.plist"
#define kThemeFile @"theme.plist"

#define kCurrentTheme @"currentTheme"
#define kThemeList @"themeList"

@interface KIThemeManager()
@property (nonatomic, retain) NSString  *themePath;
@property (nonatomic, retain) NSMutableDictionary *resourcesDic;
- (NSString *)themeConfigFilePath;
- (NSMutableDictionary *)themeConfig;
- (NSMutableDictionary *)theme;
- (void)synchThemeConfig;
- (void)initTheme;
@end

@implementation KIThemeManager {
    NSString            *_currentTheme;
    NSMutableDictionary *_themeConfig;
    NSMutableDictionary *_theme;
    NSMutableDictionary *_resourcesDic;
    NSString            *_themePath;
}


@synthesize themePath = _themePath;
@synthesize resourcesDic = _resourcesDic;

+ (KIThemeManager *)sharedInstance {
    static KIThemeManager *KITHEME_MANAGER = nil;
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

- (void)clearMemory{
    [_resourcesDic removeAllObjects];
    _resourcesDic = nil;
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

- (NSMutableArray *)themeList {
    NSMutableArray *list = [[self themeConfig] objectForKey:kThemeList];
    if (list == nil) {
        list = [[NSMutableArray alloc] init];
        [[self themeConfig] setObject:list forKey:kThemeList];
        [self synchThemeConfig];
        
        return list;
    }
    else{
        return list;
    }
}

- (void)addTheme:(NSString *)name bundle:(NSString *)bundlePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *toPath = [NSString stringWithFormat:@"%@/%@.bundle",
                        [[NSBundle mainBundle] bundlePath],
                        name];
    [fileManager removeItemAtPath:toPath error:&error];
    [fileManager copyItemAtPath:bundlePath
                         toPath:toPath
                          error:&error];
    
    BOOL isExist = NO;
    for (int i=0; i<[self themeList].count; i++) {
        NSString *key = [[self themeList] objectAtIndex:i];
        if ([key isEqualToString:name]) {
            isExist = YES;
            break;
        }
    }
    
    if (!isExist) {
        [[self themeList] addObject:name];
        [self synchThemeConfig];
    }
}

- (void)changeTheme:(NSString *)name {
    if (![name isEqualToString:_currentTheme]) {
        _currentTheme = name;
        
        [[self themeConfig] setObject:_currentTheme forKey:kCurrentTheme];
        [self synchThemeConfig];
        
        [_resourcesDic removeAllObjects];
        
        [self initTheme];
        
        [self setThemePath:[NSString stringWithFormat:@"%@/%@.bundle/",
                            [[NSBundle mainBundle] bundlePath],
                            [[KIThemeManager sharedInstance] currentTheme]]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChange object:nil];
    }
}

- (NSString *)themePath {
    if (_themePath == nil) {
        _themePath = [NSString stringWithFormat:@"%@/%@.bundle/",
                      [[NSBundle mainBundle] bundlePath],
                      [[KIThemeManager sharedInstance] currentTheme]];
    }
    return _themePath;
}

- (NSString *)currentTheme {
    if (_currentTheme == nil) {
        _currentTheme = [[self themeConfig] objectForKey:kCurrentTheme];
        
        if (_currentTheme == nil) {
             _currentTheme = @"default";
            
            [[self themeConfig] setObject:_currentTheme forKey:kCurrentTheme];
            [self synchThemeConfig];
        }
    }
    return _currentTheme;
}

+ (NSString *)currentTheme {
    return [[KIThemeManager sharedInstance] currentTheme];
}

+ (void)changeTheme:(NSString *)name {
    [[KIThemeManager sharedInstance] changeTheme:name];
}

+ (UIImage *)imageWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *imageName = [[[KIThemeManager sharedInstance] theme] objectForKey:key];
    
    if ([imageName hasPrefix:@"&"]) {
        return [KIThemeManager imageWithKey:[imageName substringFromIndex:1]];
    }
    
    UIImage *image = [[[KIThemeManager sharedInstance] resourcesDictionary] objectForKey:key];
    
    if (image == nil || ![image isKindOfClass:[UIImage class]]) {
        NSString *filePath = [NSString stringWithFormat:@"%@%@",
                              [[KIThemeManager sharedInstance] themePath],
                              imageName];
        
        image = [[UIImage alloc] initWithContentsOfFile:filePath];
        
        if (image == nil) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", key]];
        }
        
        if (image != nil) {
            [[[KIThemeManager sharedInstance] resourcesDictionary] setObject:image forKey:key];
        }
                
#ifdef DEBUG
//        KILog(@"image: %@, %@", filePath, image);
#endif
    }
    return image;
}

+ (UIColor *)colorWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *colorString = [[[KIThemeManager sharedInstance] theme] objectForKey:key];
    
    if ([colorString hasPrefix:@"&"]) {
        return [KIThemeManager colorWithKey:[colorString substringFromIndex:1]];
    }
    
    UIColor *color = [[[KIThemeManager sharedInstance] resourcesDictionary] objectForKey:key];
    
    if (color == nil || ![color isKindOfClass:[UIColor class]]) {
           
        if ([colorString hasPrefix:@"#"]) {
            color = [KIThemeManager colorWithHex:colorString];
        } else {
            NSArray *colorList = [colorString componentsSeparatedByString:@","];
            
            if ([colorList count] > 3) {
                CGFloat r = [[colorList objectAtIndex:0] floatValue];
                CGFloat g = [[colorList objectAtIndex:1] floatValue];
                CGFloat b = [[colorList objectAtIndex:2] floatValue];
                CGFloat a = [[colorList objectAtIndex:3] floatValue];
                
                if (r>1.0f) {
                    r= r/255.0f;
                }
                
                if (g>1.0f) {
                    g= g/255.0f;
                }
                
                if (b>1.0f) {
                    b= b/255.0f;
                }
                
                color = [UIColor colorWithRed:r
                                        green:g
                                         blue:b
                                        alpha:a];
            } else {
//                color = [UIColor blackColor];
            }
        }
        
        if (color != nil) {
            [[[KIThemeManager sharedInstance] resourcesDictionary] setObject:color forKey:key];
        }
    }
    return color;
}


+ (UIColor *)colorWithHex:(NSString *)hex {
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    hex = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    NSInteger length = hex.length;
    
    if (length < 3) {
        return nil;
    }
    
    unsigned int r, g, b, a=1.0f;
    
    int step = length>=6?2:1;
    int start = 0;
    
    [KIThemeManager scann:&r from:hex range:NSMakeRange(start, step)];
    start += step;
    [KIThemeManager scann:&g from:hex range:NSMakeRange(start, step)];
    start += step;
    [KIThemeManager scann:&b from:hex range:NSMakeRange(start, step)];
    
    if (length == 4 || length == 8) {
        start += step;
        [KIThemeManager scann:&a from:hex range:NSMakeRange(start, step)];
    }
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+ (void)scann:(unsigned int *)value from:(NSString *)from range:(NSRange)range {
    NSString *temp = [from substringWithRange:range];
    if (range.length == 1) {
        temp = [NSString stringWithFormat:@"%@%@", temp, temp];
    }
    [[NSScanner scannerWithString:temp] scanHexInt:value];
}

+ (UIFont *)fontWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *fontString = [[[KIThemeManager sharedInstance] theme] objectForKey:key];
    
    if ([fontString hasPrefix:@"&"]) {
        return [KIThemeManager fontWithKey:[fontString substringFromIndex:1]];
    }
    
    UIFont *font = [[[KIThemeManager sharedInstance] resourcesDictionary] objectForKey:key];
    
    if (font == nil || ![font isKindOfClass:[UIFont class]]) {
        
        NSArray *fontList = [fontString componentsSeparatedByString:@","];
        
        if (fontList.count >= 2) {
            font = [UIFont fontWithName:[fontList objectAtIndex:0]
                                   size:[[fontList objectAtIndex:1] floatValue]];
        } else {
            fontString = [fontList objectAtIndex:0];
            
            if ([fontString floatValue] >= CGFLOAT_DEFINED) {
                font = [UIFont systemFontOfSize:[fontString floatValue]];
            } else {
                font = [UIFont fontWithName:fontString size:12.0f];
            }
        }
        
        if (font != nil) {
            [[[KIThemeManager sharedInstance] resourcesDictionary] setObject:font forKey:key];
        }
    }
    
    return font;
}

#pragma private method
- (NSString *)themeConfigFilePath {
    return [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], kThemeConfigFile];
}

- (NSMutableDictionary *)themeConfig {
    if (_themeConfig == nil) {
        _themeConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:[self themeConfigFilePath]];
        if (_themeConfig == nil) {
            _themeConfig = [[NSMutableDictionary alloc] init];
            [self synchThemeConfig];
        }
    }
    return _themeConfig;
}

- (NSMutableDictionary *)theme {
    if (_theme == nil) {
        [self initTheme];
    }
    return _theme;
}

- (void)synchThemeConfig {
    [[self themeConfig] writeToFile:[self themeConfigFilePath]
                         atomically:YES];
}

- (void)initTheme {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.bundle/%@",
                          [[NSBundle mainBundle] bundlePath],
                          [self currentTheme],
                          kThemeFile];
    _theme = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
}


@end

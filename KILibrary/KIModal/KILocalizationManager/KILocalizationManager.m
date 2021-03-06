//
//  KILocalizationManager.m
//
//
//  Created by chen on 12-8-20.
//
//

#import "KILocalizationManager.h"

#define kDefaultLanguage @"defaultLanguage"

#define kLocalizationFile @"localization.plist"

@interface KILocalizationManager(private)

- (void)changeLanguage:(NSString *)language;
- (void)initLanguage;
- (NSArray *)languages;
- (NSString *)currentLanguage;
- (NSString *)localizationWithKey:(NSString *)key;

@end

@implementation KILocalizationManager {
    NSBundle    *_bundle;
    NSString    *_currentLanguage;
}

static KILocalizationManager *KILOCALIZATION_MANAGER;

+ (KILocalizationManager *)sharedInstance {
    static dispatch_once_t localizationManagerToken;
    dispatch_once(&localizationManagerToken, ^{
        if (KILOCALIZATION_MANAGER == nil) {
            KILOCALIZATION_MANAGER = [[KILocalizationManager alloc] init];
        }
    });
    return KILOCALIZATION_MANAGER;
}

+ (NSArray *)languages {
    return [[KILocalizationManager sharedInstance] languages];
}

+ (NSString *)currentLanguage {
    return [[KILocalizationManager sharedInstance] currentLanguage];
}

+ (void)changeLocalization:(NSString *)language {
    [[KILocalizationManager sharedInstance] changeLocalization:language];
}

+ (NSString *)localizationWithKey:(NSString *)key {
    return [[KILocalizationManager sharedInstance] localizationWithKey:key];
}

- (id)init {
    if (KILOCALIZATION_MANAGER == nil) {
        if (self = [super init]) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
            NSString *currentLanguage = [languages objectAtIndex:0];
            
            NSDictionary *language = [NSDictionary dictionaryWithObject:currentLanguage forKey:kDefaultLanguage];
            [defaults registerDefaults:language];
            [defaults synchronize];
            
            _currentLanguage = [defaults objectForKey:kDefaultLanguage];
            
            [self initLanguage];
            
            KILOCALIZATION_MANAGER = self;
        }
    }
    return KILOCALIZATION_MANAGER;
}

- (void)changeLocalization:(NSString *)language {
    if (![_currentLanguage isEqualToString:language]) {
        _currentLanguage = language;
        
        [[NSUserDefaults standardUserDefaults] setObject:_currentLanguage forKey:kDefaultLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self initLanguage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocalizationDidChange object:nil];
    }
}

- (void)initLanguage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
                                                     ofType:@"strings"
                                                inDirectory:nil
                                            forLocalization:_currentLanguage];
    if (path == nil) {
        path = [[NSBundle mainBundle] pathForResource:@"InfoPlist"
                                               ofType:@"strings"
                                          inDirectory:nil
                                      forLocalization:_currentLanguage];
    }
    
    NSString *LocalizableBundlePath = [path stringByDeletingLastPathComponent];
    BOOL isPath = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:LocalizableBundlePath isDirectory:&isPath]) {

    } ;
    
    _bundle = [[NSBundle alloc] initWithPath:LocalizableBundlePath];
    
    if (_bundle == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
                                                         ofType:@"strings"
                                                    inDirectory:nil
                                                forLocalization:@"en"];
        if (path == nil) {
            path = [[NSBundle mainBundle] pathForResource:@"InfoPlist"
                                                   ofType:@"strings"
                                              inDirectory:nil
                                          forLocalization:@"en"];
        }
        
        _bundle = [[NSBundle alloc] initWithPath:[path stringByDeletingLastPathComponent]];
    }
}

- (NSArray *)languages {
    if (_localizationList == nil) {
        _localizationList = [NSArray arrayWithContentsOfFile:[self localizationFilePath]];
    }
    return _localizationList;
}

- (NSString *)currentLanguage {
    return _currentLanguage;
}

- (NSString *)localizationWithKey:(NSString *)key {
    NSString *returnString = NSLocalizedStringFromTableInBundle(key, @"Localizable", _bundle, nil);
    return returnString;
}

- (NSString *)localizationFilePath {
    return [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], kLocalizationFile];
}

@end

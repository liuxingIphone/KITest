//
//  KILocalizationManager.h
//  Kitalker
//
//  Created by chen on 12-8-20.
//
//

#import <Foundation/Foundation.h>

#define kLocalizationDidChange @"localizationDidChange"

#define KILocalization(key) [KILocalizationManager localizationWithKey:key]

@interface KILocalizationManager : NSObject {
     NSArray *_localizationList;
}

+ (NSArray *)languages;

+ (NSString *)currentLanguage;

+ (void)changeLocalization:(NSString *)language;

+ (NSString *)localizationWithKey:(NSString *)key;

@end

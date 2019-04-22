//
//  NSDictionary+KIAdditions.m
//  Kitalker
//
//  Created by chen on 12-11-28.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import "NSDictionary+KIAdditions.h"

@implementation NSDictionary (KIAdditions)

- (BOOL)boolValueForKey:(id)key {
    return [[self objectForKey:key] boolValue];
}

- (int)intValueForKey:(id)key {
    return [[self objectForKey:key] intValue];
}

- (NSInteger)integerValueForKey:(id)key {
    return [[self objectForKey:key] integerValue];
}

- (float)floatValueForKey:(id)key {
    return [[self objectForKey:key] floatValue];
}

- (double)doubleValueForKey:(id)key {
    return [[self objectForKey:key] doubleValue];
}

- (NSString *)stringValueForKey:(id)key {
    id value = [self objectForKey:key];
    if (value == [NSNull null] || value == nil) {
        value = @"";
    }
    if (![value isKindOfClass:[NSString class]]) {
        value = [[NSString alloc] initWithFormat:@"%@", value];
    }
    return value;
}

- (id)valueObjectForKey:(id)aKey{
    if (!self || !aKey) {
        return nil;
    }
    
    if ([[self objectForKey:aKey] isKindOfClass:[NSNumber class]]) {
        
        return [[self objectForKey:aKey] stringValue];
    }else if ([[self objectForKey:aKey] isKindOfClass:[NSNull class]] || ![self objectForKey:aKey]){
        return @"";
    }
    
    return [self objectForKey:aKey];
}

@end

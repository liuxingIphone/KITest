//
//  UserManager.m
//  AssistantHD
//
//  Created by beartech on 14-5-26.
//  Copyright (c) 2014年 beartech. All rights reserved.
//

#import "UserManager.h"

#define LoginUserDefaultsInformation @"LoginUserDefaultsInformation"

// NSString *const NotificationName_ModifyUserInfoFinished = @"NotificationName_ModifyUserInfoFinished";


@interface UserManager () {
    NSMutableDictionary *_userInformation;
    NSString *_userId;
    BOOL _isLogin;
    BOOL _isChangePasswor;
}

@end

static UserManager *UserManager_defaultManager = nil;
@implementation UserManager


+ (UserManager *)defaultManager {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        UserManager_defaultManager = [[UserManager alloc] init];
    });
    return UserManager_defaultManager;
}


- (id)init {
    if (self = [super init]) {
        _userInformation = [[NSMutableDictionary alloc]init];
        _isLogin = [[self objectForKey:User_IsLogin] boolValue];
        _isChangePasswor = [[self objectForKey:User_IsChangePw] boolValue];
        
        NSDictionary *dictionary = [self objectForKey:LoginUserDefaultsInformation];
        if (dictionary && [dictionary count]>0) {
            [_userInformation setValuesForKeysWithDictionary:dictionary];
            _token = [dictionary objectForKey:UserKey_token];
        }
    }
    return self;
}

- (void)setIsLogin:(BOOL)islogin {
    _isLogin = islogin;
    [self setObject:@(islogin) forKey:User_IsLogin];
}

- (BOOL)isLogin{
    if (_isLogin) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)logout{
    [self setIsLogin:NO];
    
    
}


#pragma mark ==================================================
#pragma mark == 更换密码
#pragma mark ==================================================
- (BOOL)isChangePassword {
    return _isChangePasswor;
}

- (void)noChangePassword{
    _isChangePasswor = NO;
    [self setObject:@(_isChangePasswor) forKey:User_IsChangePw];
}

- (void)yesChangePassword {
    _isChangePasswor = YES;
    [self setObject:@(_isChangePasswor) forKey:User_IsChangePw];
}

#pragma mark ==================================================
#pragma mark == 获取用户信息
#pragma mark ==================================================
/**
 获取用户信息（全部）
 */
- (NSDictionary*)userInformation{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValuesForKeysWithDictionary:_userInformation];
    return dic;
}

/**
 获取用户信息（字段）
 */
- (id)userInformationForKey:(NSString*)key{
    return [_userInformation objectForKey:key];
}


#pragma mark ==================================================
#pragma mark == 数据存储
#pragma mark ==================================================
/**
 删除用户信息（全部）
 */
- (void)removeUserInformation{
    [_userInformation removeAllObjects];
    
    [self removeObjectForKey:LoginUserDefaultsInformation];
}

/**
 保存用户信息（全部）
 */
- (void)saveUserInformation:(NSDictionary*)dictionary{
    [_userInformation setValuesForKeysWithDictionary:dictionary];
    
    [self setObject:_userInformation forKey:LoginUserDefaultsInformation];
}

/**
 保存用户信息（字段）
 */
- (void)saveUserInformationKey:(NSString*)key value:(id)value{
    [_userInformation setObject:value forKey:key];
    [self setObject:_userInformation forKey:LoginUserDefaultsInformation];
}



- (void)setObject:(id)anObject forKey:(NSString *)aKey{
    if ([[UserManager defaultManager] isLogin]) {
        
        //读取UserDefaults信息
        NSMutableDictionary *KKUserDefaultsInformation = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LoginUserDefaultsInformation]];
        if ([anObject isKindOfClass:[NSDictionary class]]) {
            [KKUserDefaultsInformation setObject:[NSMutableDictionary dictionaryWithDictionary:anObject] forKey:aKey];
        }
        else if ([anObject isKindOfClass:[NSArray class]]){
            [KKUserDefaultsInformation setObject:[NSMutableArray arrayWithArray:anObject] forKey:aKey];
        }
        else{
            [KKUserDefaultsInformation setObject:anObject forKey:aKey];
        }
        
        //存储UserDefaults信息
        [[NSUserDefaults standardUserDefaults] setObject:KKUserDefaultsInformation forKey:LoginUserDefaultsInformation];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        NSLog(@"用户未登录 无法保存UserDefaults信息");
    }
}

- (void)removeObjectForKey:(NSString *)aKey{
    if ([[UserManager defaultManager] isLogin]) {
        
        //读取UserDefaults信息
        NSMutableDictionary *KKUserDefaultsInformation = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LoginUserDefaultsInformation]];
        [KKUserDefaultsInformation removeObjectForKey:aKey];
        
        //存储UserDefaults信息
        [[NSUserDefaults standardUserDefaults] setObject:KKUserDefaultsInformation forKey:LoginUserDefaultsInformation];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        NSLog(@"用户未登录 无法删除UserDefaults信息");
    }
}

- (id)objectForKey:(id)aKey{
    if ([[UserManager defaultManager] isLogin]) {
        
        //读取UserDefaults信息
        NSMutableDictionary *KKUserDefaultsInformation = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LoginUserDefaultsInformation]];
        
        id anObject = [KKUserDefaultsInformation objectForKey:aKey];
        if ([anObject isKindOfClass:[NSDictionary class]]) {
            return [NSMutableDictionary dictionaryWithDictionary:anObject];
        }
        else if ([anObject isKindOfClass:[NSArray class]]){
            return [NSMutableArray arrayWithArray:anObject];
        }
        else{
            return [KKUserDefaultsInformation objectForKey:aKey];
        }
    }
    else{
        NSLog(@"用户未登录 无法获取UserDefaults信息");
        return nil;
    }
}

@end

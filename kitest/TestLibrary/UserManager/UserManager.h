//
//  UserManager.h
//  AssistantHD
//
//  Created by beartech on 14-5-26.
//  Copyright (c) 2014年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserKey_token               @"token"
#define UserKey_userId              @"user_id"
#define UserKey_userName            @"user_name"
#define UserKey_account             @"user_account"
#define UserKey_password            @"password"
#define UserKey_birthday            @"birthday"
#define UserKey_phone               @"phone"
#define UserKey_mobile              @"mobile"
#define UserKey_email               @"email"

#define User_IsLogin                @"isLogin"
#define User_IsChangePw             @"isChangePassword"



@interface UserManager : NSObject{
    
}
@property (nonatomic,strong) NSMutableDictionary *userInformation;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,strong) NSString *myScore;


+ (UserManager *)defaultManager;
- (void)setIsLogin:(BOOL)islogin;
- (BOOL)isLogin;
- (void)logout;

#pragma mark ==================================================
#pragma mark == 更换密码
#pragma mark ==================================================
- (BOOL)isChangePassword;
- (void)noChangePassword;
- (void)yesChangePassword;

#pragma mark ==================================================
#pragma mark == 获取用户信息
#pragma mark ==================================================
/**
 获取用户信息（全部）
 */
- (NSDictionary*)userInformation;

/**
 获取用户信息（字段）
 */
- (id)userInformationForKey:(NSString*)key;

#pragma mark ==================================================
#pragma mark == 数据存储
#pragma mark ==================================================
/**
 删除用户信息（全部）
 */
- (void)removeUserInformation;

/**
 保存用户信息（全部）
 */
- (void)saveUserInformation:(NSDictionary*)dictionary;

/**
 保存用户信息（字段）
 */
- (void)saveUserInformationKey:(NSString*)key value:(id)value;





@end

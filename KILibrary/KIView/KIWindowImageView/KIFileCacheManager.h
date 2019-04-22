//
//  KIFileCacheManager.h
//  ProjectK
//
//  Created by beartech on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KIFileCacheManager_Image @"KIFileCacheManager_Image"
#define KIFileCacheManager_Document @"KIFileCacheManager_Document"

typedef NS_ENUM(NSInteger, KIActivityIndicatorViewStyle) {
    KIActivityIndicatorViewStyleWhiteLarge = UIActivityIndicatorViewStyleWhiteLarge,
    KIActivityIndicatorViewStyleWhite  = UIActivityIndicatorViewStyleWhite,
    KIActivityIndicatorViewStyleGray = UIActivityIndicatorViewStyleGray,
    KIActivityIndicatorViewStyleNone = NSNotFound,
};

typedef NS_OPTIONS(NSUInteger, KIControlState) {
    KIControlStateNormal      = UIControlStateNormal,
    KIControlStateHighlighted = UIControlStateHighlighted,
    KIControlStateDisabled    = UIControlStateDisabled,
    KIControlStateSelected    = UIControlStateSelected,
    KIControlStateApplication = UIControlStateApplication,
    KIControlStateReserved    = UIControlStateReserved,
    KIControlStateNone = NSNotFound
};



typedef void(^KIImageLoadCompletedBlock)(NSData *imageData, NSError *error,BOOL isFromRequest);

@interface KIFileCacheManager : NSObject

#pragma mark ==================================================
#pragma mark == 图片缓存
#pragma mark ==================================================

+ (NSString *)getRootCacheFile;

/**
 判断缓存图片是否存在
 1、imageURLString 图片的url
 */
+ (BOOL)isExistCacheImageFile:(NSString*)imageURLString;

/**
 读取缓存图片二进制数据
 1、imageURLString 图片的url
 */
+ (NSData*)readCacheImageFileData:(NSString*)imageURLString;

/**
 保存图片二进制数据
 1、data 图片的二进制数据
 2、imageURLString 图片的url
 */
+ (void)saveImageData:(NSData*)data imageURLString:(NSString*)imageURLString;

/**
 缓存图片文件夹
 */
+ (NSString*)tempImageFilePath;


/**
 清除缓存
 */
+ (void)clearTempImage;

//创建一个Data文件地址
+ (NSString*)tempFileName;


@end

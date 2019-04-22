//
//  KIFileCacheManager.m
//  ProjectK
//
//  Created by beartech on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "KIFileCacheManager.h"
#import "NSDate+KIAdditions.h"

@implementation KIFileCacheManager

#pragma mark ==================================================
#pragma mark == 图片缓存
#pragma mark ==================================================


+ (NSString *)getRootCacheFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//缓存地址
+ (NSString*)tempImageFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempImagePath = [documentsDirectory stringByAppendingPathComponent:@"TempFile/Image"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager contentsOfDirectoryAtPath:tempImagePath error:nil]){
        [fileManager createDirectoryAtPath:tempImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tempImagePath;
}

+ (BOOL)isExistCacheImageFile:(NSString*)imageURLString{
    if (imageURLString && ![imageURLString isKindOfClass:[NSNull class]]) {
        //NSString *filePath = [[self getRootCacheFile] stringByAppendingPathComponent:imageURLString];
        NSString *tempImagePath = [KIFileCacheManager tempImageFilePath];
        NSString *savePathName = [NSString stringWithFormat:@"%@/%@",tempImagePath,[imageURLString lastPathComponent]];
        if (savePathName &&
            [[NSFileManager defaultManager] fileExistsAtPath:savePathName]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

+ (NSData*)readCacheImageFileData:(NSString*)imageURLString{
    NSString *filePath = [ [KIFileCacheManager tempImageFilePath] stringByAppendingPathComponent:[imageURLString lastPathComponent]];
    return [NSData dataWithContentsOfFile:filePath];
}

+ (void)saveImageData:(NSData*)data imageURLString:(NSString*)imageURLString{
    NSString *tempImagePath = [KIFileCacheManager tempImageFilePath];
    
    NSString *savePathName = [NSString stringWithFormat:@"%@/%@",tempImagePath,[imageURLString lastPathComponent]];
    
    [data writeToFile:savePathName atomically:YES];
}

+ (void)clearTempImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempDocumentPath = [documentsDirectory stringByAppendingPathComponent:@"TempFile/Image"];
    [[NSFileManager defaultManager] removeItemAtPath:tempDocumentPath error:nil];
    
}

//创建一个Data文件地址
+ (NSString*)tempFileName{
    //=======================================================================================================
    //当前时间
    NSString *dateStr = [NSDate getStringWithFormatter:@"YYYY-MM-dd-HH-mm-ss-SSS"];
    //随机码
    int value = (arc4random() % 1000) + 1;
    NSString *randomCode = [NSString stringWithFormat:@"%04d",value];
    
    NSString *savePathName = [NSString stringWithFormat:@"%@%@.data",dateStr,randomCode];
    //=======================================================================================================
    
    return savePathName;
}


@end

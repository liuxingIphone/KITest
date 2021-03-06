/*
 #####################################################################
 # File    : FSManager.m
 # Project : ios_51job
 # Created : 2012-08-23
 # DevTeam : 51job Development Team
 # Author  : solomon (xmwen@126.com)
 # Notes   :
 #####################################################################
 ### Change Logs   ###################################################
 #####################################################################
 ---------------------------------------------------------------------
 # Date  :
 # Author:
 # Notes :
 #
 #####################################################################
 */

#import "FSManager.h"

@implementation FSManager


/* 删除一个文件 */
+ (BOOL)deleteFile:(NSString *)path {
	if (nil == path) {
		return NO;
	}
    
	NSFileManager *manager = [NSFileManager defaultManager];
    
	if (![manager fileExistsAtPath:path]) {
		return YES;
	}
    
	if (![manager isDeletableFileAtPath:path]) {
		return NO;
	}
    
	NSError *err = nil;
    
	return [manager removeItemAtPath:path error:&err];
}

/* 判断指定路径是否为一个资源文件 */
+ (BOOL)isResourceFile:(NSString *)path {
	if ([path length] < 1) {
		return NO;
	}

	NSURL   *fullPath = [[NSBundle mainBundle] URLForResource:path withExtension:nil];
    
	NSFileManager *fsm = [NSFileManager defaultManager];
    
	return [fsm fileExistsAtPath:[fullPath path]] && [fsm isReadableFileAtPath:[fullPath path]];
}

/* 判断指定路径是否是一个文件 */
+ (BOOL)isFile:(NSString *)path {
    if (nil == path) {
        return NO;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager fileExistsAtPath:path];
}

/* 判断一个文件是否可写 */
+ (BOOL)isWriteable:(NSString *)path{
    if (nil == path) {
        return NO;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager fileExistsAtPath:path] && [manager isWritableFileAtPath:path];
}

/* 判断一个文件夹是否存在 */
+ (BOOL)isDir:(NSString *)path {
    if (nil == path) {
        return NO;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isFolder = NO;
    
    if (![manager fileExistsAtPath:path isDirectory:&isFolder]) {
        return NO;
    }
    
    return isFolder;
}

/* 获取文件大小 */
+ (NSInteger)getFileSize:(NSString *)path {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSDictionary  *attributes;
	NSNumber      *theFileSize;
    
	if(nil == path || ![manager fileExistsAtPath:path]){
		return 0;
	}
    
	attributes = [manager attributesOfItemAtPath:path error:nil];
    
	if(nil == attributes){
		return 0;
	}
    
	theFileSize = attributes[NSFileSize];
    
	if(nil == theFileSize){
		return 0;
	}
    
	return [theFileSize integerValue];
}

/* 从一个资源文件中读取一个字符串 */
+ (NSString *)stringFromResource:(NSString *)resourceName {
	if (nil == resourceName) {
		return nil;
	}
    
	NSError *err = nil;
	NSURL   *path = [[NSBundle mainBundle] URLForResource:resourceName withExtension:nil];
    
	NSFileManager *manager = [NSFileManager defaultManager];
    
	if (![manager fileExistsAtPath:[path path]] || ![manager isReadableFileAtPath:[path path]]) {
		return nil;
	}
    
	return [NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:&err];
}

/* 从一个资源文件中读取一个NSData数据 */
+ (NSData *)dataFromResource:(NSString *)resourceName {
	if (nil == resourceName) {
		return nil;
	}
    
	NSURL *path = [[NSBundle mainBundle] URLForResource:resourceName withExtension:nil];
    
	NSFileManager *manager = [NSFileManager defaultManager];
    
	if (![manager fileExistsAtPath:[path path]] || ![manager isReadableFileAtPath:[path path]]) {
		return nil;
	}
    
	return [NSData dataWithContentsOfURL:path];
}

/* 从一个文件中反序列化出一个字典 */
+ (NSMutableDictionary *)dictFromPath:(NSString *)path {
	if (nil == path) {
		return nil;
	}
    
	NSFileManager *manager = [NSFileManager defaultManager];
    
	if (![manager fileExistsAtPath:path] || ![manager isReadableFileAtPath:path]) {
		return nil;
	}
    
	return [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

/* 删除某目录下的所有文件 add by yuki */
+ (void)deleteAllFilesFromPath:(NSString *)path {
    if (nil == path) {
        return;
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:path] || ![manager isReadableFileAtPath:path]) {
		return;
	}
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (int i = 0; i < [fileList count]; i++) {
        NSString *filePath = [path stringByAppendingPathComponent:fileList[i]];
        [[NSFileManager defaultManager] removeItemAtPath: filePath error:nil];
    }
}

/* 获取文件的修改时间 */
+ (NSDate *)fileModifyDate:(NSString *)file {
    if (nil == file) {
        return nil;
    }
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
    return [fileAttributes fileModificationDate];
}

/* 获取文件的创建时间 */
+ (NSDate *)fileCreateDate:(NSString *)file {
    if (nil == file) {
        return nil;
    }
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
    return fileAttributes[NSFileCreationDate];
}

@end

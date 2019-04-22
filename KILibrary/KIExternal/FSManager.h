/*
 #####################################################################
 # File    : FSManager.h
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


#import "NSString+KIAdditions.h"

@interface FSManager : NSObject


/* 删除一个文件 */
+ (BOOL)deleteFile:(NSString *)path;

/* 判断指定路径是否为一个资源文件 */
+ (BOOL)isResourceFile:(NSString *)path;

/* 判断指定路径是否是一个文件 */
+ (BOOL)isFile:(NSString *)path;

/* 判断一个文件是否可写 */
+ (BOOL)isWriteable:(NSString *)path;

/* 判断一个文件夹是否存在 */
+ (BOOL)isDir:(NSString *)path;

/* 获取文件大小 */
+ (NSInteger)getFileSize:(NSString *)path;

/* 从一个资源文件中读取一个字符串 */
+ (NSString *)stringFromResource:(NSString *)resourceName;

/* 从一个资源文件中读取一个NSData数据 */
+ (NSData *)dataFromResource:(NSString *)resourceName;

/* 从一个文件中反序列化出一个字典 */
+ (NSMutableDictionary *)dictFromPath:(NSString *)path;

/* 获取文件的修改时间 */
+ (NSDate *)fileModifyDate:(NSString *)fil;

/* 获取文件的创建时间 */
+ (NSDate *)fileCreateDate:(NSString *)file;

/* 删除某目录下的所有文件 */
+ (void)deleteAllFilesFromPath:(NSString *)path;

@end

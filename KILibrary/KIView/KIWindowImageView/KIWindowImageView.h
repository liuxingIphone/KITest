//
//  KIWindowImageView.h
//  Social
//
//  Created by beartech on 13-4-19.
//  Copyright (c) 2013年 ibm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+KIImageCache.h"
#import "KIPageScrollView.h"
#import "KIWindowImageItem.h"

#define KIWindowImageView_URL @"URLString"
#define KIWindowImageView_PlaceHolderImage @"PlaceHolderImage"

@interface KIWindowImageView : UIView<KIPageScrollViewDelegate,KIWindowImageItemDelegate>

+ (void)showImageWithURLString:(NSString*)imageURLString placeholderImage:(UIImage*)image;
+ (void)showImage:(UIImage*)image;

/*
 aImageInformationArray 是一个Dictionary对象，必须包含以下键值对
 #define KIWindowImageView_URL @"URLString"
 #define KIWindowImageView_PlaceHolderImage @"PlaceHolderImage"
 */
+ (void)showImageWithURLStringArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index;

@end

//
//  UIImageView+KIImageCache.h
//  ProjectK
//
//  Created by 刘 波 on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import "KIFileCacheManager.h"
#import <objc/runtime.h>

@interface UIImageView (KIImageCache)

@property (nonatomic, retain, readonly) NSString *imageDataURLString;

- (void)showImageData:(NSData*)imageData;
- (void)showImageData:(NSData*)imageData inFrame:(CGRect)rect;


- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(KIImageLoadCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
              completed:(KIImageLoadCompletedBlock)completedBlock;



@end

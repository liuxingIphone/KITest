//
//  UIButton+KIImageCache.h
//  ProjectK
//
//  Created by 刘 波 on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+KIImageCache.h"
#import "UIImage+KIAdditions.h"
#import "KIFileCacheManager.h"
#import <objc/runtime.h>

@interface UIButton (KIImageCache)

@property (nonatomic, retain, readonly) NSString *imageDataURLString;

- (void)showGIFSubView:(NSData*)data;




/*无状态*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle;

/*状态*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle;

/*GCD块*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(KIImageLoadCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
              completed:(KIImageLoadCompletedBlock)completedBlock;

/*GCD块+状态*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state
              completed:(KIImageLoadCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
              completed:(KIImageLoadCompletedBlock)completedBlock;



#pragma mark ==================================================
#pragma mark ==设置图片 setBackgroundImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder;

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle;


/*状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state;

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle;

/*GCD块*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                        completed:(KIImageLoadCompletedBlock)completedBlock;

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
                        completed:(KIImageLoadCompletedBlock)completedBlock;

/*GCD块+状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state
                        completed:(KIImageLoadCompletedBlock)completedBlock;

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
                        completed:(KIImageLoadCompletedBlock)completedBlock;



@end

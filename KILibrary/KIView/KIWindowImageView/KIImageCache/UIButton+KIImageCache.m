//
//  UIButton+KIImageCache.m
//  ProjectK
//
//  Created by 刘 波 on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "UIButton+KIImageCache.h"
#import "NSString+KIAdditions.h"

#define ButtonGifImageViewTag 20131230

@implementation UIButton (KIImageCache)
@dynamic imageDataURLString;

#pragma mark ==================================================
#pragma mark ==扩展
#pragma mark ==================================================
- (void)setImageDataURLString:(NSString *)imageDataURLString{
    objc_setAssociatedObject(self, @"imageDataURLString", imageDataURLString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)imageDataURLString{
    return objc_getAssociatedObject(self, @"imageDataURLString");
}

#pragma mark ==================================================
#pragma mark ==设置图片 setImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
                 forState:KIControlStateNone
        showActivityStyle:KIActivityIndicatorViewStyleNone
                completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
                 forState:KIControlStateNone
        showActivityStyle:aStyle
                completed:nil];
}

/*状态*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
                 forState:state
        showActivityStyle:KIActivityIndicatorViewStyleNone
                completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle{

    [self setImageWithURL:url
         placeholderImage:placeholder
                 forState:KIControlStateNone
        showActivityStyle:aStyle
                completed:nil];
}

/*GCD块*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(KIImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
                 forState:KIControlStateNone
        showActivityStyle:KIActivityIndicatorViewStyleNone
                completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
              completed:(KIImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
                 forState:KIControlStateNone
        showActivityStyle:KIActivityIndicatorViewStyleNone
                completed:completedBlock];
}

/*GCD块+状态*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state
              completed:(KIImageLoadCompletedBlock)completedBlock{

    [self setImageWithURL:url
         placeholderImage:placeholder
                 forState:state
        showActivityStyle:KIActivityIndicatorViewStyleNone
                completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
               forState:(KIControlState)state
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
              completed:(KIImageLoadCompletedBlock)completedBlock{
    
    if ([KIFileCacheManager isExistCacheImageFile:[url absoluteString]]) {
        NSData *data = [KIFileCacheManager readCacheImageFileData:[url absoluteString]];
        if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
            [self showGIFSubView:data];
        }
        else{
            if (state==KIControlStateNone) {
                [self setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                [self setImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
            }
            else{
                [self setImage:[UIImage imageWithData:data] forState:(UIControlState)state];
            }
        }
        
        if (completedBlock) {
            completedBlock(data,nil,NO);
        }
    }
    else{
        if (state==KIControlStateNone) {
            [self setImage:placeholder forState:UIControlStateNormal];
            [self setImage:placeholder forState:UIControlStateHighlighted];
        }
        else{
            [self setImage:placeholder forState:(UIControlState)state];
        }

        NSURL *imageDataURL = [NSURL URLWithString:[[url absoluteString] URLEncodedString]];
        [self setImageDataURLString:[imageDataURL absoluteString]];
        [self addActivityIndicatorView:aStyle];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageDataURL];
        [request setHTTPMethod:@"get"];
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *error){
                                   if (data &&
                                       ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_JPG] ||
                                        [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_PNG] ||
                                        [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF] ||
                                        [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_TIFF] )) {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if ([[response.URL absoluteString] isEqualToString:[self imageDataURLString]]) {
                                                   if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
                                                       [self showGIFSubView:data];
                                                   }
                                                   else{
                                                       if (state==KIControlStateNone) {
                                                           [self setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                                           [self setImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
                                                       }
                                                       else{
                                                           [self setImage:[UIImage imageWithData:data] forState:(UIControlState)state];
                                                       }
                                                   }
                                               }
                                               [KIFileCacheManager saveImageData:data imageURLString:[url absoluteString]];
                                               if (completedBlock) {
                                                   completedBlock(data,nil,YES);
                                               }
                                           });
                                       }
                                   
                                   if (response) {
                                       if ([[response.URL absoluteString] isEqualToString:[self imageDataURLString]]) {
                                           [self removeActivityIndicatorView];
                                       }
                                   }
                                   else{
                                       [self removeActivityIndicatorView];
                                   }
                               }];
    }
}



#pragma mark ==================================================
#pragma mark ==设置图片 setBackgroundImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder{
    [self setBackgroundImageWithURL:url
                   placeholderImage:placeholder
                           forState:KIControlStateNone
                  showActivityStyle:KIActivityIndicatorViewStyleNone
                          completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle{
    
    [self setBackgroundImageWithURL:url
                   placeholderImage:placeholder
                           forState:KIControlStateNone
                  showActivityStyle:aStyle
                          completed:nil];
}


/*状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state{
    [self setBackgroundImageWithURL:url
                   placeholderImage:placeholder
                           forState:state
                  showActivityStyle:KIActivityIndicatorViewStyleNone
                          completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle{
    
    [self setBackgroundImageWithURL:url
                   placeholderImage:placeholder
                           forState:state
                  showActivityStyle:aStyle
                          completed:nil];

}

/*GCD块*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                        completed:(KIImageLoadCompletedBlock)completedBlock{
    [self setBackgroundImageWithURL:url
                   placeholderImage:placeholder
                           forState:KIControlStateNone
                  showActivityStyle:KIActivityIndicatorViewStyleNone
                          completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
                        completed:(KIImageLoadCompletedBlock)completedBlock{
    
    [self setBackgroundImageWithURL:url
                   placeholderImage:placeholder
                           forState:KIControlStateNone
                  showActivityStyle:aStyle
                          completed:completedBlock];
}

/*GCD块+状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state
                        completed:(KIImageLoadCompletedBlock)completedBlock{
    [self setBackgroundImageWithURL:url
                   placeholderImage:placeholder
                           forState:state
                  showActivityStyle:KIActivityIndicatorViewStyleNone
                          completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                         forState:(KIControlState)state
                showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
                        completed:(KIImageLoadCompletedBlock)completedBlock{
    
    if ([KIFileCacheManager isExistCacheImageFile:[url absoluteString]]) {
        NSData *data = [KIFileCacheManager readCacheImageFileData:[url absoluteString]];
        if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
            [self showGIFSubView:data];
        }
        else{
            if (state==KIControlStateNone) {
                [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
            }
            else{
                [self setBackgroundImage:[UIImage imageWithData:data] forState:(UIControlState)state];

            }
        }
        
        if (completedBlock) {
            completedBlock(data,nil,NO);
        }
    }
    else{
        if (state==KIControlStateNone) {
            [self setBackgroundImage:placeholder forState:UIControlStateNormal];
            [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];
        }
        else{
            [self setBackgroundImage:placeholder forState:(UIControlState)state];
        }

        NSURL *imageDataURL = [NSURL URLWithString:[[url absoluteString] URLEncodedString]];
        [self setImageDataURLString:[imageDataURL absoluteString]];
        [self addActivityIndicatorView:aStyle];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageDataURL];
        [request setHTTPMethod:@"get"];
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *error){
                                   if (data &&
                                       ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_JPG] ||
                                        [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_PNG] ||
                                        [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF] ||
                                        [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_TIFF] )) {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if ([[response.URL absoluteString] isEqualToString:[self imageDataURLString]]) {
                                                   if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
                                                       [self showGIFSubView:data];
                                                   }
                                                   else{
                                                       if (state==KIControlStateNone) {
                                                           [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                                           [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
                                                       }
                                                       else{
                                                           [self setBackgroundImage:[UIImage imageWithData:data] forState:(UIControlState)state];
                                                       }
                                                   }
                                               }

                                               [KIFileCacheManager saveImageData:data imageURLString:[url absoluteString]];
                                               if (completedBlock) {
                                                   completedBlock(data,nil,YES);
                                               }
                                           });
                                       }
                                   
                                   if (response) {
                                       if ([[response.URL absoluteString] isEqualToString:[self imageDataURLString]]) {
                                           [self removeActivityIndicatorView];
                                       }
                                   }
                                   else{
                                       [self removeActivityIndicatorView];
                                   }
                               }];
    }
}



#pragma mark ==================================================
#pragma mark ==通用
#pragma mark ==================================================
- (void)showGIFSubView:(NSData*)data{
    UIImageView *imageView = (UIImageView*)[self viewWithTag:ButtonGifImageViewTag];
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.tag = ButtonGifImageViewTag;
        [self addSubview:imageView];
    }
    [imageView showImageData:data inFrame:imageView.frame];
}

#pragma mark ==================================================
#pragma mark ==通用
#pragma mark ==================================================
- (void)addActivityIndicatorView:(KIActivityIndicatorViewStyle)aStyle{
    if (aStyle==KIActivityIndicatorViewStyleNone) {
        return;
    }
    else if (aStyle==KIActivityIndicatorViewStyleWhiteLarge){
        UIActivityIndicatorView *activeView = (UIActivityIndicatorView*)[self viewWithTag:20141024];
        if (!activeView) {
            activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activeView.tag = 20141024;
            [self addSubview:activeView];
            [activeView startAnimating];
            activeView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        }
        else{
            [self bringSubviewToFront:activeView];
            [activeView startAnimating];
            activeView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        }
    }
    else if (aStyle==KIActivityIndicatorViewStyleWhite){
        UIActivityIndicatorView *activeView = (UIActivityIndicatorView*)[self viewWithTag:20141024];
        if (!activeView) {
            activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activeView.tag = 20141024;
            [self addSubview:activeView];
            [activeView startAnimating];
            activeView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        }
        else{
            [self bringSubviewToFront:activeView];
            [activeView startAnimating];
            activeView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        }
    }
    else if (aStyle==KIActivityIndicatorViewStyleGray){
        UIActivityIndicatorView *activeView = (UIActivityIndicatorView*)[self viewWithTag:20141024];
        if (!activeView) {
            activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activeView.tag = 20141024;
            [self addSubview:activeView];
            [activeView startAnimating];
            activeView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        }
        else{
            [self bringSubviewToFront:activeView];
            [activeView startAnimating];
            activeView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        }
    }
    else{
        
    }
}

- (void)removeActivityIndicatorView{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *activeView in [self subviews]) {
            if ([activeView isKindOfClass:[UIActivityIndicatorView class]] && activeView.tag==20141024) {
                [(UIActivityIndicatorView*)activeView stopAnimating];
                [activeView removeFromSuperview];
            }
        }
    });
}


@end

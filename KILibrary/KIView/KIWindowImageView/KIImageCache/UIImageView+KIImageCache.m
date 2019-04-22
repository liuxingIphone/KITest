//
//  UIImageView+KIImageCache.m
//  ProjectK
//
//  Created by 刘 波 on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "UIImageView+KIImageCache.h"
#import "UIImage+KIAdditions.h"
#import "NSString+KIAdditions.h"

@implementation UIImageView (KIImageCache)
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


- (void)showImageData:(NSData*)imageData{
    
    if ([[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
        NSMutableArray *frames = nil;
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        double total = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        
        NSTimeInterval gifAnimationDuration;
        if (src) {
            size_t l = CGImageSourceGetCount(src);
            if (l >= 1){
                frames = [NSMutableArray arrayWithCapacity: l];
                for (size_t i = 0; i < l; i++) {
                    CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                    NSDictionary *dict = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, 0, NULL));
                    if (dict){
                        width = [[dict objectForKey: (NSString*)kCGImagePropertyPixelWidth] floatValue];
                        height = [[dict objectForKey: (NSString*)kCGImagePropertyPixelHeight] floatValue];
                        NSDictionary *tmpdict = [dict objectForKey: (NSString*)kCGImagePropertyGIFDictionary];
                        total += [[tmpdict objectForKey: (NSString*)kCGImagePropertyGIFDelayTime] doubleValue] * 100;
                    }
                    if (img) {
                        [frames addObject: [UIImage imageWithCGImage: img]];
                        CGImageRelease(img);
                    }
                }
                gifAnimationDuration = total / 100;
                
                CGRect oldFrame = self.frame;
                self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
                self.center = CGPointMake(oldFrame.origin.x+width/2.0, height/2.0);
                self.animationImages = frames;
                self.animationDuration = gifAnimationDuration;
                [self startAnimating];
            }
            
            CFRelease(src);
        }
        
    }
    else{
        self.image = [UIImage imageWithData:imageData];
    }
    
}


- (void)showImageData:(NSData*)imageData inFrame:(CGRect)rect{
    self.frame = rect;
    
    if ([[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
        NSMutableArray *frames = nil;
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        
        //        NSDictionary *gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
        //													 forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        //        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
        //        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, (CFDictionaryRef)gifProperties);
        
        double total = 0;
        //        CGFloat width = 0;
        //        CGFloat height = 0;
        
        NSTimeInterval gifAnimationDuration;
        if (src) {
            size_t l = CGImageSourceGetCount(src);
            if (l >= 1){
                frames = [NSMutableArray arrayWithCapacity: l];
                for (size_t i = 0; i < l; i++) {
                    CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                    NSDictionary *dict = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, 0, NULL));
                    if (dict){
                        //                        width = [[dict objectForKey: (NSString*)kCGImagePropertyPixelWidth] floatValue];
                        //                        height = [[dict objectForKey: (NSString*)kCGImagePropertyPixelHeight] floatValue];
                        NSDictionary *tmpdict = [dict objectForKey: (NSString*)kCGImagePropertyGIFDictionary];
                        total += [[tmpdict objectForKey: (NSString*)kCGImagePropertyGIFDelayTime] doubleValue] * 100;
                    }
                    if (img) {
                        [frames addObject: [UIImage imageWithCGImage: img]];
                        CGImageRelease(img);
                    }
                }
                gifAnimationDuration = total / 100;
                
                self.animationImages = frames;
                self.animationDuration = gifAnimationDuration;
                [self startAnimating];
            }
            
            CFRelease(src);
        }
    }
    else{
        self.image = [UIImage imageWithData:imageData];
    }
}


#pragma mark ==================================================
#pragma mark ==设置图片
#pragma mark ==================================================
/*普通*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
        showActivityStyle:KIActivityIndicatorViewStyleNone
                completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
        showActivityStyle:aStyle
                completed:nil];
}


/*GCD*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(KIImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
     showActivityStyle:KIActivityIndicatorViewStyleNone
                completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KIActivityIndicatorViewStyle)aStyle
              completed:(KIImageLoadCompletedBlock)completedBlock{
    
    if ([KIFileCacheManager isExistCacheImageFile:[url absoluteString]]) {
        NSData *data = [KIFileCacheManager readCacheImageFileData:[url absoluteString]];
        [self showImageData:data inFrame:self.frame];
        if(completedBlock){
            completedBlock(data,nil,NO);
        }
    }
    else{
        self.image = placeholder;
        
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
 
                                           if ([[response.URL absoluteString] isEqualToString:[self imageDataURLString]]) {
                                               [self showImageData:data inFrame:self.frame];
                                           }
                                           [KIFileCacheManager saveImageData:data imageURLString:[url absoluteString]];
                                           if(completedBlock){
                                               completedBlock(data,nil,YES);
                                           }
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

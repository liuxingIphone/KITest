//
//  KIImageCropperViewController.h
//  ChineseTastes
//
//  Created by chen on 13-7-8.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KILocalizationManager.h"
#import "KIImageCropperView.h"

@interface KIImageCropperViewController : UIViewController {
    CGSize              _cropSize;
    UIImage             *_image;
    KIImageCropperView  *_imageCropperView;
    void(^_croppedImage)(UIImage *image);
}

- (id)initWithImage:(UIImage *)image cropSize:(CGSize)cropSize;

- (void)setCroppedImage:(void(^)(UIImage *image))block;

@end

//
//  KIImagesPickerController.h
//  QBImagePickerControllerDemo
//
//  Created by HuamoMac on 15/10/15.
//  Copyright © 2015年 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KIImagesPickerControllerDelegate ;

@interface KIImagesPickerController : NSObject


+ (void)showWithDelegate:(id<KIImagesPickerControllerDelegate>)delegate;


@end


@protocol KIImagesPickerControllerDelegate <NSObject>


@optional
- (void)imagesPickerControllerDidCancle:(KIImagesPickerController *)imagesPickerController;

- (void)imagesPickerController:(KIImagesPickerController *)imagesPickerController didPickedImage:(UIImage *)didPickedImage;

- (void)imagesPickerController:(KIImagesPickerController *)imagesPickerController didPickedImages:(NSArray *)didPickedImages;

@end
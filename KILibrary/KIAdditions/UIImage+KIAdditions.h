//
//  UIImage+KIImage.h
//  Kitalker
//
//  Created by chen on 12-8-3.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (KIAdditions)

/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/
- (UIImage *)resizeTo:(CGSize)size;

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

/*等比例缩小图片至该宽度*/
- (UIImage *)scaleWithWidth:(CGFloat)width;

/*等比例缩小图片至该高度*/
- (UIImage *)scaleWithHeight:(CGFloat)heigh;

/*裁切*/
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

/*修正拍照图片方向*/
- (UIImage *)fixOrientation;

- (UIImage *)decoded;

- (UIImage *)addMark:(NSString *)mark textColor:(UIColor *)textColor font:(UIFont *)font point:(CGPoint)point;

- (UIImage *)addCreateTime;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

#define UIImageExtensionType_PNG  @"png"
#define UIImageExtensionType_JPG  @"jpeg"
#define UIImageExtensionType_GIF  @"gif"
#define UIImageExtensionType_TIFF @"tiff"
+ (NSString *) contentTypeExtensionForImageData:(NSData *)data;

- (UIImage*)convertImageToScale:(double)scale;







/**
 *  压缩图片：http://www.jianshu.com/p/974a9537d9f7
 *
 *  @param image       需要压缩的图片
 *  @param fImageBytes 希望压缩后的大小(以KB为单位)
 *
 *  @return 压缩后的图片
 */
+ (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *image))block;


//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;



@end

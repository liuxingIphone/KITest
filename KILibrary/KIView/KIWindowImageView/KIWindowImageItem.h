//
//  KIWindowImageItem.h
//  ProjectK
//
//  Created by beartech on 14-8-22.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KIWindowImageItemDelegate;

@interface KIWindowImageItem : UIView<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,retain)UIImageView *myImageView;
@property (nonatomic,retain)UIScrollView *myScrollView;
@property (nonatomic,retain)UIImage  *imageDefault;
@property (nonatomic,retain)NSString *image_URLString;

@property (nonatomic,assign)id<KIWindowImageItemDelegate> delegate;

- (void)reloaWithImageURLString:(NSString*)aImageURLString
               placeholderImage:(UIImage*)aPlaceholderImage;

@end


@protocol KIWindowImageItemDelegate <NSObject>

- (void)KIWindowImageItem:(KIWindowImageItem*)itemView isGIF:(BOOL)isGIF;

- (void)KIWindowImageItemSingleTap:(KIWindowImageItem*)itemView;

- (void)KIWindowImageItemLongPressed:(KIWindowImageItem*)itemView;

@end
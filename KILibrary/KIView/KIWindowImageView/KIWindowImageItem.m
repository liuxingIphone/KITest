//
//  KIWindowImageItem.m
//  ProjectK
//
//  Created by beartech on 14-8-22.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KIWindowImageItem.h"
#import "UIButton+KIImageCache.h"
#import "UIImageView+KIImageCache.h"
#import "NSString+KIAdditions.h"

@interface UIScrollView (TouchScrollView)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@implementation UIScrollView (TouchScrollView)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}
@end

@implementation KIWindowImageItem
@synthesize myScrollView,myImageView;
@synthesize imageDefault,image_URLString;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 初始化界面
#pragma mark ==================================================
- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.bounces = YES;
    myScrollView.minimumZoomScale = 1.0;
    myScrollView.maximumZoomScale = 10.0;
    myScrollView.delegate = self;
    myScrollView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
    myImageView.contentMode = UIViewContentModeScaleAspectFit;
    myImageView.backgroundColor = [UIColor clearColor];
    [myScrollView addSubview:myImageView];
    [self addSubview:myScrollView];
    //    [myImageView setBorderColor:[UIColor redColor] width:5.0];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapGestureRecognizer.delegate = self;
    [myScrollView addGestureRecognizer:tapGestureRecognizer];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressGesture.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    [longPressGesture setDelegate:self];
    [myScrollView addGestureRecognizer:longPressGesture];
}

- (void)reloaWithImageURLString:(NSString*)aImageURLString
               placeholderImage:(UIImage*)aPlaceholderImage{
    
    self.imageDefault = aPlaceholderImage;
    
    self.image_URLString = aImageURLString;
    
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[UIActivityIndicatorView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (aImageURLString) {
        if ([[[aImageURLString lastPathComponent] lowercaseString] hasSuffix:@"gif"]) {
            NSString *tempString = [aImageURLString stringByReplacingOccurrencesOfString:[aImageURLString lastPathComponent] withString:@""];
            self.image_URLString = [tempString stringByAppendingString:[aImageURLString lastPathComponent]];
            if (delegate && [delegate respondsToSelector:@selector(KIWindowImageItem:isGIF:)]) {
                [delegate KIWindowImageItem:self isGIF:YES];
            }
        }
        else{
            self.image_URLString = aImageURLString;
            if (delegate && [delegate respondsToSelector:@selector(KIWindowImageItem:isGIF:)]) {
                [delegate KIWindowImageItem:self isGIF:NO];
            }
        }
        
        if (aPlaceholderImage) {
            CGFloat scale = 0.6;
            CGFloat X = 0;
            CGFloat Y = 0;
            CGFloat WW = self.frame.size.width*scale;
            CGFloat HH = self.frame.size.height*scale;
            
            BOOL isNotOK = YES;
            //小图片
            if (aPlaceholderImage.size.width<WW && aPlaceholderImage.size.height<HH) {
                X = (self.frame.size.width-aPlaceholderImage.size.width)/2.0;
                Y = (self.frame.size.height-aPlaceholderImage.size.height)/2.0;
                myImageView.frame = CGRectMake(X, Y, aPlaceholderImage.size.width, aPlaceholderImage.size.height);
                isNotOK = NO;
            }
            
            //都高了
            if (isNotOK) {
                CGFloat WScale = aPlaceholderImage.size.width/WW;
                CGFloat HScale = aPlaceholderImage.size.height/HH;
                //宽为标准
                if (WScale>HScale) {
                    X = (self.frame.size.width-WW)/2.0;
                    Y = (self.frame.size.height-aPlaceholderImage.size.height*(1/WScale))/2.0;
                    myImageView.frame = CGRectMake(X, Y, WW, aPlaceholderImage.size.height*(1/WScale));
                }
                //高为标准
                else{
                    X = (self.frame.size.width-aPlaceholderImage.size.width*(1/HScale))/2.0;
                    Y = (self.frame.size.height-HH)/2.0;
                    myImageView.frame = CGRectMake(X, Y, aPlaceholderImage.size.width*(1/HScale), HH);
                }
            }
            
            myScrollView.minimumZoomScale = 1.0;
            myScrollView.maximumZoomScale = 10.0;
            UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            active.contentMode = UIViewContentModeCenter;
            active.center = self.center;
            active.tag = 1121;
            [self addSubview:active];
            [active startAnimating];
            
            __block UIScrollView *blockScroll = myScrollView;
            __block KIWindowImageItem *blockSelf = self;
            __block UIImageView *blockImage = myImageView;
            [myImageView setImageWithURL:[NSURL URLWithString:[aImageURLString URLEncodedString]] placeholderImage:aPlaceholderImage showActivityStyle:KIActivityIndicatorViewStyleWhite completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {
                
                blockScroll.minimumZoomScale = 1.0;
                blockScroll.maximumZoomScale = 10.0;
                
                UIActivityIndicatorView *active = (UIActivityIndicatorView*)[blockSelf viewWithTag:1121];
                [active removeFromSuperview];
                
                if (isFromRequest) {
                    [UIView animateWithDuration:0.3 animations:^{
                        blockImage.frame = CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height);
                    } completion:^(BOOL finished) {
                        [blockImage showImageData:imageData inFrame:CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height)];
                    }];
                }
                else{
                    blockImage.frame = CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height);
                    [blockImage showImageData:imageData inFrame:CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height)];
                }
            }];
        }
        else{
            myImageView.frame = CGRectMake((self.frame.size.width-5)/2.0, (self.frame.size.height-5)/2.0, 5, 5);
            myImageView.image = nil;
            
            myScrollView.minimumZoomScale = 1.0;
            myScrollView.maximumZoomScale = 1.0;
            UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            active.contentMode = UIViewContentModeCenter;
            active.tag = 1121;
            [self addSubview:active];
            [active startAnimating];
            
            __block UIScrollView *blockScroll = myScrollView;
            __block KIWindowImageItem *blockSelf = self;
            __block UIImageView *blockImage = myImageView;
            [myImageView setImageWithURL:[NSURL URLWithString:[aImageURLString URLEncodedString]] placeholderImage:aPlaceholderImage showActivityStyle:KIActivityIndicatorViewStyleWhite completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {
                
                blockScroll.minimumZoomScale = 1.0;
                blockScroll.maximumZoomScale = 10.0;
                
                UIActivityIndicatorView *active = (UIActivityIndicatorView*)[blockSelf viewWithTag:1121];
                [active removeFromSuperview];
                
                if (isFromRequest) {
                    [UIView animateWithDuration:0.3 animations:^{
                        blockImage.frame = CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height);
                    } completion:^(BOOL finished) {
                        [blockImage showImageData:imageData inFrame:CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height)];
                    }];

                }
                else{
                    blockImage.frame = CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height);
                    [blockImage showImageData:imageData inFrame:CGRectMake(0,0,blockSelf.bounds.size.width,blockSelf.bounds.size.height)];
                }
            }];
        }
    }
    else{        
        myImageView.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
        myScrollView.minimumZoomScale = 1.0;
        myScrollView.maximumZoomScale = 10.0;
        myImageView.image = aPlaceholderImage;
        
        
        if (delegate && [delegate respondsToSelector:@selector(KIWindowImageItem:isGIF:)]) {
            [delegate KIWindowImageItem:self isGIF:NO];
        }
    }
}

//单击
-(void) singleTap:(UITapGestureRecognizer*) tap {
    if (delegate && [delegate respondsToSelector:@selector(KIWindowImageItemSingleTap:)]) {
        [delegate KIWindowImageItemSingleTap:self];
    }
}

//长按
-(void) longPressed:(UITapGestureRecognizer*) tap {
    if (tap.state == UIGestureRecognizerStateBegan) {
        if (delegate && [delegate respondsToSelector:@selector(KIWindowImageItemLongPressed:)]) {
            [delegate KIWindowImageItemLongPressed:self];
        }        
    }
}


#pragma mark ==================================================
#pragma mark == 缩放
#pragma mark ==================================================
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return myImageView;//返回ScrollView上添加的需要缩放的视图
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}


@end

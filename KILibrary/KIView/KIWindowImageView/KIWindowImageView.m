//
//  KIWindowImageView.m
//  Social
//
//  Created by beartech on 13-4-19.
//  Copyright (c) 2013年 ibm. All rights reserved.
//

#import "KIWindowImageView.h"
#import "TKAlertCenter.h"
#import "KILocalizationManager.h"

@interface KIWindowImageView ()<UIActionSheetDelegate>
@property (nonatomic,retain)UIPageControl *myPageControl;
@property (nonatomic,assign)BOOL nowImageIsGIF;

@property (nonatomic,retain)KIPageScrollView *myPageView;
@property (nonatomic,retain)NSMutableArray *imageInformationArray;

@end


@implementation KIWindowImageView
@synthesize myPageControl;
@synthesize myPageView;
@synthesize imageInformationArray;
@synthesize nowImageIsGIF;


+ (void)showImageWithURLString:(NSString*)imageURLString placeholderImage:(UIImage*)image{
    if (imageURLString && ![imageURLString isKindOfClass:[NSNull class]]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:imageURLString forKey:KIWindowImageView_URL];
        if (image && [image isKindOfClass:[UIImage class]]) {
            [dic setObject:image forKey:KIWindowImageView_PlaceHolderImage];
        }
        NSArray *array = [[NSArray alloc] initWithObjects:dic, nil];
        
        KIWindowImageView *windowImageView = [[KIWindowImageView alloc]initWithFrame:window.bounds imageArray:array selectedIndex:0];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
    }
}

+ (void)showImage:(UIImage*)image{
    if (image && [image isKindOfClass:[UIImage class]]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSArray *array = [[NSArray alloc] initWithObjects:dic, nil];
        [dic setObject:image forKey:KIWindowImageView_PlaceHolderImage];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        KIWindowImageView *windowImageView = [[KIWindowImageView alloc]initWithFrame:window.bounds imageArray:array selectedIndex:0];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
    }
}

+ (void)showImageWithURLStringArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index{
    if (aImageInformationArray && [aImageInformationArray isKindOfClass:[NSArray class]]
        && [aImageInformationArray count]>0) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        KIWindowImageView *windowImageView = [[KIWindowImageView alloc]initWithFrame:window.bounds imageArray:aImageInformationArray selectedIndex:index];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
    }
    
}

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        imageInformationArray = [[NSMutableArray alloc]init];
        [imageInformationArray addObjectsFromArray:aImageInformationArray];
        
        self.backgroundColor = [UIColor blackColor];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        myPageView = [[KIPageScrollView alloc] initWithFrame:self.bounds];
        myPageView.delegate = self;
        [myPageView showPageIndex:0 animated:NO];
        [myPageView setPageSpace:10];
        [myPageView reloadData];
        [myPageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:myPageView];
        
        myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
        myPageControl.hidesForSinglePage = YES;
        myPageControl.numberOfPages = [imageInformationArray count];
        myPageControl.currentPage = index;
        myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        myPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:myPageControl];
        
        [UIView beginAnimations:nil context:(__bridge void *)(self)];
        [UIView setAnimationDuration: 0.3];
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        self.transform = CGAffineTransformScale(self.transform, 10, 10);
        [UIView commitAnimations];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 初始化界面
#pragma mark ==================================================

#pragma mark ==================================================
#pragma mark == 消失自己
#pragma mark ==================================================
//隐藏自己
-(void) cancelSelf{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self removeFromSuperview];
    }];
}

#pragma mark ==================================================
#pragma mark == KIPageScrollViewDelegate
#pragma mark ==================================================
- (UIView*)pageView:(KIPageScrollView*)pageView viewForPage:(NSInteger)pageIndex{
    KIWindowImageItem *itemView = (KIWindowImageItem*)[myPageView viewForPageIndex:pageIndex];
    if (!itemView) {
        itemView = [[KIWindowImageItem alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        itemView.delegate = self;
    }
    
    NSString *urlString = [[imageInformationArray objectAtIndex:pageIndex] objectForKey:KIWindowImageView_URL];
    UIImage *defaultImage = [[imageInformationArray objectAtIndex:pageIndex] objectForKey:KIWindowImageView_PlaceHolderImage];
    [itemView reloaWithImageURLString:urlString placeholderImage:defaultImage];
    return itemView;
}

- (NSInteger)numberOfPagesInPageView:(KIPageScrollView*)pageView{
    return [imageInformationArray count];
}

- (BOOL)pageViewCanRepeat:(KIPageScrollView*)pageView{
    return NO;
}

- (void)pageView:(KIPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    myPageControl.currentPage = pageIndex;
    KIWindowImageItem *itemView = (KIWindowImageItem*)[myPageView viewForPageIndex:pageIndex];
    [itemView.myScrollView setZoomScale:1.0 animated:NO];
}


#pragma mark ==================================================
#pragma mark == KIWindowImageItemDelegate
#pragma mark ==================================================
- (void)KIWindowImageItem:(KIWindowImageItem*)itemView isGIF:(BOOL)isGIF{
    nowImageIsGIF = isGIF;
}

- (void)KIWindowImageItemSingleTap:(KIWindowImageItem*)itemView{
    //    CGPoint p = [tap locationInView:tap.view];
    [self cancelSelf];
}

- (void)KIWindowImageItemLongPressed:(KIWindowImageItem*)itemView{
    if (!nowImageIsGIF) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:KILocalization(@"取消") destructiveButtonTitle:nil otherButtonTitles:KILocalization(@"保存到相册"), nil];
        [sheet showInView:self];
    }
}

#pragma mark ****************************************
#pragma mark UIActionSheetDelegate
#pragma mark ****************************************
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//保存到相册
        NSLog(@"保存到相册");
        [self saveNowImage];
    }
    else{//取消
        NSLog(@"取消");
    }
}



#pragma mark ==================================================
#pragma mark == 保存图片
#pragma mark ==================================================
-(void) saveNowImage{
    KIWindowImageItem *itemView = (KIWindowImageItem*)[myPageView viewForPageIndex:myPageView.currentPageIndex];
    UIImageWriteToSavedPhotosAlbum(itemView.myImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

#if 1
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:KILocalization(@"保存成功")];
    }
    else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:KILocalization(@"保存失败")];
    }
}
#endif




@end

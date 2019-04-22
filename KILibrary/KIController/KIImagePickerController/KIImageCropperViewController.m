//
//  KIImageCropperViewController.m
//  ChineseTastes
//
//  Created by chen on 13-7-8.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KIImageCropperViewController.h"

@interface KIImageCropperViewController ()

@end

@implementation KIImageCropperViewController

- (id)initWithImage:(UIImage *)image cropSize:(CGSize)cropSize {
    if (self = [super init]) {
        _image = image;
        _cropSize = cropSize;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    _imageCropperView = [[KIImageCropperView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            CGRectGetWidth(self.view.bounds),
                                                                            CGRectGetHeight(self.view.bounds))];
    [_imageCropperView setCropSize:_cropSize];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [self.view addSubview:_imageCropperView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    [self setNavRightItem:@selector(croppedImage) image:KIThemeImage(@"iconDone") imageH:KIThemeImage(@"iconDoneH")];
    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:KILocalization(@"裁切")
//                                                                           style:UIBarButtonItemStylePlain
//                                                                          target:self
//                                                                          action:@selector(croppedImage)];
//    [rightBarButtonItem setTintColor:[UIColor clearColor]];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    [rightBarButtonItem release];
    
//#if defined(__IPHONE_7_0)
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        self.navigationController.navigationBar.translucent = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
//#endif

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_imageCropperView setImage:_image];
    [_imageCropperView setFrame:CGRectMake(0,
                                        0,
                                        CGRectGetWidth(self.view.bounds),
                                        CGRectGetHeight(self.view.bounds))];
    
    
    
}

- (void)setCroppedImage:(void(^)(UIImage *image))block {
    if (_croppedImage != block) {
        _croppedImage = [block copy];
    }
}

- (void)croppedImage {
    if (_croppedImage != nil) {
        _croppedImage(_imageCropperView.croppedImage);
    }    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

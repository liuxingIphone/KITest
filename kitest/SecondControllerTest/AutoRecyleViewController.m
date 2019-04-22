//
//  AutoRecyleViewController.m
//  kitest
//
//  Created by HuamoMac on 15/10/30.
//  Copyright © 2015年 chen. All rights reserved.
//

#import "AutoRecyleViewController.h"
#import "KIPageScrollView.h"


@interface AutoRecyleViewController () <KIPageScrollViewDelegate>{
    
}
@property (nonatomic,strong) KIPageScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end


@implementation AutoRecyleViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc]initWithArray:@[@"1"]];
    
    [self initSubviews];
}


- (void)initSubviews{
    _scrollView = [[KIPageScrollView alloc]init];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(20, 40, KIApplicationWidth-40, 200);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.clipsToBounds = NO;
    _scrollView.currentPageIndex = 0;
    [_scrollView setPageSpace:5];
    [self.view addSubview:_scrollView];
    [_scrollView reloadData];
    
}


- (UIView*)pageView:(KIPageScrollView*)pageView viewForPage:(NSInteger)pageIndex{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, pageView.width, pageView.height);
    imageView.image = [UIImage imageNamed:@"1024-5.png"];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = imageView.bounds;
    label.backgroundColor = [UIColor clearColor];
    label.text = [_dataArray objectAtIndex:pageIndex];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];
    
    return imageView;
}

- (NSInteger)numberOfPagesInPageView:(KIPageScrollView*)pageView{
    return _dataArray.count;
}

- (BOOL)pageViewCanRepeat:(KIPageScrollView*)pageView{
    
    return NO;
}

- (CGFloat)timeIntervalOfPageViewAutoCycle:(KIPageScrollView *)pageView{
    return .0f;
}


- (void)pageView:(KIPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    //_pageControl.currentPage = pageIndex;
}

@end

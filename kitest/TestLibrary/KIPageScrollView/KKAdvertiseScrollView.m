//
//  KKCircleScrollView.m
//  Assistant
//
//  Created by bearmac on 14-4-22.
//  Copyright (c) 2014年 beartech. All rights reserved.
//


#import "KKAdvertiseScrollView.h"
#import "KKPageControl.h"
#import "KKPageView.h"
#import "UIImageView+KIImageCache.h"


#define JSON_NODE_column_id        @"column_id"
#define JSON_NODE_id               @"id"
#define JSON_NODE_post_browse      @"url"
#define JSON_NODE_post_id          @"post_id"
#define JSON_NODE_post_image       @"cover"
#define JSON_NODE_post_name        @"name"


@interface KKAdvertiseScrollView () <KKPageViewDelegate>{
    
}

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , retain) KKPageView *scrollView;
@property (nonatomic , retain) UIPageControl *pageControl;
@property (nonatomic , retain) UILabel *titleLabel;

@end

@implementation KKAdvertiseScrollView
@synthesize currentPageIndex = _currentPageIndex;
@synthesize dataArray = _dataArray;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize titleLabel = _titleLabel;



- (id)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)array{
    self = [self initWithFrame:frame];
    if (self) {
        self.dataArray = array;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.clipsToBounds = YES;
        self.currentPageIndex = 0;
        
        [self initScrollView];
        [self initPageConView];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    if (dataArray && dataArray.count>0 && dataArray != _dataArray) {
        
        _dataArray = [[NSMutableArray alloc]initWithArray:dataArray];
        
        [_scrollView reloadPages];
        _scrollView.userInteractionEnabled = YES;
        
        [self updateSubviews];
    }
}

- (void)initScrollView{
    
    _scrollView = [[KKPageView alloc]initWithFrame:self.bounds delegate:self showIndex:_currentPageIndex];
    [self addSubview:_scrollView];
}

- (void)initPageConView{
    CGFloat height = 59.5f;
    UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - height, 320, height)];
    bottomView.backgroundColor = [UIColor clearColor];
    //bottomView.image = KIImageWithPath(@"index_title");
    bottomView.userInteractionEnabled = NO;
    [self addSubview:bottomView];
    
    
    CGFloat labelHeight = 25.0f;
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.frame = CGRectMake(20, height - labelHeight, 200, labelHeight);
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:_titleLabel];
    
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.frame = CGRectMake(200, height - labelHeight, 120, labelHeight);
    [bottomView addSubview:_pageControl];
    
    
//    [_pageControl setImage:KIImageWithPath(@"pageCount") currentImage:KIImageWithPath(@"pageCountH")];
    [_pageControl setCurrentPage:0];
}

- (UIView*)pageView:(KKPageView*)pageView viewForPage:(NSInteger)pageIndex{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.backgroundColor = [UIColor clearColor];
    NSString *urlString = [[self.dataArray objectAtIndex:pageIndex] objectForKey:JSON_NODE_post_image];
    //[imageView setImageWithURL:KIImageWithURL(urlString) placeholderImage:KIImageWithPath(@"defa_pro_dtl")];
    NSString *url = [NSString stringWithFormat:@"http://115.28.134.4%@", urlString];
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    //imageView.image = [UIImage imageNamed:@"屏幕快照 2015-04-14 下午7.18.08"];
    imageView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
    [imageView addGestureRecognizer:tapGesture];
    
    return imageView;
}

- (NSInteger)pageViewTotalPages:(KKPageView*)pageView{
    return self.dataArray.count;
}

- (BOOL)pageViewCanRepeat:(KKPageView*)pageView{
    return YES;
}

- (void)pageView:(KKPageView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    _currentPageIndex = pageIndex;
    
    [self updateSubviews];
}

- (void)updateSubviews{
    _pageControl.numberOfPages = self.dataArray.count;
    
    _pageControl.currentPage = _currentPageIndex;
    
    _titleLabel.text = [[self.dataArray objectAtIndex:_currentPageIndex]objectForKey:JSON_NODE_post_name];
    _titleLabel.text = nil;
}


#pragma mark -
#pragma mark - 响应事件

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap {
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(kkAdvertiseScrollView:didSelectedViewWithInfomation:)]) {
        [_delegate kkAdvertiseScrollView:self didSelectedViewWithInfomation:[self.dataArray objectAtIndex:_currentPageIndex]];
    }
}

@end

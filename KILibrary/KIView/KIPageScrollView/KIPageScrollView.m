//
//  KIPageScrollView.m
//  Seagate
//
//  Created by beartech on 14-9-23.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import "KIPageScrollView.h"

typedef enum {
    ScrollDirectionNone = 0,
    ScrollDirectionLeft = 1,
    ScrollDirectionRight = 2
}ScrollDirection;


#pragma mark ==================================================
#pragma mark == UIView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIView (KIPageScrollView_UIViewExtension)
@property (nonatomic, strong, readonly) NSString *KIPageScrollView_PageIndex;
@property (nonatomic, strong, readonly) NSString *KIPageScrollView_Location;
@property (nonatomic, strong, readonly) NSString *KIPageScrollView_Real;
@end

#pragma mark ==================================================
#pragma mark == UIView扩展
#pragma mark ==================================================
@implementation UIView (KIPageScrollView_UIViewExtension)

@dynamic KIPageScrollView_PageIndex,KIPageScrollView_Location;

- (void)setKIPageScrollView_PageIndex:(NSString *)pageIndex{
    objc_setAssociatedObject(self, @"KIPageScrollView_PageIndex", pageIndex, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)KIPageScrollView_PageIndex{
    NSString *returnString = objc_getAssociatedObject(self, @"KIPageScrollView_PageIndex");
    return returnString;
}

- (void)setKIPageScrollView_Location:(NSString *)location{
    objc_setAssociatedObject(self, @"KIPageScrollView_Location", location, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)KIPageScrollView_Location{
    NSString *returnString = objc_getAssociatedObject(self, @"KIPageScrollView_Location");
    return returnString;
}

- (void)setKIPageScrollView_Real:(NSString *)KIPageScrollView_Real{
    objc_setAssociatedObject(self, @"KIPageScrollView_Real", KIPageScrollView_Real, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)KIPageScrollView_Real{
    NSString *returnString = objc_getAssociatedObject(self, @"KIPageScrollView_Real");
    return returnString;
}


@end



#pragma mark ==================================================
#pragma mark ==私有扩展
#pragma mark ==================================================
@interface KIPageScrollView ()<UIScrollViewDelegate> {
    
}
@property(nonatomic,strong) UIScrollView *mainScrollView;
@property(nonatomic,assign) CGFloat nowOffsetX;
@property(nonatomic,assign) NSInteger numberOfPages;
@property(nonatomic,assign) BOOL canRepeat;
@property(nonatomic,assign) CGFloat pageSpace;//页面间距（默认是20:_pageSpace*2）
@property(nonatomic,assign) NSTimeInterval autoScrollTimeInterval;//自动滚动时间间隔

@end

@implementation KIPageScrollView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _currentPageIndex = 0;
        _pageSpace = 10;
        _nowOffsetX = 0;
        _autoScrollTimeInterval = 0;
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-_pageSpace, 0, self.frame.size.width+_pageSpace*2, self.frame.size.height)];
        _mainScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.clipsToBounds = NO;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        [_mainScrollView setShowsHorizontalScrollIndicator:NO];
        _mainScrollView.userInteractionEnabled = YES;
        [self addSubview:_mainScrollView];
    }
    return self;
}

- (void)setPageSpace:(CGFloat)pageSpace{
    if (_pageSpace!=pageSpace) {
        _pageSpace = pageSpace;
        [self reloadData];
    }
}

- (void)reloadData{
    [self endAutoCycleScroll];
    
    _mainScrollView.frame = CGRectMake(-_pageSpace, 0, self.frame.size.width+_pageSpace*2, self.frame.size.height);
    [self showPageIndex:_currentPageIndex animated:NO];
    
    [self setupAutoCycleScroll];
}

//直接刷新试图，没有滚动动画效果
- (void)showPageIndex:(NSInteger)index animated:(BOOL)animated{
    
    BOOL YESDelegate = NO;
    if (_delegate
        && [_delegate respondsToSelector:@selector(pageView:viewForPage:)]
        && [_delegate respondsToSelector:@selector(pageViewCanRepeat:)]
        && [_delegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        YESDelegate = YES;
    }
    NSAssert(YESDelegate, @"KIPage delegate must not be nil");
    
    _numberOfPages = [_delegate numberOfPagesInPageView:self];
    NSAssert(_numberOfPages>0, @"KIPageScrollView delegate must not be nil");
    
    _canRepeat = [_delegate pageViewCanRepeat:self];
    
    if (_numberOfPages<=5) {
        //        if (numberOfPages==1 && !canRepeat) {
        //            _pageSpace = 0;
        //        }
        [self showPageIndex_Few:index  animated:animated];
    }
    else{
        [self showPageIndex_More:index animated:animated];
    }
    
}


#pragma mark ==================================================
#pragma mark == 展示方式
#pragma mark ==================================================
/*布局视图【总页数<=5个页面】*/
- (void)showPageIndex_Few:(NSInteger)index animated:(BOOL)animated{
    
    NSInteger P_old = _currentPageIndex;
    NSInteger P_new = index;
    _currentPageIndex = index;
    
    if (_canRepeat) {
        
        /*移除全部*/
        for (UIView *subView in [_mainScrollView subviews]) {
            if ([subView KIPageScrollView_Real]) {
                [subView removeFromSuperview];
                subView.KIPageScrollView_Real = @"0";
            }
        }
        
        /*定位索引——开始值*/
        NSInteger pageIndex = _currentPageIndex-2;
        if (pageIndex<0) {
            pageIndex = MAX(pageIndex + _numberOfPages, 0);
        }
        
        /*准备视图*/
        NSMutableArray *willViews = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<5; i++) {
            UIView *subPageView = [_delegate pageView:self viewForPage:pageIndex];
            subPageView.KIPageScrollView_PageIndex = [NSString stringWithFormat:@"%ld",(long)pageIndex];
            subPageView.KIPageScrollView_Location = [NSString stringWithFormat:@"%ld",(long)i];
            subPageView.KIPageScrollView_Real = @"1";
            subPageView.frame = CGRectMake(i*_mainScrollView.frame.size.width+_pageSpace, 0, self.frame.size.width,self.frame.size.height);
            [willViews addObject:subPageView];
            
            
            /*索引递增*/
            pageIndex = pageIndex + 1;
            if (pageIndex>_numberOfPages-1) {
                pageIndex = 0;
            }
        }
        
        /*展示视图*/
        for (NSInteger i=0; i<[willViews count]; i++) {
            UIView *subPageView = [willViews objectAtIndex:i];
            subPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [_mainScrollView addSubview:subPageView];
            _mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(subPageView.frame)+_pageSpace, self.frame.size.height);
        }
        
        //设置ScrollView位置
        if (P_new>P_old) {
            //注意：&& _numberOfPages!=2，处理临界情况
            if (P_new==_numberOfPages-1 && _numberOfPages!=2) {
                NSInteger center = ((_numberOfPages-1)/2.0);
                if (P_old<center || center==0) {
                    CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 1*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
        }
        else if (P_new==P_old){
            _nowOffsetX = 2*_mainScrollView.frame.size.width;
            [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:NO];
        }
        else{
            if (P_new==0) {
                NSInteger center = ((_numberOfPages-1)/2.0);
                if (P_old<=center) {
                    CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
            [self.delegate pageView:self didScrolledToPageIndex:_currentPageIndex];
        }
        
    }
    else{
        //还没初始化 || 页面数据变化
        if ([[_mainScrollView subviews] count]==0 || [[_mainScrollView subviews] count]!=_numberOfPages) {
            for (UIView *view in _mainScrollView.subviews) {
                view.hidden = YES;
                [view removeFromSuperview];
            }
            
            for (NSInteger i=0; i<_numberOfPages; i++) {
                UIView *subPageView = [_delegate pageView:self viewForPage:i];
                subPageView.KIPageScrollView_PageIndex = [NSString stringWithFormat:@"%ld",(long)i];
                subPageView.KIPageScrollView_Location = [NSString stringWithFormat:@"%ld",(long)i];
                subPageView.KIPageScrollView_Real = @"1";
                subPageView.frame = CGRectMake(i*_mainScrollView.frame.size.width+_pageSpace, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
                subPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_mainScrollView addSubview:subPageView];
                _mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(subPageView.frame)+_pageSpace, self.frame.size.height);
            }
            
            //设置ScrollView位置
            _nowOffsetX = index*_mainScrollView.frame.size.width;
            [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            
            if ([self.delegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
                [self.delegate pageView:self didScrolledToPageIndex:_currentPageIndex];
            }
        }
        else{
            //设置ScrollView位置
            _nowOffsetX = index*_mainScrollView.frame.size.width;
            [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            
            if ([self.delegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
                [self.delegate pageView:self didScrolledToPageIndex:_currentPageIndex];
            }
        }
    }
}

/*布局视图【总页数>5个页面】*/
- (void)showPageIndex_More:(NSInteger)index animated:(BOOL)animated{
    
    NSInteger P_old = _currentPageIndex;
    NSInteger P_new = index;
    _currentPageIndex = index;
    //    NSInteger pageDifference_ABS = P_new - P_old;
    
    NSInteger pageIndexStart = 0;
    if (_canRepeat) {
        /*定位索引*/
        pageIndexStart = _currentPageIndex-2;
        if (pageIndexStart<0) {
            pageIndexStart = MAX(pageIndexStart + _numberOfPages, 0);
        }
    }
    else{
        /*定位索引*/
        if (_currentPageIndex<=2) {
            pageIndexStart = 0;
        }
        else if (_currentPageIndex>=_numberOfPages-1-2){
            pageIndexStart = _numberOfPages-1-4;
        }
        else{
            pageIndexStart = MAX(_currentPageIndex-2, 0);
        }
    }
    
    NSInteger pageIndexStart01 = pageIndexStart;
    /*准备视图*/
    NSMutableArray *willViews = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<5; i++) {
        UIView *subPageView = [_delegate pageView:self viewForPage:pageIndexStart01];
        [willViews addObject:subPageView];
        
        //NSLog(@"AAA: %ld",(long)pageIndexStart01);
        
        /*索引递增*/
        pageIndexStart01 = pageIndexStart01 + 1;
        if (pageIndexStart01>_numberOfPages-1) {
            pageIndexStart01 = 0;
        }
    }
    
    /*移除全部*/
    for (UIView *subView in [_mainScrollView subviews]) {
        if ([willViews containsObject:subView]) {
            continue;
        }
        else{
            if ([subView KIPageScrollView_Real]) {
                [subView removeFromSuperview];
                subView.KIPageScrollView_Real = @"0";
            }
        }
    }
    
    
    NSInteger pageIndexStart02 = pageIndexStart;
    for (NSInteger i=0; i<[willViews count]; i++) {
        UIView *subPageView = [willViews objectAtIndex:i];
        subPageView.KIPageScrollView_PageIndex = [NSString stringWithFormat:@"%ld",(long)pageIndexStart02];
        subPageView.KIPageScrollView_Location = [NSString stringWithFormat:@"%ld",(long)i];
        subPageView.KIPageScrollView_Real = @"1";
        subPageView.frame = CGRectMake(i*_mainScrollView.frame.size.width+_pageSpace, 0, self.frame.size.width,self.frame.size.height);
        subPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if (!subPageView.superview) {
            [_mainScrollView addSubview:subPageView];
        }
        _mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(subPageView.frame)+_pageSpace, self.frame.size.height);
        /*索引递增*/
        pageIndexStart02 = pageIndexStart02 + 1;
        if (pageIndexStart02>_numberOfPages-1) {
            pageIndexStart02 = 0;
        }
    }
    
    
    if (_canRepeat) {
        //设置ScrollView位置
        if (P_new>P_old) {
            if (P_new==_numberOfPages-1) {
                NSInteger center = ((_numberOfPages-1)/2.0);
                if (P_old<=center) {
                    CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 1*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
        }
        else if (P_new==P_old){
            _nowOffsetX = 2*_mainScrollView.frame.size.width;
            [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:NO];
        }
        else{
            if (P_new==0) {
                NSInteger center = ((_numberOfPages-1)/2.0);
                if (P_old<=center) {
                    CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    _nowOffsetX = 2*_mainScrollView.frame.size.width;
                    [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
        }
    }
    else{
        if (_currentPageIndex<=2) {
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = MAX(_currentPageIndex-1, 0)*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = _currentPageIndex*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                _nowOffsetX = _currentPageIndex*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:NO];
            }
            else{
                CGFloat offsetOld = MIN(_currentPageIndex+1, _numberOfPages-1)*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = _currentPageIndex*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
        }
        else if (_currentPageIndex==_numberOfPages-1-1){
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 3*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                _nowOffsetX = 3*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:NO];
            }
            else{
                CGFloat offsetOld = 4*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 3*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
        }
        else if (_currentPageIndex==_numberOfPages-1-0){
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 4*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                _nowOffsetX = 4*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:NO];
            }
            else{
                //                CGFloat offsetOld = 5*mainScrollView.frame.size.width;
                //                [mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 4*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:NO];
            }
        }
        else{
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = 1*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                _nowOffsetX = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:NO];
            }
            else{
                CGFloat offsetOld = 3*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                _nowOffsetX = 2*_mainScrollView.frame.size.width;
                [_mainScrollView setContentOffset:CGPointMake(_nowOffsetX, 0) animated:animated];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
        [self.delegate pageView:self didScrolledToPageIndex:_currentPageIndex];
    }
    
}


- (UIView*)viewForPageIndex:(NSInteger)aPageIndex{
    UIView *returnView = nil;
    for (UIView *subView in [_mainScrollView subviews]) {
        if ([subView.KIPageScrollView_PageIndex integerValue]==aPageIndex
            && [subView.KIPageScrollView_Real integerValue]==1) {
            returnView = subView;
            break;
        }
    }
    
    //    if (returnView) {
    //        NSLog(@"存在：%d",aPageIndex);
    //    }
    //    else{
    //        NSLog(@"不存在：%d",aPageIndex);
    //    }
    return returnView;
}


#pragma mark ==================================================
#pragma mark ==滚动处理
#pragma mark ==================================================
- (void)scrollViewDidScrolledWithDirection:(ScrollDirection)direction scrollPages:(NSInteger)pages{
    switch (direction) {
        case ScrollDirectionNone:{
            break;
        }
        case ScrollDirectionLeft:{
            
            NSInteger pageNum = _currentPageIndex - pages;
            
            if (pageNum<0) {
                pageNum = pageNum + _numberOfPages;
            }
            
            [self showPageIndex:pageNum animated:NO];
            
            break;
        }
        case ScrollDirectionRight:{
            NSInteger pageNum = _currentPageIndex + pages;
            
            if (pageNum>_numberOfPages-1) {
                pageNum = pageNum - _numberOfPages;
            }
            [self showPageIndex:pageNum animated:NO];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark ==================================================
#pragma mark ==UIScrollViewDelegate
#pragma mark ==================================================

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endAutoCycleScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger scrollPages =  ABS(scrollView.contentOffset.x - _nowOffsetX)/(_mainScrollView.frame.size.width);
    //NSLog(@"滚动了%ld个页面",(long)scrollPages);
    
    if (scrollView.contentOffset.x<_nowOffsetX && scrollPages>0) {
        [self scrollViewDidScrolledWithDirection:ScrollDirectionLeft scrollPages:scrollPages];
    }
    else if (scrollView.contentOffset.x > _nowOffsetX && scrollPages>0 ){
        [self scrollViewDidScrolledWithDirection:ScrollDirectionRight scrollPages:scrollPages];
    }
    else{
        [self scrollViewDidScrolledWithDirection:ScrollDirectionNone scrollPages:scrollPages];
    }
    
    [self performSelector:@selector(beginAutoCycleScroll) withObject:nil afterDelay:_autoScrollTimeInterval];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
}

#pragma mark - 自动循环滚动

//初次设置自动循环滚动
- (void)setupAutoCycleScroll{
    
    if (_delegate && [_delegate respondsToSelector:@selector(timeIntervalOfPageViewAutoCycle:)]) {
        _autoScrollTimeInterval = [_delegate timeIntervalOfPageViewAutoCycle:self];
    }
    
    if ([self canAutoCycleScroll]) {
        [self performSelector:@selector(beginAutoCycleScroll) withObject:nil afterDelay:_autoScrollTimeInterval];
    }
    
}

- (void)endAutoCycleScroll{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginAutoCycleScroll) object:nil];
}

//设置自动轮播
- (void)beginAutoCycleScroll{
    [self endAutoCycleScroll];
    
    
    if ([self canAutoCycleScroll]){
        
        CGFloat offsetWidth = _mainScrollView.width + _mainScrollView.contentOffset.x;
        [_mainScrollView setContentOffset:CGPointMake(offsetWidth, 0) animated:YES];
        
        [self showPageIndex:[self getCurrentPageIndexWithIndex:_currentPageIndex + 1] animated:YES];
        
        [self performSelector:@selector(beginAutoCycleScroll) withObject:nil afterDelay:_autoScrollTimeInterval];
    }
}

//获取是否可以循环滚动
- (BOOL)canAutoCycleScroll{
    
    if (!_delegate) {
        //NSLog(@"代理不能为空！！！");
        return NO;
    }
    
    //自动循环滚动的时间间隔：默认为0，不支持滚动
    if (_autoScrollTimeInterval == 0) {
        //NSLog(@"自动循环滚动时间间隔为0，不能自动轮播");
        return NO;
    }else if (!_canRepeat){
        //NSLog(@"不支持循环滚动");
        return NO;
    }else if (_numberOfPages <= 1){
        //NSLog(@"只有一个view，不能滚动");
        return NO;
    }
    
    return YES;
}

//根据索引值，获取对应的当前索引
- (NSInteger)getCurrentPageIndexWithIndex:(NSInteger)index{
    if (index > _numberOfPages-1) {
        return index-_numberOfPages;//index / numberOfPages;
    }else if (index < 0){
        return index+_numberOfPages;
    }
    return index;
}


@end

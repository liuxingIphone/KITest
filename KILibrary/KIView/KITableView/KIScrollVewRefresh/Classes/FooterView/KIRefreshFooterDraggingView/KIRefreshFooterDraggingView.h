//
//  KIRefreshFooterDraggingView.h
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	KIFDRefreshPulling = 0,
	KIFDRefreshNormal = 1,
	KIFDRefreshLoading = 2,
} KIFDRefreshState;

@protocol KIRefreshFooterDraggingViewDelegate;


@interface KIRefreshFooterDraggingView : UIView{
    __unsafe_unretained id _delegate;
	KIFDRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;

}

@property(nonatomic,assign) id <KIRefreshFooterDraggingViewDelegate> delegate;

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KIRefreshFooterDraggingViewDelegate>)aDelegate;
- (void)startLoadingMore;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView lastUpdatedDate:(NSDate*)aDate;


@end




#pragma mark ==================================================
#pragma mark == KIRefreshFooterDraggingViewDelegate
#pragma mark ==================================================
@protocol KIRefreshFooterDraggingViewDelegate

//触发刷新加载数据
- (void)refreshTableFooterDraggingViewDidTriggerRefresh:(KIRefreshFooterDraggingView*)view;

@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KIUIScrollViewFooterDExtension)

- (void)showRefreshFooterDraggingWithDelegate:(id<KIRefreshFooterDraggingViewDelegate>)aDelegate;
- (void)hideRefreshFooterDragging;
@property (nonatomic, assign, readonly) KIRefreshFooterDraggingView *refreshFooterDragging;
@property (nonatomic, assign, readonly) NSNumber *haveFooterDragging;

@end
















//
//  KIRefreshFooterAutoView.h
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	KIFARefreshNormal = 1,
	KIFARefreshLoading = 2,
} KIFARefreshState;

@protocol KIRefreshFooterAutoViewDelegate;

@interface KIRefreshFooterAutoView : UIView{
    __unsafe_unretained id _delegate;
	KIFARefreshState _state;
    
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <KIRefreshFooterAutoViewDelegate> delegate;

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KIRefreshFooterAutoViewDelegate>)aDelegate;
- (void)startLoadingMore;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView lastUpdatedDate:(NSDate*)aDate;


@end




#pragma mark ==================================================
#pragma mark == KIRefreshFooterAutoViewDelegate
#pragma mark ==================================================
@protocol KIRefreshFooterAutoViewDelegate

//触发刷新加载数据
- (void)refreshTableFooterAutoViewDidTriggerRefresh:(KIRefreshFooterAutoView*)view;

@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KIUIScrollViewFooterAExtension)

- (void)showRefreshFooterAutoWithDelegate:(id<KIRefreshFooterAutoViewDelegate>)aDelegate;
- (void)hideRefreshFooterAuto;
@property (nonatomic, assign, readonly) KIRefreshFooterAutoView *refreshFooterAuto;
@property (nonatomic, assign, readonly) NSNumber *haveFooterAuto;

@end










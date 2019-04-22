//
//  KIRefreshHeaderView.h
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	KIHPullRefreshPulling = 0,
	KIHPullRefreshNormal = 1,
	KIHPullRefreshLoading = 2,
} KIHPullRefreshState;

@protocol KIRefreshHeaderViewDelegate;

@interface KIRefreshHeaderView : UIView{
    __unsafe_unretained id _delegate;
	KIHPullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <KIRefreshHeaderViewDelegate> delegate;

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KIRefreshHeaderViewDelegate>)aDelegate;
- (void)startRefresh;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView lastUpdatedDate:(NSDate*)aDate;


@end


#pragma mark ==================================================
#pragma mark == KIRefreshHeaderViewDelegate
#pragma mark ==================================================
@protocol KIRefreshHeaderViewDelegate

//触发刷新加载数据
- (void)refreshTableHeaderDidTriggerRefresh:(KIRefreshHeaderView*)view;

@end







#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KIUIScrollViewHeaderExtension)

- (void)showRefreshHeaderWithDelegate:(id<KIRefreshHeaderViewDelegate>)aDelegate;
- (void)hideRefreshHeader;
@property (nonatomic, assign, readonly) KIRefreshHeaderView *refreshHeader;
@property (nonatomic, assign, readonly) NSNumber *haveHeader;

@end








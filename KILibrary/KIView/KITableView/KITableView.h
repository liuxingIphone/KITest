//
//  KITableView.h
//  Seagate
//
//  Created by yangyuan on 14-7-16.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIRefreshHeaderView.h"
#import "KIRefreshFooterDraggingView.h"
#import "KIRefreshFooterAutoView.h"


@protocol KIRefreshTableViewDelegate;

@interface KITableView : UITableView

@property (nonatomic, assign) id <KIRefreshTableViewDelegate> refreshDeleagate;

- (void)showRefreshAll;

- (void)showRefreshHeaderAndFooterAuto;

- (void)showRefreshHeaderAndFooterDragging;

- (void)showRefreshAllFooter;

- (void)showRefreshFooterAuto;

- (void)showRefreshFooterDragging;

- (void)showRefreshHeader;

- (void)hideRefreshAll;

- (void)hideRefreshHeaderAndFooterAuto;

- (void)hideRefreshHeaderAndFooterDragging;

- (void)hideRefreshAllFooter;

//- (void)hideRefreshFooterAuto;
//
//- (void)hideRefreshFooterDragging;
//
//- (void)hideRefreshHeader;

- (void)tableViweDidScroll:(UIScrollView *)scrollView;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)startHeaderRefresh;

- (void)startFooterDraggingLoadingMore;

- (void)startFooterAutoLoadingMore;

- (void)stopHeaderRefresh;

- (void)stopFooterAutoLoadingMore;

- (void)stopFooterDraggingLoadingMore;

@end


@protocol KIRefreshTableViewDelegate <NSObject>

@optional
- (void)refreshTableHeaderDidTriggerRefresh:(KIRefreshHeaderView*)view;

- (void)refreshTableFooterAutoViewDidTriggerRefresh:(KIRefreshFooterAutoView*)view ;

- (void)refreshTableFooterDraggingViewDidTriggerRefresh:(KIRefreshFooterDraggingView*)view;

@end
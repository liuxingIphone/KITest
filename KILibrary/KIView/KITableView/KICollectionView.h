//
//  KICollectionView.h
//  Seagate
//
//  Created by yangyuan on 14-8-25.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIRefreshHeaderView.h"
#import "KIRefreshFooterDraggingView.h"
#import "KIRefreshFooterAutoView.h"

@protocol KIRefreshCollectionViewDelegate;

@interface KICollectionView : UICollectionView

@property (nonatomic, assign) id <KIRefreshCollectionViewDelegate> refreshDeleagate;

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

- (void)collectionViweDidScroll:(UIScrollView *)scrollView;

- (void)collectionViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)startHeaderRefresh;

- (void)startFooterDraggingLoadingMore;

- (void)startFooterAutoLoadingMore;

- (void)stopHeaderRefresh;

- (void)stopFooterAutoLoadingMore;

- (void)stopFooterDraggingLoadingMore;

@end

@protocol KIRefreshCollectionViewDelegate <NSObject>

@optional
- (void)refreshCollectionHeaderDidTriggerRefresh:(KIRefreshHeaderView*)view;

- (void)refreshCollectionFooterAutoViewDidTriggerRefresh:(KIRefreshFooterAutoView*)view ;

- (void)refreshCollectionFooterDraggingViewDidTriggerRefresh:(KIRefreshFooterDraggingView*)view;

@end
//
//  KICollectionView.m
//  Seagate
//
//  Created by yangyuan on 14-8-25.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import "KICollectionView.h"

@interface KICollectionView () <KIRefreshHeaderViewDelegate, KIRefreshFooterAutoViewDelegate, KIRefreshFooterDraggingViewDelegate> {
    
    __unsafe_unretained id <KIRefreshCollectionViewDelegate> _refreshDeleagate;
}

@end

@implementation KICollectionView

@synthesize refreshDeleagate = _refreshDeleagate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark -
- (void)showRefreshAll {
    [self showRefreshFooterAutoWithDelegate:self];
    [self showRefreshFooterDraggingWithDelegate:self];
    [self showRefreshHeaderWithDelegate:self];
}

- (void)showRefreshHeaderAndFooterAuto {
    [self showRefreshFooterAutoWithDelegate:self];
    [self showRefreshHeaderWithDelegate:self];
}

- (void)showRefreshHeaderAndFooterDragging {
    [self showRefreshFooterDraggingWithDelegate:self];
    [self showRefreshHeaderWithDelegate:self];
}

- (void)showRefreshAllFooter {
    [self showRefreshFooterAutoWithDelegate:self];
    [self showRefreshFooterDraggingWithDelegate:self];
}

- (void)showRefreshFooterAuto {
    [self showRefreshFooterAutoWithDelegate:self];
}

- (void)showRefreshFooterDragging {
    [self showRefreshFooterDraggingWithDelegate:self];
}

- (void)showRefreshHeader {
    [self showRefreshHeaderWithDelegate:self];
}

#pragma mark -
- (void)hideRefreshAll {
    [self hideRefreshFooterAuto];
    [self hideRefreshFooterDragging];
    [self hideRefreshHeader];
}

- (void)hideRefreshHeaderAndFooterAuto {
    [self hideRefreshHeader];
    [self hideRefreshFooterAuto];
}

- (void)hideRefreshHeaderAndFooterDragging {
    [self hideRefreshHeader];
    [self hideRefreshFooterDragging];
}

- (void)hideRefreshAllFooter {
    [self hideRefreshFooterAuto];
    [self hideRefreshFooterDragging];
}


#pragma mark - delegate
- (void)refreshTableHeaderDidTriggerRefresh:(KIRefreshHeaderView*)view {
    if (_refreshDeleagate && [_refreshDeleagate respondsToSelector:@selector(refreshCollectionHeaderDidTriggerRefresh:)]) {
        [_refreshDeleagate refreshCollectionHeaderDidTriggerRefresh:view];
    }
}

- (void)refreshTableFooterAutoViewDidTriggerRefresh:(KIRefreshFooterAutoView*)view {
    if (_refreshDeleagate && [_refreshDeleagate respondsToSelector:@selector(refreshCollectionFooterAutoViewDidTriggerRefresh:)]) {
        [_refreshDeleagate refreshCollectionFooterAutoViewDidTriggerRefresh:view];
    }
}

- (void)refreshTableFooterDraggingViewDidTriggerRefresh:(KIRefreshFooterDraggingView*)view {
    if (_refreshDeleagate && [_refreshDeleagate respondsToSelector:@selector(refreshCollectionFooterDraggingViewDidTriggerRefresh:)]) {
        [_refreshDeleagate refreshCollectionFooterDraggingViewDidTriggerRefresh:view];
    }
}

#pragma mark -
- (void)collectionViweDidScroll:(UIScrollView *)scrollView{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDidScroll:scrollView];
    }
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDidScroll:scrollView];
    }
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDidScroll:scrollView];
    }
}

- (void)collectionViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDidEndDragging:scrollView];
    }
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDidEndDragging:scrollView];
    }
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDidEndDragging:scrollView];
    }
    
}

#pragma mark -
- (void)startHeaderRefresh {
    [self.refreshHeader startRefresh];
}

- (void)startFooterAutoLoadingMore {
    [self.refreshFooterAuto startLoadingMore];
}

- (void)startFooterDraggingLoadingMore {
    [self.refreshFooterDragging startLoadingMore];
}

- (void)stopHeaderRefresh {
    [self.refreshHeader refreshScrollViewDataSourceDidFinishedLoading:self lastUpdatedDate:[NSDate date]];
}

- (void)stopFooterAutoLoadingMore {
    [self.refreshFooterAuto refreshScrollViewDataSourceDidFinishedLoading:self  lastUpdatedDate:[NSDate date]];
}

- (void)stopFooterDraggingLoadingMore {
    [self.refreshFooterDragging refreshScrollViewDataSourceDidFinishedLoading:self  lastUpdatedDate:[NSDate date]];
}

@end

//
//  KITableView.m
//  Seagate
//
//  Created by yangyuan on 14-7-16.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import "KITableView.h"

@interface KITableView ()<KIRefreshHeaderViewDelegate, KIRefreshFooterAutoViewDelegate, KIRefreshFooterDraggingViewDelegate>
{
    __unsafe_unretained id <KIRefreshTableViewDelegate> _refreshDeleagate;
}
@end

@implementation KITableView

@synthesize refreshDeleagate = _refreshDeleagate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
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
    if (_refreshDeleagate && [_refreshDeleagate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
        [_refreshDeleagate refreshTableHeaderDidTriggerRefresh:view];
    }
}

- (void)refreshTableFooterAutoViewDidTriggerRefresh:(KIRefreshFooterAutoView*)view {
    if (_refreshDeleagate && [_refreshDeleagate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
        [_refreshDeleagate refreshTableFooterAutoViewDidTriggerRefresh:view];
    }
}

- (void)refreshTableFooterDraggingViewDidTriggerRefresh:(KIRefreshFooterDraggingView*)view {
    if (_refreshDeleagate && [_refreshDeleagate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
        [_refreshDeleagate refreshTableFooterDraggingViewDidTriggerRefresh:view];
    }
}

#pragma mark -
- (void)tableViweDidScroll:(UIScrollView *)scrollView{
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

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
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

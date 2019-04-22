//
//  KIRefreshFooterAutoView.m
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KIRefreshFooterAutoView.h"

@implementation KIRefreshFooterAutoView
@synthesize delegate=_delegate;

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KIRefreshFooterAutoViewDelegate>)aDelegate{
    
    if(self = [super initWithFrame:CGRectMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height), scrollView.frame.size.width, scrollView.frame.size.height)]) {
        //NSLog(@"%@",NSStringFromCGRect(self.frame));
        
		self.delegate = aDelegate;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 15.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:18.0f];
		label.textColor = [UIColor whiteColor];
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:KIFARefreshNormal];
        
        [scrollView addSubview:self];
        [scrollView setValue:self forKey:@"refreshFooterAuto"];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 手动刷新
#pragma mark ==================================================
- (void)startLoadingMore{
    if (_state == KIFARefreshLoading) {
        return;
    }
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)v;
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height) {
                
                if ([_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                    [self setState:KIFARefreshLoading];
                    [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.3];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,50.0f, 0.0f)];
                    [UIView commitAnimations];
                }
            }
            else{
                [self setState:KIFARefreshNormal];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
                [UIView commitAnimations];
            }
        }
        else{
            if (scrollView.contentOffset.y>0) {
                if ([_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                    [self setState:KIFARefreshLoading];
                    [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.3];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 scrollView.frame.size.height-scrollView.contentSize.height+50,
                                                                 0.0f)];
                    [UIView commitAnimations];
                }
            }
            else{
                [self setState:KIFARefreshNormal];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
                [UIView commitAnimations];
            }
        }
        [scrollView setContentOffset:CGPointMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height)) animated:YES];
    }
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KIFARefreshState)aState{
	switch (aState) {
		case KIFARefreshNormal:
			_statusLabel.text = NSLocalizedString(@"加载更多...", @"Pull down to loding more");
			[_activityView stopAnimating];
			break;
		case KIFARefreshLoading:
			_statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
			[_activityView startAnimating];
			break;
		default:
			break;
	}
	_state = aState;
}

#pragma mark ==================================================
#pragma mark == 滚动
#pragma mark ==================================================
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<0) {
        return;
    }
    
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, 416);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
    
    if (_state == KIFARefreshLoading) {
        return;
    }
    
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height) {
            
            if ([_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                [self setState:KIFARefreshLoading];
                [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,50.0f, 0.0f)];
                [UIView commitAnimations];
            }
        }
        else{
            [self setState:KIFARefreshNormal];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
            [UIView commitAnimations];
        }
    }
    else{
        if (scrollView.contentOffset.y>0) {
            if ([_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                [self setState:KIFARefreshLoading];
                [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             scrollView.frame.size.height-scrollView.contentSize.height+50,
                                                             0.0f)];
                [UIView commitAnimations];
            }
        }
        else{
            [self setState:KIFARefreshNormal];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
            [UIView commitAnimations];
        }
    }

}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView lastUpdatedDate:(NSDate *)aDate{
    
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, 416);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
    
	[self setState:KIFARefreshNormal];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = scrollView.contentInset;
	[scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
	[UIView commitAnimations];
}

@end

#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KIUIScrollViewFooterAExtension)
@dynamic refreshFooterAuto;

- (void)setHaveFooterAuto:(NSNumber *)haveFooterAuto{
    objc_setAssociatedObject(self, @"haveFooterAuto", haveFooterAuto, OBJC_ASSOCIATION_ASSIGN);
}

-(NSNumber *)haveFooterAuto{
    return objc_getAssociatedObject(self, @"haveFooterAuto");
}

- (void)setRefreshFooterAuto:(KIRefreshFooterAutoView *)refreshFooterAuto{
    objc_setAssociatedObject(self, @"refreshFooterAuto", refreshFooterAuto, OBJC_ASSOCIATION_ASSIGN);
}

-(KIRefreshFooterAutoView *)refreshFooterAuto{
    if ([objc_getAssociatedObject(self, @"haveFooterAuto") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshFooterAuto");
    }
    else{
        return nil;
    }
}

- (void)showRefreshFooterAutoWithDelegate:(id<KIRefreshFooterAutoViewDelegate>)aDelegate{
    if (!self.refreshFooterAuto) {
//        KIRefreshFooterAutoView  *footerView = [[KIRefreshFooterAutoView alloc] initWithScrollView:self delegate:aDelegate];
        self.haveFooterAuto = [NSNumber numberWithBool:YES];
    }
}

- (void)hideRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        KIRefreshFooterAutoView *footer = self.refreshFooterAuto;
        objc_removeAssociatedObjects(self.refreshFooterAuto);
        [footer removeFromSuperview];
        self.haveFooterAuto = [NSNumber numberWithBool:NO];
    }
}


@end




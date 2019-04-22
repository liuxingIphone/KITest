//
//  KIRefreshFooterDraggingView.m
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KIRefreshFooterDraggingView.h"

@implementation KIRefreshFooterDraggingView
@synthesize delegate=_delegate;

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KIRefreshFooterDraggingViewDelegate>)aDelegate{
    
    CGRect rect = CGRectMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height), scrollView.frame.size.width, scrollView.frame.size.height);
    if(self = [super initWithFrame:rect]) {
        //NSLog(@"%@",NSStringFromCGRect(self.frame));
        
		self.delegate = aDelegate;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:10.0f];
		label.textColor = [UIColor whiteColor];
        //		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
        
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后加载: %@", [dateFormatter stringFromDate:[NSDate date]]];
        
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 12.5f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:14.0f];
		label.textColor = [UIColor whiteColor];
        //		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(65.0f, 5, 15.0f, 40.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"whiteArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:KIFDRefreshNormal];
        
        [scrollView addSubview:self];
        [scrollView setValue:self forKey:@"refreshFooterDragging"];
        
        //不需要时间
        _lastUpdatedLabel.hidden = YES;
        _statusLabel.frame = CGRectMake(20.0f, 15.0f, self.frame.size.width, 20.0f);
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 手动刷新
#pragma mark ==================================================
- (void)startLoadingMore{
    if (_state == KIFDRefreshLoading) {
        return;
    }
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)v;
        if (!(_state == KIFDRefreshLoading)) {
            
            if (scrollView.contentSize.height>scrollView.frame.size.height) {
                if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height-50.0f) {
                    [self setState:KIFDRefreshLoading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 50.0f,
                                                                 0.0f)];
                    [UIView commitAnimations];
                    
                    if ([_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                        [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                    }
                }
            }
            else{
                if (scrollView.contentOffset.y>50.0f) {
                    
                    [self setState:KIFDRefreshLoading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 scrollView.frame.size.height-scrollView.contentSize.height+50.0f,
                                                                 0.0f)];
                    [UIView commitAnimations];
                    
                    if ([_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                        [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                    }
                }
            }
        }
        [scrollView setContentOffset:CGPointMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height)) animated:YES];
    }
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)refreshLastUpdatedDate:(NSDate*)aDate {
    if (aDate) {
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后加载: %@", [dateFormatter stringFromDate:aDate]];
    }
}

- (void)setState:(KIFDRefreshState)aState{
	switch (aState) {
		case KIFDRefreshPulling:
			_statusLabel.text = NSLocalizedString(@"松开即可加载...", @"release to loding more");
			[CATransaction begin];
			[CATransaction setAnimationDuration:0.18];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f*2, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
            //            [MediaController playMedia:@"tear" type:@"wav" loopsNum:0];
			break;
		case KIFDRefreshNormal:
			if (_state == KIFDRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:0.18];
				_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
				[CATransaction commit];
                //                [MediaController playMedia:@"refresh_pulling" type:@"wav" loopsNum:0];
			}
			_statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"Pull down to loding more");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		case KIFDRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
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
    
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (scrollView.isDragging) {
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (_state == KIFDRefreshPulling
                && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height)
                && (scrollView.contentSize.height-scrollView.contentOffset.y>scrollView.frame.size.height-50.0f)) {
                
                [self setState:KIFDRefreshNormal];
            }
            else if (_state == KIFDRefreshNormal
                     && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height)
                     && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height-50.0f)) {
                
                [self setState:KIFDRefreshPulling];
            }
        }
        else{
            if (_state == KIFDRefreshPulling
                && (scrollView.contentOffset.y>0)
                && (scrollView.contentOffset.y<50.0f)) {
                
                [self setState:KIFDRefreshNormal];
            }
            else if (_state == KIFDRefreshNormal
                     && (scrollView.contentOffset.y>50.0f)) {
                
                [self setState:KIFDRefreshPulling];
            }
        }
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (_state != KIFDRefreshLoading) {
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height-50.0f) {
                [self setState:KIFDRefreshLoading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             50.0f,
                                                             0.0f)];
                [UIView commitAnimations];
                
                if ([_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                    [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                }
            }
        }
        else{
            if (scrollView.contentOffset.y>50.0f) {
                
                [self setState:KIFDRefreshLoading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             scrollView.frame.size.height-scrollView.contentSize.height+50.0f,
                                                             0.0f)];
                [UIView commitAnimations];
                
                if ([_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                    [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                }
            }
        }
        
    }
    
    //    [MediaController playMedia:@"playend" type:@"wav" loopsNum:0];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView lastUpdatedDate:(NSDate *)aDate{
    
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, 416);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
    
    [self refreshLastUpdatedDate:aDate];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = scrollView.contentInset;
	[scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:KIFDRefreshNormal];
    
}

@end


#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KIUIScrollViewFooterDExtension)
@dynamic refreshFooterDragging;

- (void)setHaveFooter:(NSNumber *)haveFooterDragging{
    objc_setAssociatedObject(self, @"haveFooterDragging", haveFooterDragging, OBJC_ASSOCIATION_ASSIGN);
}

-(NSNumber *)haveFooterDragging{
    return objc_getAssociatedObject(self, @"haveFooterDragging");
}

- (void)setRefreshFooterDragging:(KIRefreshFooterDraggingView *)refreshFooterDragging{
    objc_setAssociatedObject(self, @"refreshFooterDragging", refreshFooterDragging, OBJC_ASSOCIATION_ASSIGN);
}

-(KIRefreshFooterDraggingView *)refreshFooterDragging{
    if ([objc_getAssociatedObject(self, @"haveFooterDragging") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshFooterDragging");
    }
    else{
        return nil;
    }
}

- (void)showRefreshFooterDraggingWithDelegate:(id<KIRefreshFooterDraggingViewDelegate>)aDelegate{
    if (!self.refreshFooterDragging) {
        KIRefreshFooterDraggingView *footerView = [[KIRefreshFooterDraggingView alloc] initWithScrollView:self delegate:aDelegate];
        //NSLog(@"footerView:%@", [footerView description]);
        self.haveFooter = [NSNumber numberWithBool:YES];
    }
}

- (void)hideRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        KIRefreshFooterDraggingView *footer = self.refreshFooterDragging;
        objc_removeAssociatedObjects(self.refreshFooterDragging);
        [footer removeFromSuperview];
        self.haveFooter = [NSNumber numberWithBool:NO];
    }
}

@end



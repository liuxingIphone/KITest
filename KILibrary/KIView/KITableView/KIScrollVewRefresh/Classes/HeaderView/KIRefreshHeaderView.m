//
//  KIRefreshHeaderView.m
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KIRefreshHeaderView.h"
#define TEXT_COLOR   [UIColor whiteColor]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation KIRefreshHeaderView
@synthesize delegate=_delegate;


#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KIRefreshHeaderViewDelegate>)aDelegate{
    CGRect frame = scrollView.bounds;
    if(self = [super initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height)]) {
		self.delegate = aDelegate;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:1.0];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:10.0f];
		label.textColor = TEXT_COLOR;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
        
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [dateFormatter stringFromDate:[NSDate date]]];
        
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:14.0f];
		label.textColor = TEXT_COLOR;
        //		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        //		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(65.0f, frame.size.height - 50.0f, 15.0f, 40.0f);
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
		view.frame = CGRectMake(65.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:KIHPullRefreshNormal];
        
        [scrollView addSubview:self];
        [scrollView setValue:self forKey:@"refreshHeader"];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 手动刷新
#pragma mark ==================================================
- (void)startRefresh{
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scr = (UIScrollView*)v;
        if (!(_state == KIHPullRefreshLoading)) {
            
            if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate refreshTableHeaderDidTriggerRefresh:self];
            }
            [self setState:KIHPullRefreshLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scr.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];
        }
        [scr setContentOffset:CGPointMake(0, -65.0f) animated:YES];
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
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [dateFormatter stringFromDate:aDate]];
    }
}

- (void)setState:(KIHPullRefreshState)aState{
	switch (aState) {
		case KIHPullRefreshPulling:
			_statusLabel.text = NSLocalizedString(@"松开即可刷新...", @"release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
            //            [MediaController playMedia:@"tear" type:@"wav" loopsNum:0];
			break;
		case KIHPullRefreshNormal:
			if (_state == KIHPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
                //                [MediaController playMedia:@"refresh_pulling" type:@"wav" loopsNum:0];
			}
			_statusLabel.text = NSLocalizedString(@"下拉可以刷新...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
		case KIHPullRefreshLoading:
			_statusLabel.text = NSLocalizedString(@"更新中...", @"Loading Status");
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
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    
	if (_state == KIHPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(offset, 0.0f, edgeInsets.bottom, 0.0f)];
	}
    else if (scrollView.isDragging) {
		if (_state == KIHPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
			[self setState:KIHPullRefreshNormal];
		} else if (_state == KIHPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
			[self setState:KIHPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    
    if (_state == KIHPullRefreshLoading) {
        [self setState:KIHPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, edgeInsets.bottom, 0.0f)];
		[UIView commitAnimations];
    }
    else{
        if (scrollView.contentOffset.y <= - 65.0f && !(_state == KIHPullRefreshLoading)) {
            if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate refreshTableHeaderDidTriggerRefresh:self];
            }
            [self setState:KIHPullRefreshLoading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, edgeInsets.bottom, 0.0f)];
            [UIView commitAnimations];
        }
    }
    //    [MediaController playMedia:@"playend" type:@"wav" loopsNum:0];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView lastUpdatedDate:(NSDate *)aDate{
    
    [self refreshLastUpdatedDate:aDate];
    
    [self performSelector:@selector(finished:) withObject:scrollView afterDelay:0.5];
}

- (void)finished:(UIScrollView*)scrollView{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = scrollView.contentInset;
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, edgeInsets.bottom, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:KIHPullRefreshNormal];
}

@end




#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KIUIScrollViewHeaderExtension)
@dynamic refreshHeader;

- (void)setHaveHeader:(NSNumber *)haveHeader{
    objc_setAssociatedObject(self, @"haveHeader", haveHeader, OBJC_ASSOCIATION_ASSIGN);
}

-(NSNumber *)haveHeader{
    return objc_getAssociatedObject(self, @"haveHeader");
}

- (void)setRefreshHeader:(KIRefreshHeaderView *)refreshHeader{
    objc_setAssociatedObject(self, @"refreshHeader", refreshHeader, OBJC_ASSOCIATION_ASSIGN);
}

-(KIRefreshHeaderView *)refreshHeader{
    if ([objc_getAssociatedObject(self, @"haveHeader") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshHeader");
    }
    else{
        return nil;
    }
}

- (void)showRefreshHeaderWithDelegate:(id<KIRefreshHeaderViewDelegate>)aDelegate{
    if (!self.refreshHeader) {
        KIRefreshHeaderView *headView = [[KIRefreshHeaderView alloc] initWithScrollView:self delegate:aDelegate];
        //NSLog(@"headView:%@", [headView description]);
        self.haveHeader = [NSNumber numberWithBool:YES];
    }
}

- (void)hideRefreshHeader{
    if (self.refreshHeader) {
        KIRefreshHeaderView *header = self.refreshHeader;
        objc_removeAssociatedObjects(self.refreshHeader);
        [header removeFromSuperview];
        self.haveHeader = [NSNumber numberWithBool:NO];
    }
}

@end

























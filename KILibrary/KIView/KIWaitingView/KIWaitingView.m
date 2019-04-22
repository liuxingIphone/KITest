//
//  KIWaitingView.m
//  TEST
//
//  Created by 刘 波 on 13-4-4.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KIWaitingView.h"
#import <QuartzCore/QuartzCore.h>

@interface KIWaitingView ()

@end

@implementation KIWaitingView
@synthesize blackView,textLabel;


#pragma mark ==================================================
#pragma mark == 创建
#pragma mark ==================================================
- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.3;
        self.tag = KIWaitingViewTag;
        
        blackView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 80, 80)];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.layer.cornerRadius = 5;
        blackView.layer.masksToBounds = YES;
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView startAnimating];
        activityIndicatorView.center = CGPointMake(blackView.frame.size.width/2.0, blackView.frame.size.height/2.0);
        [blackView addSubview:activityIndicatorView];
        [self addSubview:blackView];
        
        
        textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(blackView.frame), self.bounds.size.width-20, 15)];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 单例
#pragma mark ==================================================
+ (KIWaitingView*)sharedInstance{
    static KIWaitingView *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)defaultShowWithMessage:(NSString*)message{
    KIWaitingView *wait = [KIWaitingView sharedInstance];
    if (wait.superview) {
        wait.textLabel.text = message;
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    wait.frame = window.bounds;
    CGFloat space = (wait.bounds.size.width-80)/4.0;
    
    wait.blackView.center = CGPointMake(wait.bounds.size.width/2.0, wait.bounds.size.height/2.0);
    CGSize textSize = [message sizeWithFont:wait.textLabel.font constrainedToSize:CGSizeMake(wait.bounds.size.width-space*2, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    wait.textLabel.frame = CGRectMake(space, CGRectGetMaxY(wait.blackView.frame)+5, wait.bounds.size.width-space*2, textSize.height);
    wait.textLabel.text = message;
    [window addSubview:wait];
    [window bringSubviewToFront:wait];
    
    [UIView animateWithDuration:0.5 animations:^{
        [KIWaitingView sharedInstance].alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)defaultShowWithMessage:(NSString*)message inView:(UIView*)view{
    KIWaitingView *wait = [KIWaitingView sharedInstance];
    
    if (wait.superview) {
        return;
    }
    
    [KIWaitingView sharedInstance].alpha = 0.3;
    wait.frame = view.bounds;
    CGFloat space = (wait.bounds.size.width-80)/4.0;
    
    wait.blackView.center = CGPointMake(wait.bounds.size.width/2.0, wait.bounds.size.height/2.0);
    CGSize textSize = [message sizeWithFont:wait.textLabel.font constrainedToSize:CGSizeMake(wait.bounds.size.width-space*2, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    wait.textLabel.frame = CGRectMake(space, CGRectGetMaxY(wait.blackView.frame)+5, wait.bounds.size.width-space*2, textSize.height);
    wait.textLabel.text = message;
    [view addSubview:wait];
    [view bringSubviewToFront:wait];
    
    [UIView animateWithDuration:0.5 animations:^{
        [KIWaitingView sharedInstance].alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)defaultDismiss{
    
    [[KIWaitingView sharedInstance] defaultDismiss];
}

- (void)defaultDismiss{
    [UIView animateWithDuration:0.5 animations:^{
        [KIWaitingView sharedInstance].alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark ==================================================
#pragma mark == 自动释放
#pragma mark ==================================================
+ (void)showWithMessage:(NSString*)message inView:(UIView*)view{
    BOOL have = NO;
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:[KIWaitingView class]]) {
            have = YES;
            break;
        }
    }
    
    if (have) {
        return;
    }
    
    KIWaitingView *wait = [[KIWaitingView alloc]init];
    
    wait.frame = view.bounds;
    CGFloat space = (wait.bounds.size.width-80)/4.0;
    
    wait.blackView.center = CGPointMake(wait.bounds.size.width/2.0, wait.bounds.size.height/2.0);
    CGSize textSize = [message sizeWithFont:wait.textLabel.font constrainedToSize:CGSizeMake(wait.bounds.size.width-space*2, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    wait.textLabel.frame = CGRectMake(space, CGRectGetMaxY(wait.blackView.frame)+5, wait.bounds.size.width-space*2, textSize.height);
    wait.textLabel.text = message;
    [view addSubview:wait];
}

+ (void)showWithMessage:(NSString*)message inView:(UIView*)view withFrame:(CGRect)frame{
    BOOL have = NO;
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:[KIWaitingView class]]) {
            have = YES;
            break;
        }
    }
    
    if (have) {
        return;
    }
    
    KIWaitingView *wait = [[KIWaitingView alloc]init];
    
    wait.frame = frame;
    CGFloat space = (wait.bounds.size.width-80)/4.0;
    
    wait.blackView.center = CGPointMake(wait.bounds.size.width/2.0, wait.bounds.size.height/2.0);
    CGSize textSize = [message sizeWithFont:wait.textLabel.font constrainedToSize:CGSizeMake(wait.bounds.size.width-space*2, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    wait.textLabel.frame = CGRectMake(space, CGRectGetMaxY(wait.blackView.frame)+5, wait.bounds.size.width-space*2, textSize.height);
    wait.textLabel.text = message;
    [view addSubview:wait];
}


+ (void)dismissForView:(UIView*)view{
    for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[KIWaitingView class]]) {
            [UIView animateWithDuration:0.5 animations:^{
                v.alpha = 0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
		}
	}
}


@end

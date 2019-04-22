//
//  KIWaitingView.h
//  TEST
//
//  Created by 刘 波 on 13-4-4.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KIWaitingViewTag 2006021272

@interface KIWaitingView : UIView

@property(nonatomic,retain)UILabel *textLabel;
@property(nonatomic,retain)UIView *blackView;

#pragma mark ==================================================
#pragma mark == 单例
#pragma mark ==================================================
+ (KIWaitingView*)sharedInstance;

+ (void)defaultShowWithMessage:(NSString*)message;

//+ (void)defaultShowWithMessage:(NSString*)message inView:(UIView*)view;

+ (void)defaultDismiss;


#pragma mark ==================================================
#pragma mark == 自动释放
#pragma mark ==================================================
+ (void)showWithMessage:(NSString*)message inView:(UIView*)view;
+ (void)showWithMessage:(NSString*)message inView:(UIView*)view withFrame:(CGRect)frame;

+ (void)dismissForView:(UIView*)view;

@end

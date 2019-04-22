//
//  UIViewController+KIViewController.m
//  Kitalker
//
//  Created by chen on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+KIAdditions.h"

@implementation UIViewController (KIAdditions)


#pragma mark - nav bar 设置

- (void)showCustomBackButton {
    [self showCustomBackButton:@selector(close)];
}

- (void)showCustomBackButton:(SEL)selector {
#warning --- backBtn：导航栏返回按钮图片
    [self setNavLeftItem:selector
                   image:[UIImage imageNamed:@"backBtn.png"]
                  imageH:[UIImage imageNamed:@"backBtn.png"]];
}

- (void)setNavLeftItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage:imageH forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(0, 0, 15, 19)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setNavRightItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage:imageH forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(0, 7, 30, 30)];
    [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;
}
-(void)setNavRightItem:(SEL)selector title:(NSString *)title color:(UIColor *)color
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateHighlighted];
    [backButton setTitleColor:color forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 7, 70, 30)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)setTitle:(NSString *)title {
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [self.navigationItem setTitleView:titleLabel];
    }
    [titleLabel setTextColor:[UIColor colorWithHex:@"3f3f3f"]];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
}

- (void)setTitleColor:(UIColor *)color{
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [self.navigationItem setTitleView:titleLabel];
    }
    [titleLabel setTextColor:color];
}


#pragma mark - controller 控制

- (void)pushController:(UIViewController *)viewController {
    [self pushController:viewController animated:YES];
}

- (void)pushController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self pushViewController:viewController animated:animated];
    } else if (self.navigationController != nil) {
        [self.navigationController pushViewController:viewController animated:animated];
    } else {
        if (viewController == self) {
            return ;
        }
        
        [viewController viewWillAppear:YES];
        [self.view pushView:viewController.view completion:^(BOOL finished) {
            [viewController viewDidAppear:YES];
        }];
    }
}

- (void)popController {
    if ([self isKindOfClass:[UINavigationController class]]) {
        if ([self respondsToSelector:@selector(popViewControllerAnimated:)]) {
            [(UINavigationController *)self popViewControllerAnimated:YES];
        }
    }
    if (self.navigationController != nil) {
        if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    } else {
        [self viewWillDisappear:YES];
        [self.view popCompletion:^(BOOL finished) {
            [self viewDidDisappear:YES];
        }];
    }
}


- (void)dismissModalController {
    if (self.navigationController != nil) {
        if ([self.navigationController respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } else {
        if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}


- (void)close {
    [self dismissModalController];
    [self popController];
}

@end

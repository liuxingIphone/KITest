//
//  KITabBarViewController.m
//  Kitalker
//
//  Created by chen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITabBarController.h"

@implementation KITabBarController

@synthesize tabBarItems = _tabBarItems;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setTabBarItems:(NSArray *)tabBarItems {
    if (_tabBarItems != tabBarItems) {
        _tabBarItems = tabBarItems;
        
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        
        for (KITabBarItem *item in tabBarItems) {
            [controllers addObject:item.viewController];
        }
        
        [self setViewControllers:controllers];
        
        
        for (UIView *view in self.tabBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [view setHidden:YES];
                [view setFrame:CGRectMake(0, 0, 0, 0)];
                [self.tabBar sendSubviewToBack:view];
            }
        }
        
        [[self kitabBar] setTabBarItems:_tabBarItems];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark private method

- (KITabBar *)kitabBar {
    if (_kiTabBar == nil) {
        _kiTabBar = [[KITabBar alloc] init];
        
        [_kiTabBar setTabBarDelegate:self];
        
        [_kiTabBar setFrame:CGRectMake(0,
                                       self.view.bounds.size.height-kTabBarHeight,
                                       self.view.bounds.size.width,
                                       kTabBarHeight)];
        
        [_kiTabBar setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin
                                    |UIViewAutoresizingFlexibleWidth
                                    |UIViewAutoresizingFlexibleLeftMargin
                                    |UIViewAutoresizingFlexibleRightMargin];
        [_kiTabBar setBackgroundColor:[UIColor blackColor]];
        
        [self.view addSubview:_kiTabBar];
        
    }
    return _kiTabBar;
}

- (void)didTabBarSelectedItem:(KITabBarItem *)item {
    [self setSelectedViewController:item.viewController];
    
    if ([self respondsToSelector:@selector(tabBarController:didSelectedItem:)]) {
        [self tabBarController:self didSelectedItem:item];
    }
}

#pragma mark public method
- (void)setTabBarBackgroundColor:(UIColor *)color {
    [[self kitabBar] setBackgroundColor:color];
}

- (void)setTabBarBackgroundImage:(UIImage *)image {
    UIColor *color = [UIColor colorWithPatternImage:image];
    [[self kitabBar] setBackgroundColor:color];
}

- (void)setTabBarMaskViewColor:(UIColor *)color {
    [[self kitabBar] setBackgroundColor:color];
}

- (void)setTabBarMaskViewImage:(UIImage *)image {
    UIColor *color = [UIColor colorWithPatternImage:image];
    [[[self kitabBar] maskView] setBackgroundColor:color];
}

- (void)selectedItemWithIndex:(NSUInteger)index {
    [[self kitabBar] selectedItemWithIndex:index];
}

- (void)changeMaskViewIndex:(NSUInteger)index {
    [[self kitabBar] insertSubview:[self kitabBar].maskView atIndex:index];
}


@end

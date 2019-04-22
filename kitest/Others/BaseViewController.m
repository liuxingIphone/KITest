//
//  BaseViewController.m
//  kitest
//
//  Created by Bear on 15/2/10.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@implementation BaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    
    [self closeNavigationBarTranslucent];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self closeNavigationBarTranslucent];
}

- (void)setNavBarStyleWithIndex:(NSInteger)index{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_topbar0%ld.png", (long)index]] forBarMetrics:UIBarMetricsDefault];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}



@end

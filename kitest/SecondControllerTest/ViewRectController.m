//
//  ViewRectController.m
//  kitest
//
//  Created by HuamoMac on 15/10/30.
//  Copyright © 2015年 chen. All rights reserved.
//

#import "ViewRectController.h"

@implementation ViewRectController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    //CGRectInset
    UIView *originView = [[UIView alloc]init];
    originView.frame = CGRectMake(20, 40, 100, 100);
    originView.backgroundColor = [UIColor redColor];
    [self.view addSubview:originView];
    
    UIView *changeView = [[UIView alloc]init];
    changeView.frame = CGRectInset(CGRectMake(20, 40, 100, 100), 20, -20);
    changeView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:changeView];
    
    
    //CGRectOffset
    
}




@end

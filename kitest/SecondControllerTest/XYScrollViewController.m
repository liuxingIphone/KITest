//
//  XYScrollViewController.m
//  kitest
//
//  Created by Huamo on 2018/8/8.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "XYScrollViewController.h"

@interface XYScrollViewController () <UIScrollViewDelegate>{
    
}

@end



@implementation XYScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    
}


- (void)initView{
    
    NSInteger xCount = 10;
    NSInteger yCount = 8;
    NSInteger itemWidth = 60;
    NSInteger itemHeight = 30;
    
    UIScrollView *xScrollView = [[UIScrollView alloc]init];
    xScrollView.frame = CGRectMake(20, 100, SCREEN_WIDTH-40, 100);
    xScrollView.contentSize = CGSizeMake(xCount*itemWidth, 100);
    xScrollView.showsHorizontalScrollIndicator = YES;
    xScrollView.showsVerticalScrollIndicator = NO;
    xScrollView.bounces = YES;
    xScrollView.delegate = self;
    xScrollView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
    //设置边框，形成表格
    xScrollView.layer.borderWidth = .5f;
    xScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:xScrollView];
    
    
    UIScrollView *yScrollView = [[UIScrollView alloc]init];
    yScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH-40, 100);
    yScrollView.contentSize = CGSizeMake(SCREEN_WIDTH-40, yCount*itemHeight);
    yScrollView.showsHorizontalScrollIndicator = NO;
    yScrollView.showsVerticalScrollIndicator = YES;
    yScrollView.bounces = YES;
    yScrollView.delegate = self;
    yScrollView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
    //设置边框，形成表格
    yScrollView.layer.borderWidth = .5f;
    yScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    [xScrollView addSubview:yScrollView];
    
    
    UIView *upView = [UIView new];
    upView.frame = CGRectMake(0, 0, xCount*itemWidth, yCount*itemHeight);
    upView.backgroundColor = [UIColor clearColor];
    [yScrollView addSubview:upView];
    
    for (NSInteger i=0; i<xCount; i++) {
        for (NSInteger j=0; j<yCount; j++) {
            
            UILabel *label = UILabel.new;
            label.frame = CGRectMake(itemWidth*i, itemHeight*j, itemWidth, itemHeight);
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentCenter;
            [upView addSubview:label];
            
            label.text = [NSString stringWithFormat:@"%ld-%ld", i, j];
            
        }
    }
    
    
}




@end

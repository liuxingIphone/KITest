//
//  VideoController.m
//  kitest
//
//  Created by Huamo on 2017/12/18.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "VideoController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface VideoController ()

@end

@implementation VideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 180, 100, 50);
    [button setBackgroundColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button setTitle:@"play" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)playVideo{
    
    NSURL *videoUrl = [NSURL URLWithString:@"https://img.hxjbcdn.com/mp4/reveljichu.mp4"];
    
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:videoUrl];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
    
}




@end

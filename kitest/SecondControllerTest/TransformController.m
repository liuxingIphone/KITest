//
//  TransformController.m
//  kitest
//
//  Created by Huamo on 2017/6/6.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "TransformController.h"

@interface TransformController ()

@property (nonatomic,strong) UIImageView *imageV;

@end

@implementation TransformController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(50, 60, 80, 40);
//    button.backgroundColor = [UIColor greenColor];
//    [button addTarget:self action:@selector(big:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    NSLog(@"button:%f", button.transform.a);
//}
//
//- (void)big:(UIButton *)button{
//    if (button.transform.a == 1.5) {
//        button.transform = CGAffineTransformIdentity;
//        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
//            
//            [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
//                
//                button.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            }];
//        } completion:^(BOOL finished) {
//            NSLog(@"button:%f", button.transform.a);
//        }];
//    }else{
//        button.transform = CGAffineTransformIdentity;
//        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
//            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
//                
//                button.transform = CGAffineTransformMakeScale(1.5, 1.5);
//            }];
//            
//            
//        } completion:^(BOOL finished) {
//            NSLog(@"button:%f", button.transform.a);
//        }];
//    }
//    
//    
//    
//    
////    button.transform = CGAffineTransformIdentity;
////    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
////        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
////            
////            button.transform = CGAffineTransformMakeScale(1.5, 1.5);
////        }];
////        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
////            
////            button.transform = CGAffineTransformMakeScale(0.8, 0.8);
////        }];
////        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
////            
////            button.transform = CGAffineTransformMakeScale(1.0, 1.0);
////        }];
////    } completion:nil];
//}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    self.imageV.image = [UIImage imageNamed:@"gay.jpg"];
    
    [self.view addSubview:self.imageV];
    
    //设置高亮
    
    //创建向上按钮
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    topBtn.frame= CGRectMake(100, 250, 40, 40);
    
    [topBtn setBackgroundImage:[UIImage imageNamed:@"shang.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:topBtn];
    
    [topBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    topBtn.tag = 1;
    
    //创建向下按钮
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    downBtn.frame = CGRectMake(100, 350, 40, 40);
    
    [downBtn setBackgroundImage:[UIImage imageNamed:@"xia.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:downBtn];
    
    [downBtn setTag:2];
    
    [downBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    //zuo
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(50  , 300, 40, 40);
    
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"zuo.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:leftBtn];
    
    [leftBtn setTag:4];
    
    [leftBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    //you
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(150, 300, 40, 40);
    
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"you.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:rightBtn];
    
    [rightBtn setTag:3];
    
    [rightBtn addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    
    //放大按钮
    
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    plusBtn.frame = CGRectMake(75, 400, 40, 40);
    
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    
    [plusBtn setTag:1];///???????
    
    [self.view addSubview:plusBtn];
    
    [plusBtn addTarget:self action:@selector(Zoom:) forControlEvents:UIControlEventTouchUpInside];
    
    //缩小按钮
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    minusBtn.frame = CGRectMake(120, 400, 40, 40);
    
    [minusBtn setBackgroundImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    
    [self.view addSubview:minusBtn];
    
    [minusBtn setTag:0];
    
    [minusBtn addTarget:self action:@selector(Zoom:) forControlEvents:UIControlEventTouchUpInside];
    
    //左旋转
    
    UIButton *leferRotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leferRotateBtn.frame = CGRectMake(175, 400, 40, 40);
    
    [leferRotateBtn setBackgroundImage:[UIImage imageNamed:@"zuozhuan"] forState:UIControlStateNormal];
    
    [self.view addSubview:leferRotateBtn];
    
    [leferRotateBtn addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
    
    leferRotateBtn.tag = 100;
    
    //右旋转
    
    UIButton *rightRotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightRotateBtn.frame = CGRectMake(225, 400, 40, 40);
    
    [rightRotateBtn setBackgroundImage:[UIImage imageNamed:@"youzhuan"] forState:UIControlStateNormal];
    
    [self.view addSubview:rightRotateBtn];
    
    rightRotateBtn.tag = 101;
    
    [rightRotateBtn addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)rotate:(UIButton *)sender

{
    
    if (sender.tag == 100) {
        
        //逆时针
        
        self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, -M_1_PI);
        
    }
    
    else
        
    {
        
        self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, M_1_PI);
        
    }
    
}

- (void)Zoom:(UIButton *)sender

{
    
    //使用bounds，以中心点为原点进行缩放
    
    CGRect bounds = self.imageV.bounds;
    
    if (sender.tag) {
        
        bounds.size.height += 30;
        
        bounds.size.width  += 30;
        
    }else
        
    {
        
        bounds.size.height  -= 50;
        
        bounds.size.width  -= 50;
        
    }
    
    //设置首尾动画
    
    [UIView beginAnimations:nil context:nil];
    
    self.imageV.bounds = bounds;
    
    [UIView setAnimationDuration:2.0];
    
    [UIView commitAnimations];
    
}

-(void)Click:(UIButton *)sender

{
    
    NSLog(@"CLICK a");
    
    CGPoint center = self.imageV.center;
    
    switch (sender.tag) {
            
        case 1:
            
            center.y -= 30;
            
            NSLog(@"%ld",(long)sender.tag);
            
            break;
            
        case 2:
            
            center.y += 30;
            
            break;
            
        case 3:
            
            center.x += 50;
            
            break;
            
        case 4:
            
            center.x -= 50;
            
            break;
            
        default:
            
            break;
            
    }
    
    [UIView beginAnimations:nil context:nil];
    
    self.imageV.center = center;
    
    [UIView setAnimationDuration:2.0];
    
    [UIView commitAnimations];
    
}





@end

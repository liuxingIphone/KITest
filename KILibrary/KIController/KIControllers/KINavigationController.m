//
//  KINavigationController.m
//  Kitalker
//
//  Created by chen on 13-5-16.
//  
//

#import "KINavigationController.h"


#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

@interface KINavigationController () {
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,retain) UIImageView *shadowImageView;
@property (nonatomic,retain) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic,assign) BOOL isMoving;
@property (nonatomic,assign) BOOL canDragBack;

@end



@implementation KINavigationController
@synthesize gestureRecognizer,shadowImageView;
@synthesize dragBackEnable;


#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = NO;
        self.dragBackEnable = NO;
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = NO;
        self.dragBackEnable = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}


- (void)setCanDragBack:(BOOL)canDragBack{
    
    _canDragBack = canDragBack;
    
    if (canDragBack) {
        //阴影
        shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"KKNavLeftDragShadow_bg.png"]];
        shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
        [self.view addSubview:shadowImageView];
        
        //初始化滑动出栈手势不可用
        gestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
        [gestureRecognizer delaysTouchesBegan];
        [self.view addGestureRecognizer:gestureRecognizer];
    }
    else{
        shadowImageView = nil;
        
        //移除手势
        if (gestureRecognizer) {
            [self.view removeGestureRecognizer:gestureRecognizer];
            gestureRecognizer = nil;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.dragBackEnable) {
        if ([self.viewControllers count]>2) {
            self.canDragBack = YES;
        }
        else{
            self.canDragBack = NO;
        }
    }
}




// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.screenShotsList addObject:[self capture]];
    if (self.dragBackEnable) {
        if ([self.viewControllers count]>1) {
            self.canDragBack = YES;
        }
        else{
            self.canDragBack = NO;
        }
    }
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self.screenShotsList removeLastObject];
    
    
    if (self.dragBackEnable) {
        if ([self.viewControllers count]>2) {
            self.canDragBack = YES;
        }
        else{
            self.canDragBack = NO;
        }
    }
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x{
    
    //    NSLog(@"Move to:%f",x);
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    
    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
}

#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

@end

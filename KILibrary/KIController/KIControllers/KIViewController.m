//
//  KIViewController.h
//  Kitalker
//
//  Created by chen on 13-4-16.
//
//

#import "KIViewController.h"


@implementation  KIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    
    [self closeNavigationBarTranslucent];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self closeNavigationBarTranslucent];
}

- (void)closeNavigationBarTranslucent{
    //#if defined(__IPHONE_7_0)
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        self.navigationController.navigationBar.translucent = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    //#endif
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSString *navImageName = nil;
//        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//            navImageName = @"navBarBackgroud7"; // 高度64px, 44+20
//        }else {
//            navImageName = @"navBarBackgroud"; //高度44px
//        }
        [self.navigationController.navigationBar setBackgroundImage:KIThemeImage(navImageName) forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)openNavigationBarTranslucent{
    //#if defined(__IPHONE_7_0)
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.translucent = YES;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        self.navigationController.navigationBar.translucent = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    //#endif
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSString *navImageName = nil;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            navImageName = @"navBarBackgroud7Alpha"; // 高度64px, 44+20
        }else {
            navImageName = @"navBarBackgroudAlpha"; //高度44px
        }
        [self.navigationController.navigationBar setBackgroundImage:KIThemeImage(navImageName) forBarMetrics:UIBarMetricsDefault];
    }
}


@end





@implementation UIViewController (ProjectK)

- (void)showCustomBackButton {
    [self showCustomBackButton:@selector(close)];
}

- (void)showCustomBackButton:(SEL)selector {
    [self setNavLeftItem:selector
                   image:KIThemeImage(@"navBarBackButton")
                  imageH:KIThemeImage(@"navBarBackButtonH")];
}

- (void)showHomeButton {
    [self setNavLeftItem:@selector(close)
                   image:KIThemeImage(@"iconHome2")
                  imageH:KIThemeImage(@"iconHomeH2")];
}

- (void)setNavLeftItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage:imageH forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(0, 7, 30, 30)];
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
    [titleLabel setTextColor:KIThemeColor(@"navTitleColor")];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
}

//- (void)setTitle:(NSString *)title isButtonModal:(BOOL)isButtonModal{
//    if (isButtonModal) {
//        NavTitleButton *titleButton = (NavTitleButton *)self.navigationItem.titleView;
//        if (!titleButton) {
//            titleButton = [[NavTitleButton alloc]initWithFrame:CGRectMake(80, 0, 160, 44)];
//            [titleButton setBackgroundColor:[UIColor clearColor]];
//            titleButton.navButtonDelegate = self;
//            [self.navigationItem setTitleView:titleButton];
//            [titleButton release];
//        }
//        titleButton.titleLabel.text = title;
//        
//        CGSize size = [title sizeWithFont:titleButton.titleLabel.font constrainedToSize:CGSizeMake(1000, 44)];
//        CGRect arrowFrame = titleButton.arrowImageView.frame;
//        
//        titleButton.arrowImageView.frame = CGRectMake(titleButton.titleLabel.frame.size.width/2.0+size.width/2.0+5, arrowFrame.origin.y, arrowFrame.size.width, arrowFrame.size.height);
//    }
//    else{
//        [self setTitle:title];
//    }
//}
//
//- (void)navTitleButtonDidClose{
//    
//}
//
//- (void)navTitleButtonDidOpen{
//    
//}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end

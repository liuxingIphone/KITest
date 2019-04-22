//
//  RootTabController.m
//  kitest
//
//  Created by Bear on 15/2/10.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "RootTabController.h"
#import "ViewController.h"
#import "KITabBarItem.h"
#import "SecondViewController.h"


@interface RootTabController () <KITabViewControllerDelegate>{
    UIViewController    *_currentDisplayViewController;
}
@property (nonatomic, retain) UIViewController  *currentDisplayViewController;


@end


@implementation RootTabController
@synthesize currentDisplayViewController = _currentDisplayViewController;

- (id)initWithPosition:(KITabViewPosition)position autoLayout:(BOOL)autoLayout {
    if (self = [super initWithPosition:position autoLayout:autoLayout]) {
        [self setDelegate:self];
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideTabbarView) name:kHideTabBarViewNoti object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTabbarView) name:kShowTabBarViewNoti object:nil];
        
    }
    return self;
}


#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tabViewItems = [[NSMutableArray alloc] init];
    //[self setTabViewBackgroundImage:KIImageWithPath(@"HomeToolBar")];
    
    
    SecondViewController *family = [[SecondViewController alloc] init];
    UINavigationController *famNav = [[UINavigationController alloc]initWithRootViewController:family];
    //famNav.navigationBarHidden = YES;
    KITabViewItem *itemFam = [[KITabViewItem alloc]initWithViewController:famNav];
    [itemFam setBackgroundImage:[UIImage imageNamed:@"ico_notice.png"]];
    [itemFam setSelectedBackgroundImage:[UIImage imageNamed:@"ico_notice.png"]];
    [tabViewItems addObject:itemFam];
    
    ViewController *ar = [[ViewController alloc] init];
    UINavigationController *arNav = [[UINavigationController alloc]initWithRootViewController:ar];
    KITabViewItem *itemAr = [[KITabViewItem alloc]initWithViewController:arNav];
    [itemAr setBackgroundImage:[UIImage imageNamed:@"ico_notice.png"]];
    [itemAr setSelectedBackgroundImage:[UIImage imageNamed:@"ico_notice.png"]];
    [tabViewItems addObject:itemAr];
    
    
    [self setTabViewItems:tabViewItems];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg_topbar01.png"]] forBarMetrics:UIBarMetricsDefault];
    }
}


#pragma mark ==================================================
#pragma mark == KITabViewControllerDelegate
#pragma mark ==================================================
- (CGFloat)tabViewHeightForTabViewController:(KITabViewController *)tabViewController{
    return kTabViewDefaultHeight;
}

- (void)tabViewController:(KITabViewController *)tabViewController didSelectedIndex:(NSUInteger)index{
    
    
}

- (void)tabViewController:(KITabViewController *)tabViewController didSelectedItem:(KITabViewItem *)item{
    
    _currentDisplayViewController = item.viewController;
}

- (void)hideTabbarView{
    [self setTabViewHidden:YES];
}

- (void)showTabbarView{
    [self setTabViewHidden:NO];
}


- (void)showViewController:(UIViewController *)viewController push:(BOOL)push {
    if (push) {
        [self setCurrentDisplayViewController:nil];
        //[self pushController:viewController];
    } else {
        [self setCurrentDisplayViewController:viewController];
        //[self presentWithNavigationController:viewController];
    }
}

@end

//
//  KITabViewController.m
//  HA
//
//  Created by chen on 13-3-7.
//  
//

#import "KITabViewController.h"
#import <objc/runtime.h>

@interface KITabViewController () {
    BOOL            _isFirstAppear;
    CGFloat         _containerViewHeight;
    NSMutableArray  *_selectedIndexStack;
}
@property (nonatomic, retain) UIView            *containerView;

@end

@implementation KITabViewController
@synthesize autoLayout          = _autoLayout;
@synthesize delegate            = _delegate;
@synthesize position            = _position;
@synthesize tabView             = _tabView;
@synthesize containerView       = _containerView;
@synthesize selectedIndex       = _selectedIndex;
@synthesize selectedItem        = _selectedItem;
@synthesize headerView          = _headerView;
@synthesize headerViewHidden    = _headerViewHidden;

- (id)init {
    return [self initWithPosition:KITabViewPositionOfBottom autoLayout:YES];
}

- (id)initWithPosition:(KITabViewPosition)position autoLayout:(BOOL)autoLayout {
    if (self = [super init]) {
        _position = position;
        _autoLayout = autoLayout;
        [self tabViewInitFinished];
    }
    return self;
}

- (void)tabViewInitFinished {
    _selectedIndex = 0;
    _isFirstAppear = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self tabViewInitFinished];
}

- (void)loadView {
    [super loadView];
    [self updateView:NO];
    [self.view setClipsToBounds:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isFirstAppear) {
        [self setSelectedIndex:_selectedIndex];
        _isFirstAppear = NO;
    }
    [_selectedViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_selectedViewController viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (KITabViewItem *item in self.tabViewItems) {
        if (item.viewController) {
            [item.viewController didReceiveMemoryWarning];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.view && [keyPath isEqualToString:@"frame"]) {
//        [self updateView];
    } else if (object == _selectedViewController.view && [keyPath isEqualToString:@"frame"]) {
        /*UITableView *tableView = (UITableView *)_selectedViewController.view;
        CGPoint offset = CGPointZero;
        BOOL isTableView = [tableView isMemberOfClass:[UITableView class]];
        if (isTableView) {
            offset = [tableView contentOffset];
        }
        [_selectedViewController.view setBounds:[self containerView].bounds];
        if (isTableView) {
            [tableView setContentOffset:offset];
        }*/
    }
}

- (void)setHeaderView:(UIView *)headerView {
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        
        _headerView = headerView;
        if (_headerView != nil) {
            [_headerView setFrame:CGRectMake(0,
                                             0,
                                             CGRectGetWidth(self.view.bounds),
                                             CGRectGetHeight(_headerView.bounds))];
            [self.view addSubview:_headerView];
            _headerViewHidden = NO;
        } else {
            _headerViewHidden = YES;
        }
        [self updateView:NO];
    }
}

- (void)setHeaderViewHidden:(BOOL)hidden animated:(BOOL)animated {
    if (self.headerView != nil) {
        _headerViewHidden = hidden;
        [self updateView:animated];
    }
}

- (void)updateView:(BOOL)animated {
    
    //处理headerView相关的
    CGFloat headerViewHeight = CGRectGetHeight(self.headerView.bounds);
    if (self.headerViewHidden) {
        headerViewHeight = 0;
    }
    
    CGFloat tabViewX = 0;
    CGFloat tabViewY = 0;
    CGFloat tabViewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat tabViewHeight = [self tabViewHeight];
    
    UIEdgeInsets edgeInsets = [self containerViewEdgeInsets];
    
    CGFloat containerViewX = 0;
    CGFloat containerViewY = 0;
    CGFloat containerViewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat containerViewHeight = CGRectGetHeight(self.view.bounds)-tabViewHeight-edgeInsets.top-edgeInsets.bottom-headerViewHeight;

    //用于记录container view的高度是否发生的变化
//    if (_containerViewHeight == containerViewHeight) {
//        return ;
//    }
//    _containerViewHeight = containerViewHeight;
    
    UIViewAutoresizing tabViewAutoresizing = UIViewAutoresizingNone;
    UIViewAutoresizing containerViewAutoresizing = UIViewAutoresizingNone;
    
    switch (self.position) {
        case KITabViewPositionOfTop: {
            //如果tabView是在上方，则containerView和tabView的y分别加上headerView的高度
            tabViewY += headerViewHeight;
            containerViewY = tabViewHeight+headerViewHeight;
            
            if (self.tabViewHidden) {
                containerViewY -= tabViewHeight;
                containerViewHeight += tabViewHeight + edgeInsets.top + edgeInsets.bottom;
                tabViewY -= tabViewHeight;
                tabViewHeight = 0;
            }
            
            tabViewAutoresizing = UIViewAutoresizingFlexibleBottomMargin;
            containerViewAutoresizing = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        }
            break;
        case KITabViewPositionOfBottom: {
            //如果tabView是在下方，containerView的y则加上headerView的高度
            tabViewY = CGRectGetHeight(self.view.bounds) - tabViewHeight;
            containerViewY += headerViewHeight;
            
            if (self.tabViewHidden) {
                containerViewHeight += tabViewHeight + edgeInsets.top + edgeInsets.bottom;
                tabViewY += tabViewHeight;
            }
            
            tabViewAutoresizing = UIViewAutoresizingFlexibleTopMargin;
            containerViewAutoresizing = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        }
            break;
        case KITabViewPositionOfLeft: {
            tabViewAutoresizing = UIViewAutoresizingFlexibleRightMargin;
            containerViewAutoresizing = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        }
            break;
        case KITabViewPositionOfRight: {
            tabViewAutoresizing = UIViewAutoresizingFlexibleLeftMargin;
            containerViewAutoresizing = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        }
            break;
        default:
            break;
    }
    
//    if (self.headerView != nil) {
//        if (self.headerViewHidden) {
//            if (self.tabViewHidden) {
//            } else {
//            }
//        } else {
//            containerViewHeight -= CGRectGetHeight(self.headerView.bounds);
//            if (self.tabViewHidden) {
//                
//                containerViewY += CGRectGetHeight(self.headerView.bounds);
//            } else {
//                tabViewY += CGRectGetHeight(self.headerView.bounds);
//                containerViewY += tabViewY;
//            }
//        }
//    }
    
    [[self tabView] setAutoresizingMask:tabViewAutoresizing];
    [[self containerView] setAutoresizingMask:containerViewAutoresizing];
    
    [UIView animateWithDuration:animated?0.2:0 animations:^{
        [[self tabView] setFrame:CGRectMake(tabViewX,
                                            tabViewY,
                                            tabViewWidth,
                                            tabViewHeight)];
        
        [[self containerView] setFrame:CGRectMake(containerViewX,
                                                  containerViewY,
                                                  containerViewWidth,
                                                  containerViewHeight)];
        if (_selectedViewController != nil) {
            [_selectedViewController.view setFrame:self.containerView.bounds];
        }
        
        [[self headerView] setHidden:self.headerViewHidden];
    } completion:^(BOOL finished) {
    }];
    
    [self.view insertSubview:[self tabView] aboveSubview:[self containerView]];
}

- (KITabView *)tabView {
    if(_tabView == nil) {
        _tabView = [[KITabView alloc] initWithDelegate:self position:self.position];
        [_tabView setAutoLayout:_autoLayout];
        [self.view addSubview:_tabView];
    }
    return _tabView;
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        [_containerView setBackgroundColor:[UIColor clearColor]];
        [_containerView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin
                                            |UIViewAutoresizingFlexibleHeight
                                            |UIViewAutoresizingFlexibleTopMargin];
        [_containerView setAutoresizesSubviews:YES];
        [_containerView setClipsToBounds:YES];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}

- (NSMutableArray *)selectedIndexStack {
    if (_selectedIndexStack == nil) {
        _selectedIndexStack = [[NSMutableArray alloc] init];
    }
    return _selectedIndexStack;
}

- (void)setTabViewItems:(NSMutableArray *)tabViewItems {
    [[self tabView] setTabViewItems:tabViewItems];
    
    for (KITabViewItem *item in tabViewItems) {
        if (item.viewController) {
            [item.viewController setValue:item forKey:@"tabViewItem"];
            [item.viewController setValue:self forKey:@"tabViewController"];
//            [item.viewController setValue:self forKey:@"parentViewController"];
        }
    }
}

- (NSMutableArray *)tabViewItems {
    return [[self tabView] tabViewItems];
}

- (void)setTabViewBackgroundColor:(UIColor *)color {
    [[self tabView] setBackgroundColor:color];
}

- (void)setTabViewBackgroundImage:(UIImage *)image {
    [[self tabView] setBackgroundImage:image];
}

- (void)setTabBarHeaderView:(UIView *)view {
    [[self tabView] setHeaderView:view];
}

- (void)setTabBarFooterView:(UIView *)view {
    [[self tabView] setFooterView:view];
}

- (void)setNumberOfItemsInPage:(NSUInteger)number {
    [[self tabView] setNumberOfItemsInPage:number];
}

- (void)setItemSelectedImage:(UIImage *)image margin:(UIEdgeInsets)margin {
    [[self tabView] setItemSelectedImage:image margin:margin];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if ([self.view superview] != nil) {
        [[self tabView] setSelectedIndex:_selectedIndex];
    }
}

- (NSUInteger)selectedIndex {
    return [[self tabView] selectedIndex];
}

- (void)setSelectedItem:(KITabViewItem *)selectedItem {
    [[self tabView] setSelectedItem:selectedItem];
}

- (KITabViewItem *)selectedItem {
    return [[self tabView] selectedItem];
}

- (CGFloat)tabViewHeight {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tabViewHeightForTabViewController:)]) {
        return [self.delegate tabViewHeightForTabViewController:self];
    }
    return kTabViewDefaultHeight;
}

- (UIEdgeInsets)containerViewEdgeInsets {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(edgeInsetsForTabViewController:)]) {
        return [self.delegate edgeInsetsForTabViewController:self];
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)heightForTabView:(KITabView *)tabView {
    return [self tabViewHeight];
}

- (BOOL)tabView:(KITabView *)tabView willDeselectIndex:(NSUInteger)index {
    return [self willDeselectedIndex:index];
}

- (BOOL)tabView:(KITabView *)tabView willSelectIndex:(NSUInteger)selectedIndex {
    return [self willSelectIndex:selectedIndex];
}

- (void)tabView:(KITabView *)tabView didSelectedIndex:(NSUInteger)selectedIndex {
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(tabViewController:didSelectedIndex:)]) {
        [self.delegate tabViewController:self didSelectedIndex:selectedIndex];
    }
}

- (void)tabView:(KITabView *)tabView didSelectedItem:(KITabViewItem *)selectedItem {
    if (selectedItem.viewController != nil) {
        [self updateViewController:selectedItem.viewController];
    }
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(tabViewController:didSelectedItem:)]) {
        [self.delegate tabViewController:self didSelectedItem:selectedItem];
    }
}

- (BOOL)willSelectIndex:(NSUInteger)index {
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(tabViewController:willSelectIndex:)]) {
        return [self.delegate tabViewController:self willSelectIndex:index];
    }
    return YES;
}

- (BOOL)willDeselectedIndex:(NSInteger)index {
    if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(tabViewController:willDeselectedIndex:)]) {
        return [self.delegate tabViewController:self willDeselectedIndex:index];
    }
    return YES;
}

- (void)updateViewController:(UIViewController *)viewController {
    if (_selectedViewController != viewController) {
        
        static NSString *animationKey = @"transition";
        CATransition *transition = [CATransition animation];
        transition.timingFunction = UIViewAnimationCurveEaseInOut;
        transition.type = kCATransitionFade;//@"rippleEffect";
        
        [[self containerView].layer addAnimation:transition forKey:animationKey];
        
        if (_selectedViewController != nil) {
            [_selectedViewController.view removeFromSuperview];
            _selectedViewController = nil;
        }
        
        _selectedViewController = viewController;
        
        [_selectedViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin
                                                            |UIViewAutoresizingFlexibleHeight
                                                            |UIViewAutoresizingFlexibleTopMargin];
        
        [_selectedViewController.view setFrame:self.containerView.bounds];
        
        [[self selectedIndexStack] addObject:[NSNumber numberWithInt:(int)_selectedViewController.tabViewItem.index]];
        [[self containerView] addSubview:_selectedViewController.view];
    }
}

- (void)popToLast {
    [[self selectedIndexStack] removeLastObject];
    NSNumber *lastIndex = [[self selectedIndexStack] lastObject];
    if (lastIndex != nil) {
        NSUInteger index = [lastIndex integerValue];
        [[self selectedIndexStack] removeLastObject];
        [self setSelectedIndex:index];
    }
}

- (void)deselectIndex:(NSUInteger)index {
    [[self tabView] deselectIndex:index];
}

- (void)setTabViewHidden:(BOOL)hidden {
    if (_tabViewHidden == hidden) {
        return ;
    }
    _tabViewHidden = hidden;

    [self updateView:YES];
    
//    __block CGRect newFrame = self.view.bounds;
//    [UIView animateWithDuration:0.2 animations:^{
//        switch (self.position) {
//            case KITabViewPositionOfTop: {
//                newFrame.origin.y = _tabViewHidden?-[self tabViewHeight]:0;
//                newFrame.size.height += _tabViewHidden?[self tabViewHeight]:-[self tabViewHeight];
//                [self.view setFrame:newFrame];
//            }
//                break;
//            case KITabViewPositionOfBottom: {
//                newFrame.size.height += _tabViewHidden?[self tabViewHeight]:-[self tabViewHeight];
//                [self.view setFrame:newFrame];
//            }
//                break;
//            case KITabViewPositionOfLeft: {
//                
//            }
//                break;
//            case  KITabViewPositionOfRight: {
//                
//            }
//                break;
//            default:
//                break;
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (BOOL)tabViewHidden {
    return _tabViewHidden;
}


@end


NSString * const kTabViewController = @"kTabViewController";
NSString * const kTabViewItem       = @"kTabViewItem";

@implementation  UIViewController (KITabViewController)
@dynamic tabViewController;
@dynamic tabViewItem;

- (void)setTabViewController:(KITabViewController *)tabViewController {
    objc_setAssociatedObject(self, (__bridge const void *)(kTabViewController), tabViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (KITabViewController *)tabViewController {
    return objc_getAssociatedObject(self, (__bridge const void *)(kTabViewController));
}

- (void)setTabViewItem:(KITabViewItem *)tabViewItem {
    objc_setAssociatedObject(self, (__bridge const void *)(kTabViewItem), tabViewItem, OBJC_ASSOCIATION_ASSIGN);
}

- (KITabViewItem *)tabViewItem {
    return objc_getAssociatedObject(self, (__bridge const void *)(kTabViewItem));
}

@end

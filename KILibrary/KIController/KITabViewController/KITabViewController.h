//
//  KITabViewController.h
//  HA
//
//  Created by chen on 13-3-7.
//  
//

/*
 KITabViewController *tvc = [[KITabViewController alloc] initWithPosition:KITabViewPositionOfBottom autoLayout:NO];
 [tvc setDelegate:self];
 
 [tvc.view setFrame:CGRectMake(0, 0, 320, 400)];
 [self.view addSubview:tvc.view];
 
 NSMutableArray *items = [[NSMutableArray alloc] init];
 
 for (int i=0; i<5; i++) {
 ViewController1 *vc1 = [[ViewController1 alloc] initWithNibName:@"ViewController1" bundle:nil];
 UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc1];
 [vc1 release];
 KITabViewItem *item = nil;
 
 if (i==2) {
 item = [[KITabViewItem alloc] initWithViewController:nil];
 [item setFrame:CGRectMake(i*64, 49-60, 64, 60)];
 
 } else {
 item = [[KITabViewItem alloc] initWithViewController:nv];
 [item setFrame:CGRectMake(i*64, 0, 64, 49)];
 
 }
 
 [nv release];
 
 [items addObject:item];
 [item release];
 }
 
 [tvc setTabViewItems:items];
 [items release];
 
 [tvc setSelectedIndex:1];
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KITabView.h"

@protocol KITabViewControllerDelegate;

@interface KITabViewController : UIViewController <KITabViewDelegate> {
    __unsafe_unretained id<KITabViewControllerDelegate> _delegate;
    BOOL                            _autoLayout;
    KITabView                       *_tabView;
    BOOL                            _tabViewHidden;
    UIView                          *_containerView;
    KITabViewPosition               _position;
    NSUInteger                      _selectedIndex;
    KITabViewItem                   *_selectedItem;
    UIViewController                *_selectedViewController;
    UIView                          *_headerView;
    BOOL                            _headerViewHidden;
}

@property (nonatomic, assign) id<KITabViewControllerDelegate>   delegate;
@property (nonatomic, retain) KITabView                         *tabView;
@property (nonatomic, assign) NSUInteger                        selectedIndex;
@property (nonatomic, retain) KITabViewItem                     *selectedItem;
@property (nonatomic, assign) BOOL                              tabViewHidden;
@property (nonatomic, readonly) KITabViewPosition               position;
@property (nonatomic, readonly) BOOL                            autoLayout;
@property (nonatomic, retain) UIView                            *headerView;
@property (nonatomic, readonly) BOOL                            headerViewHidden;

- (id)initWithPosition:(KITabViewPosition)position autoLayout:(BOOL)autoLayout;

- (void)setTabViewBackgroundColor:(UIColor *)color;

- (void)setTabViewBackgroundImage:(UIImage *)image;

- (void)setTabBarHeaderView:(UIView *)view;

- (void)setTabBarFooterView:(UIView *)view;

- (void)setNumberOfItemsInPage:(NSUInteger)number;

- (void)setItemSelectedImage:(UIImage *)image margin:(UIEdgeInsets)margin;

- (CGFloat)tabViewHeight;

- (void)setTabViewItems:(NSMutableArray *)tabViewItems;

- (NSMutableArray *)tabViewItems;

- (void)popToLast;

- (void)deselectIndex:(NSUInteger)index;

- (void)setHeaderViewHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@protocol KITabViewControllerDelegate <NSObject>
@optional
- (CGFloat)tabViewHeightForTabViewController:(KITabViewController *)tabViewController;
- (UIEdgeInsets)edgeInsetsForTabViewController:(KITabViewController *)tabViewController;
- (void)tabViewController:(KITabViewController *)tabViewController didSelectedIndex:(NSUInteger)index;
- (void)tabViewController:(KITabViewController *)tabViewController didSelectedItem:(KITabViewItem *)item;
- (BOOL)tabViewController:(KITabViewController *)tabViewController willSelectIndex:(NSUInteger)index;
- (BOOL)tabViewController:(KITabViewController *)tabViewController willDeselectedIndex:(NSUInteger)index;
@end

@interface UIViewController (KITabViewController)
@property (nonatomic, assign, readonly) KITabViewController *tabViewController;
@property (nonatomic, assign, readonly) KITabViewItem       *tabViewItem;
@end

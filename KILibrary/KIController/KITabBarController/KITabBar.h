//
//  KITabBar.h
//  Kitalker
//
//  Created by chen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KITabBarItem.h"

#define kTabBarHeight 49.0f

@protocol KITabBarDelegate;
@interface KITabBar : UIScrollView {
    @private
    __unsafe_unretained id<KITabBarDelegate>    _tabBarDelegate;
    NSMutableArray          *_tabBarItems;
    UIView                  *_maskView;
    NSUInteger              _selectedIndex;
    KITabBarItem            *_selectedItem;
}

@property (nonatomic, assign) id<KITabBarDelegate> tabBarDelegate;

- (void)setTabBarItems:(NSArray *)items;

- (void)selectedItemWithIndex:(NSUInteger)index;

- (UIView *)maskView;

@end

@protocol KITabBarDelegate <NSObject>
- (void)didTabBarSelectedItem:(KITabBarItem *)item;
@end

//
//  KITabBarViewController.h
//  Kitalker
//
//  Created by chen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KITabBar.h"

@class KITabBarController;
@protocol KITabBarControllerDelegate <NSObject>
@optional
- (void)tabBarController:(KITabBarController *)controller didSelectedItem:(KITabBarItem *)item;
@end


@interface KITabBarController : UITabBarController <KITabBarDelegate, KITabBarControllerDelegate> {
    @private
    NSArray             *_tabBarItems;
    KITabBar            *_kiTabBar;
}

@property (nonatomic, retain) NSArray  *tabBarItems;

- (void)setTabBarBackgroundColor:(UIColor *)color;

- (void)setTabBarBackgroundImage:(UIImage *)image;

- (void)setTabBarMaskViewColor:(UIColor *)color;

- (void)setTabBarMaskViewImage:(UIImage *)image;

- (void)selectedItemWithIndex:(NSUInteger)index;

- (void)changeMaskViewIndex:(NSUInteger)index;

@end


//
//  KITabBar.m
//  Kitalker
//
//  Created by chen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITabBar.h"

@implementation KITabBar

@synthesize tabBarDelegate = _tabBarDelegate;

- (void)setTabBarItems:(NSArray *)items {
    if (items != nil && items.count > 0) {
        int itemCount = (int)items.count;
        _tabBarItems = [[NSMutableArray alloc] initWithCapacity:itemCount];
        
        for (int i=0; i<itemCount; i++) {
            KITabBarItem *item = [items objectAtIndex:i];
            [self addSubview:item];
            [item setIndex:i];
            [item addTarget:self action:@selector(tabBarItemHandler:) forControlEvents:UIControlEventTouchUpInside];
            [_tabBarItems addObject:item];
        }
    }
    [self setShowsVerticalScrollIndicator:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setBounces:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_tabBarItems != nil && _tabBarItems.count > 0) {
        int itemCount = (int)_tabBarItems.count;
        float itemWidth = MAX(self.bounds.size.width / 5, self.bounds.size.width / itemCount);
        
        for (int i=0; i<itemCount; i++) {
            CGRect itemFrame = CGRectMake(i*itemWidth,
                                          0,
                                          itemWidth,
                                          kTabBarHeight);
            KITabBarItem *item = (KITabBarItem *)[_tabBarItems objectAtIndex:i];
            [item setFrame:itemFrame];
            
            if (_selectedIndex == i) {
                [self selectedItemWithIndex:i];
            }
        }
        [self setContentSize:CGSizeMake(itemWidth*itemCount, kTabBarHeight)];
    }
}

- (void)selectedItemWithIndex:(NSUInteger)index {
    _selectedIndex = index;
    KITabBarItem *item = [_tabBarItems objectAtIndex:_selectedIndex];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:.2f];
    [[self maskView] setFrame:item.frame];
    [UIView commitAnimations];
    
    if (_selectedItem != item) {
        if (_tabBarDelegate != nil
            && [_tabBarDelegate respondsToSelector:@selector(didTabBarSelectedItem:)]) {
            [_tabBarDelegate didTabBarSelectedItem:item];
        }
    }
    
    [_selectedItem setSelected:NO];
    [item setSelected:YES];
    _selectedItem = item;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        [_maskView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
        [_maskView setUserInteractionEnabled:NO];
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (void)tabBarItemHandler:(KITabBarItem *)item {
    [self selectedItemWithIndex:item.index];
}



@end

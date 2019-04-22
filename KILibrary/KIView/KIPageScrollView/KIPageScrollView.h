//
//  KIPageScrollView.h
//  Seagate
//
//  Created by beartech on 14-9-23.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KIPageScrollViewDelegate;

@interface KIPageScrollView : UIImageView{
    
}
@property(nonatomic,assign) NSInteger currentPageIndex;
@property(nonatomic,weak) id<KIPageScrollViewDelegate> delegate;


/*设置页面之间间隙*/
- (void)setPageSpace:(CGFloat)pageSpace;

/*重新装载*/
- (void)reloadData;

/*滚动到某个页面*/
- (void)showPageIndex:(NSInteger)index animated:(BOOL)animated;

/*View复用的时候需要*/
- (UIView*)viewForPageIndex:(NSInteger)aIndex;

@end


#pragma mark ==================================================
#pragma mark ==代理
#pragma mark ==================================================
@protocol KIPageScrollViewDelegate <NSObject>

@required
- (UIView*)pageView:(KIPageScrollView*)pageView viewForPage:(NSInteger)pageIndex;

- (NSInteger)numberOfPagesInPageView:(KIPageScrollView*)pageView;

- (BOOL)pageViewCanRepeat:(KIPageScrollView*)pageView;

@optional

- (void)pageView:(KIPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex;

- (CGFloat)timeIntervalOfPageViewAutoCycle:(KIPageScrollView*)pageView;

@end

//
//  KITabBarButton.m
//  Kitalker
//
//  Created by chen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITabBarItem.h"

#define kTabBarItemPadding 2.0f
#define kTabBarTitleLabelHeight 14.0f

@implementation KITabBarItem

@synthesize index           = _index;
@synthesize title           = _title;
@synthesize normalImage     = _normalImage;
@synthesize selectedImage   = _selectedImage;
@synthesize viewController  = _viewController;
@synthesize badgeValue      = _badgeValue;

+ (KITabBarItem *)itemWithTitle:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage viewController:(UIViewController *)viewController {
    KITabBarItem *item = [[KITabBarItem alloc] init];
    [item setTitle:title];
    [item setNormalImage:normalImage];
    [item setSelectedImage:selectedImage];
    [item setViewController:viewController];
    
    return item;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _viewController) {
        [self setTitle:_viewController.title];
    }
}

- (KITabBarItem *)init {
    if (self = [super init]) {
    }
    return self;
}
    
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [_backgroundView setFrame:CGRectMake(kTabBarItemPadding,
//                                         kTabBarItemPadding,
//                                         self.bounds.size.width-kTabBarItemPadding*2,
//                                         self.bounds.size.height-kTabBarItemPadding*2)];
    
    [[self titleLabel] setFrame:CGRectMake(kTabBarItemPadding,
                                           self.bounds.size.height-kTabBarTitleLabelHeight-kTabBarItemPadding,
                                           self.bounds.size.width-kTabBarItemPadding*2,
                                           kTabBarTitleLabelHeight)];
    
    [[self imageView] setFrame:CGRectMake(kTabBarItemPadding,
                                          kTabBarItemPadding+3,
                                          self.bounds.size.width-kTabBarItemPadding*2,
                                          self.bounds.size.height-kTabBarTitleLabelHeight-kTabBarItemPadding*3-3)];
}

- (void)setViewController:(UIViewController *)viewController {
    if (_viewController != viewController) {
        [_viewController removeObserver:self forKeyPath:@"title" context:nil];
        
        _viewController = viewController;
        
        [_viewController addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [[self titleLabel] setText:_title];
}

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    [[self imageView] setImage:_normalImage];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
#ifdef kTabBarItemTitleColor
        [_titleLabel setTextColor:kTabBarItemTitleColor];
#else
        [_titleLabel setTextColor:[UIColor whiteColor]];
#endif
//        [_titleLabel setShadowColor:[UIColor grayColor]];
//        [_titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        [[self imageView] setImage:_selectedImage];
#ifdef kTabBarItemTitleHighlightColor
        [[self titleLabel] setTextColor:kTabBarItemTitleHighlightColor];
#else
        [[self titleLabel] setTextColor:[UIColor whiteColor]];
#endif
    } else {
        [[self imageView] setImage:_normalImage];
#ifdef kTabBarItemTitleColor
        [[self titleLabel] setTextColor:kTabBarItemTitleColor];
#else
        [[self titleLabel] setTextColor:[UIColor whiteColor]];
#endif
    }
    
    
}

- (void)setBadgeValue:(NSString *)badgeValue {
    if (_badgeValue != badgeValue) {
        _badgeValue = badgeValue;
        
        [[self badgeView] setBadgeText:badgeValue];
    }
    
    if ([badgeValue isNotEmptyString] && ![badgeValue isEqualToString:@"0"]) {
        [[self badgeView] setHidden:NO];
    } else {
        [[self badgeView] setHidden:YES];
    }
}

- (KIBadgeView *)badgeView {
    if (_badgeView == nil) {
        _badgeView = [[KIBadgeView alloc] initWithParentView:self alignment:KIBadgeViewAlignmentTopRight];
    }
    return _badgeView;
}



@end

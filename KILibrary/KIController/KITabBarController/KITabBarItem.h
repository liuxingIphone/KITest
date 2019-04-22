//
//  KITabBarButton.h
//  Kitalker
//
//  Created by chen on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KIBadgeView.h"
#import "NSString+KIAdditions.h"

@interface KITabBarItem : UIControl {
    @private
    NSUInteger          _index;
    NSString            *_title;
    UIImage             *_normalImage;
    UIImage             *_selectedImage;
    
    UILabel             *_titleLabel;
    UIImageView         *_imageView;
    
    UIViewController    *_viewController;
    
    NSString            *_badgeValue;
    KIBadgeView         *_badgeView;
}

@property (nonatomic, assign) NSUInteger        index;
@property (nonatomic, retain) NSString          *title;
@property (nonatomic, retain) UIImage           *normalImage;
@property (nonatomic, retain) UIImage           *selectedImage;
@property (nonatomic, retain) UIViewController  *viewController;
@property (nonatomic, retain) NSString          *badgeValue;

+ (KITabBarItem *)itemWithTitle:(NSString *)title normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage viewController:(UIViewController *)viewController;

- (void)setSelected:(BOOL)selected;

@end

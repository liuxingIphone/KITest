//
//  KIViewController.h
//  Kitalker
//
//  Created by chen on 13-4-16.
//
//

#import <UIKit/UIKit.h>
#import "KIThemeManager.h"
#import "KILocalizationManager.h"
#import "NSObject+KIAdditions.h"


@interface KIViewController : UIViewController{
    
}



- (void)closeNavigationBarTranslucent;

- (void)openNavigationBarTranslucent;

@end


@interface UIViewController (KI)

- (void)showCustomBackButton;

- (void)showCustomBackButton:(SEL)selector;

- (void)showHomeButton;

- (void)setNavLeftItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH;

- (void)setNavRightItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH;
- (void)setNavRightItem:(SEL)selector title:(NSString *)title color:(UIColor *)color;
- (void)setTitle:(NSString *)title;

- (void)setTitle:(NSString *)title isButtonModal:(BOOL)isButtonModal;


@end


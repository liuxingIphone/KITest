//
//  UIButton+KIAdditions.h
//  Kitalker
//
//  Created by chen on 12-11-23.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KIAdditions)

- (void)setImage:(UIImage *)normal
     highlighted:(UIImage *)highlighted
        disabled:(UIImage *)disabled
        selected:(UIImage *)selected;

- (void)setBackgroundImage:(UIImage *)normal
               highlighted:(UIImage *)highlighted
                  disabled:(UIImage *)disabled
                  selected:(UIImage *)selected;

- (void)setTitleColor:(UIColor *)normal
          highlighted:(UIColor *)highlighted
             disabled:(UIColor *)disabled
             selected:(UIColor *)selected;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)controlState;

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state contentMode:(UIViewContentMode)contentMode;

/*设置image和title的对齐方式和间距
 padding：间距
 aligmentVertical：是否竖向对齐
 备注：横向，左图右文字；竖向，上图下文字
 */
- (void)setContentPadding:(CGFloat)padding aligmentVertical:(BOOL)aligmentVertical;

@end

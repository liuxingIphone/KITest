//
//  UIFont+font.m
//  kitest
//
//  Created by Huamo on 2018/4/2.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "UIFont+font.h"
#import <objc/message.h>



@implementation UIFont (font)


+ (void)load {
    
    Method systimeFont = class_getClassMethod(self, @selector(systemFontOfSize:));
    
    Method kk_systimeFont = class_getClassMethod(self, @selector(kk_systemFontOfSize:));
    // 交换方法
    method_exchangeImplementations(kk_systimeFont, systimeFont);
    
}


+ (UIFont *)kk_systemFontOfSize:(CGFloat)pxSize{
    
    CGFloat pt = (pxSize/96)*72;
    
    //NSLog(@"pt--%f",pt);
    
    UIFont *font = [UIFont kk_systemFontOfSize:pt];
    
    return font;
    
}


@end

//
//  HMScaleScrollView.h
//  kitest
//
//  Created by Huamo on 2018/5/28.
//  Copyright © 2018年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMScaleScrollViewDelegate ;

@interface HMScaleScrollView : UIView{
    
}


@end


@protocol HMScaleScrollViewDelegate <NSObject>

-(void)scaleScrollView:(HMScaleScrollView *)scaleScrollView viewHeight:(CGFloat)height infomation:(NSDictionary *)infomation;

@end

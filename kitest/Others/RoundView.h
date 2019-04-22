//
//  RoundView.h
//  kitest
//
//  Created by Bear on 14/12/12.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundView : UIView{
    
}
@property (nonatomic,retain) CAShapeLayer *trackLayer;
@property (nonatomic,retain) CAShapeLayer *progressLayer;
@property (nonatomic,retain) UIBezierPath *path;

@end

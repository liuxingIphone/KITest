//
//  KINavigationController.h
//  Kitalker
//
//  Created by chen on 13-5-16.
//  
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface KINavigationController : UINavigationController{
    
    BOOL dragBackEnable;
}

@property (nonatomic,assign) BOOL dragBackEnable;

@end

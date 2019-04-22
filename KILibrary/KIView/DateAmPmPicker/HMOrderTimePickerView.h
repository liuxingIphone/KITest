//
//  HMOrderTimePickerView.h
//  Panda
//
//  Created by Huamo on 2018/9/11.
//  Copyright © 2018年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JSON_NODE_ampm_type    @"ampm_type"
#define JSON_NODE_ampm_name    @"ampm_name"

@protocol HMOrderTimePickerViewDelegate ;

@interface HMOrderTimePickerView : UIView{
    
}


- (instancetype)initWithDelegate:(id<HMOrderTimePickerViewDelegate>)delegate;

- (instancetype)initWithDelegate:(id<HMOrderTimePickerViewDelegate>)delegate originDate:(NSDate *)originDate originAmPm:(NSDictionary *)originAmPm;

- (void)show;


@end


@protocol HMOrderTimePickerViewDelegate <NSObject>

-(void)timePickerView:(HMOrderTimePickerView *)timePickerView selectedDate:(NSDate *)selectedDate selectedAmPm:(NSDictionary *)selectedAmPm;


@end




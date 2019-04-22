//
//  DatePickerAmPmController.m
//  kitest
//
//  Created by Huamo on 2018/9/11.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "DatePickerAmPmController.h"
#import "HMOrderTimePickerView.h"


@interface DatePickerAmPmController ()

@end

@implementation DatePickerAmPmController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1539245106];
    NSMutableDictionary *amPm = @{}.mutableCopy;
    [amPm setObject:@"上午" forKey:JSON_NODE_ampm_name];
    [amPm setObject:@"1" forKey:JSON_NODE_ampm_type];
    HMOrderTimePickerView *pickerView = [[HMOrderTimePickerView alloc]initWithDelegate:nil originDate:date originAmPm:amPm];
    [pickerView show];
    
    
}





@end

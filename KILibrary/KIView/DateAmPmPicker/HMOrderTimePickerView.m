
//
//  HMOrderTimePickerView.m
//  Panda
//
//  Created by Huamo on 2018/9/11.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "HMOrderTimePickerView.h"


@interface HMOrderTimePickerView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedAmPm;
    NSCalendar *calendar;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) id<HMOrderTimePickerViewDelegate>delegate;
@property (nonatomic,strong) NSDate *originDate;
@property (nonatomic,strong) NSDictionary *originAmPm;

@end


@implementation HMOrderTimePickerView

- (instancetype)initWithDelegate:(id<HMOrderTimePickerViewDelegate>)delegate{
    
    NSMutableDictionary *amPm = @{}.mutableCopy;
    [amPm setObject:@"上午" forKey:JSON_NODE_ampm_name];
    [amPm setObject:@"1" forKey:JSON_NODE_ampm_type];
    
    return [self initWithDelegate:delegate originDate:[NSDate date] originAmPm:amPm];
}

- (instancetype)initWithDelegate:(id<HMOrderTimePickerViewDelegate>)delegate originDate:(NSDate *)originDate originAmPm:(NSDictionary *)originAmPm{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _originDate = originDate;
        _originAmPm = [[NSDictionary alloc] initWithDictionary:originAmPm];
        
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.frame = [[UIScreen mainScreen] bounds];
        
        
        yearArray = @[].mutableCopy;
        monthArray = @[].mutableCopy;
        dayArray = @[].mutableCopy;
        
        
        
        CGFloat contentHeight = 216+50+SCREEN_BOTTOM_HEIGHT;
        UIView *contentV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - contentHeight, SCREEN_WIDTH, contentHeight)];
        contentV.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentV];
        self.contentV = contentV;
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 216)];
        self.pickerView.backgroundColor = [UIColor whiteColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        [contentV addSubview:self.pickerView];
        
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        upVeiw.backgroundColor = [UIColor whiteColor];
        [contentV addSubview:upVeiw];
        
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 50, 50);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:RGB_COLOR_String(@"0d8bf5") forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:cancelButton];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 62, 0, 50, 50);
        [chooseButton setTitle:@"完成" forState:UIControlStateNormal];
        chooseButton.backgroundColor = [UIColor clearColor];
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [chooseButton setTitleColor:RGB_COLOR_String(@"0d8bf5") forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, SCREEN_WIDTH-124, 30)];
        [upVeiw addSubview:_titleL];
        _titleL.textColor = [UIColor lightTextColor];
        _titleL.font = [UIFont systemFontOfSize:16];
        _titleL.textAlignment = NSTextAlignmentCenter;
        
        //分割线
        UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 0.5)];
        splitView.backgroundColor = [UIColor lightTextColor];
        [upVeiw addSubview:splitView];
        
        [self selectedOriginData];
        
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearArray.count;
        }
            break;
        case 1:
        {
            return monthArray.count;
        }
            break;
        case 2:
        {
            return dayArray.count;
        }
            break;
        case 3:
        {
            return 2;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*component/6.0, 0,SCREEN_WIDTH/6.0, 45)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.text=[NSString stringWithFormat:@"%ld年",[[yearArray objectAtIndex:row] integerValue]];
        }
            break;
        case 1:
        {
            label.text=[NSString stringWithFormat:@"%ld月",[[monthArray objectAtIndex:row] integerValue]];
        }
            break;
        case 2:
        {
            
            label.text=[NSString stringWithFormat:@"%ld日",[[dayArray objectAtIndex:row] integerValue]];
        }
            break;
        case 3:
        {
            
            label.textAlignment=NSTextAlignmentRight;
            if (row==0) {
                label.text= @"上午";
            }else{
                label.text= @"下午";
            }
            
        }
            break;
            
        default:
            break;
    }
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ([UIScreen mainScreen].bounds.size.width-60)/4;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
    
    switch (component) {
        case 0:
        {
            selectedYear = [[yearArray objectAtIndex:row] integerValue];
            
            
        }
            break;
        case 1:
        {
            selectedMonth=[[monthArray objectAtIndex:row] integerValue];
            
        }
            break;
        case 2:
        {
            selectedDay=[[dayArray objectAtIndex:row] integerValue];
        }
            break;
        case 3:
        {
            selectedAmPm=row+1;
            
        }
            break;
            
        default:
            break;
    }
    
    NSString *ampm = selectedAmPm==1 ? @"上午" : @"下午";
    _string =[NSString stringWithFormat:@"%ld年%.2ld月%.2ld日%@",selectedYear,selectedMonth,selectedDay,ampm];
    NSLog(@"%@", _string);
    
    [self handleData];
}



#pragma mark - private


- (void)selectedOriginData{
    
    
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:_originDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    selectedAmPm=[[_originAmPm valueObjectForKey:JSON_NODE_ampm_type] integerValue];
    
    
    [self handleData];
    
    NSInteger yearIndex = 0;
    NSInteger monthIndex = 0;
    NSInteger dayIndex = 0;
    for (NSInteger i=0; i<yearArray.count; i++) {
        if (selectedYear == [[yearArray objectAtIndex:i] integerValue]) {
            yearIndex = i;
            break;
        }
    }
    for (NSInteger i=0; i<monthArray.count; i++) {
        if (selectedMonth == [[monthArray objectAtIndex:i] integerValue]) {
            monthIndex = i;
            break;
        }
    }
    for (NSInteger i=0; i<dayArray.count; i++) {
        if (selectedDay == [[dayArray objectAtIndex:i] integerValue]) {
            dayIndex = i;
            break;
        }
    }
    
    [self.pickerView selectRow:yearIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:monthIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:dayIndex inComponent:2 animated:NO];
    [self.pickerView selectRow:selectedAmPm-1 inComponent:3 animated:NO];
    
    [self pickerView:self.pickerView didSelectRow:yearIndex inComponent:0];
    [self pickerView:self.pickerView didSelectRow:monthIndex inComponent:1];
    [self pickerView:self.pickerView didSelectRow:dayIndex inComponent:2];
    [self pickerView:self.pickerView didSelectRow:selectedAmPm-1 inComponent:3];
    
    //[self.pickerView reloadAllComponents];
    
    
    
}

- (void)handleData{
    
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    
    
    [yearArray removeAllObjects];
    [monthArray removeAllObjects];
    [dayArray removeAllObjects];
    
    
    
    
    for (NSInteger i=0; i<100; i++) {
        [yearArray addObject:[NSString stringWithInteger:i+year]];
    }
    
    if (selectedYear <= year) {
        
        for (NSInteger i=month; i<=12; i++) {
            [monthArray addObject:[NSString stringWithInteger:i]];
        }
        
        if (selectedMonth <= month) {
            
            NSInteger dayCount = [self isAllDay:selectedYear andMonth:selectedMonth];
            for (NSInteger i=day; i<=dayCount; i++) {
                [dayArray addObject:[NSString stringWithInteger:i]];
            }
            
        }
        
        
        
        
        
    }
    
    if (yearArray.count<=0) {
        for (NSInteger i=0; i<100; i++) {
            [yearArray addObject:[NSString stringWithInteger:i+year]];
        }
    }
    if (monthArray.count<=0) {
        for (NSInteger i=0; i<12; i++) {
            [monthArray addObject:[NSString stringWithInteger:i+1]];
        }
    }
    if (dayArray.count<=0) {
        NSInteger dayCount = [self isAllDay:selectedYear andMonth:selectedMonth];
        for (NSInteger i=0; i<dayCount; i++) {
            [dayArray addObject:[NSString stringWithInteger:i+1]];
        }
        
        if (selectedDay>dayArray.count) {
            selectedDay = dayArray.count;
        }
    }
    
    [self.pickerView reloadAllComponents];
}

//取消的隐藏
- (void)cancelButtonClick{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(timePickerView:selectedDate:selectedAmPm:)]) {
        [self.delegate timePickerView:self selectedDate:nil selectedAmPm:nil];
    }
    
    [self hide];
    
}

//确认的隐藏
-(void)configButtonClick{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(timePickerView:selectedDate:selectedAmPm:)]) {
        [self.delegate timePickerView:self selectedDate:nil selectedAmPm:nil];
    }
    
    [self hide];
}



-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self hide];
}



#pragma mark -- show and hidden

- (void)show{
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    [window addSubview:self];
    
    [self setOriginY:SCREEN_HEIGHT];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self setOriginY:0];
    }];
}

- (void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setOriginY:SCREEN_HEIGHT];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}




@end

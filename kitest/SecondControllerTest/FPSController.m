//
//  FPSController.m
//  kitest
//
//  Created by Huamo on 2018/4/17.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "FPSController.h"
#import "YYFPSLabel.h"
#import "UIView+layer.h"
#import "UIView+XWAddForRoundedCorner.h"


@interface FPSController () <UITableViewDelegate, UITableViewDataSource> {
    
}
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation FPSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YYFPSLabel showFPSInWindow];
    
    [self initTableView];
    
}


#pragma mark - tableview

- (void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _tableView.estimatedSectionHeaderHeight=0;
    _tableView.estimatedSectionFooterHeight=0;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}

//Setup your cell margins:
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//_dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionP{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"HMCaseListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = UIView.new;
        view.backgroundColor = [UIColor greenColor];
        view.frame = CGRectMake(20, 10, 80, 80);
        [cell addSubview:view];
        view.tag = 99;
        
        UILabel *_jingLabel = [UILabel new];
        _jingLabel.frame = CGRectMake(125, 5, 125, 20);
        _jingLabel.backgroundColor = RGB_COLOR_String(@"#E78380");
        _jingLabel.textColor = [UIColor whiteColor];
        _jingLabel.font = [UIFont systemFontOfSize:15];
        _jingLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:_jingLabel];
        _jingLabel.tag = 100;
        
        UIImageView *iamge = [[UIImageView alloc]init];
        iamge.frame = CGRectMake(150, 10, 80, 80);
        iamge.clipsToBounds = YES;
        iamge.image = [UIImage imageNamed:@"Xcode.png"];
        [cell addSubview:iamge];
        iamge.tag = 101;
        
    }
    
    UIView *view = (UIView *)[cell viewWithTag:99];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UIImageView *iamge = (UIImageView *)[cell viewWithTag:101];
    
//    view.layer.cornerRadius = 4.0f;
//    view.layer.borderColor = [UIColor redColor].CGColor;
//    view.layer.borderWidth = 1.0f;
//    view.layer.masksToBounds = YES;

//    [view addRoundedCorners:UIRectCornerAllCorners  withRadii:CGSizeMake(4.0, 4.0) viewRect:view.bounds];
    
    [view xw_roundedCornerWithCornerRadii:CGSizeMake(4, 4) cornerColor:[UIColor whiteColor] corners:UIRectCornerAllCorners borderColor:[UIColor redColor] borderWidth:1.0];
    [iamge xw_roundedCornerWithCornerRadii:CGSizeMake(4, 4) cornerColor:[UIColor whiteColor] corners:UIRectCornerAllCorners borderColor:[UIColor redColor] borderWidth:1.0];
    
    label.text = [NSString stringWithFormat:@"当前行数为：%ld", indexPath.row];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    
}





@end

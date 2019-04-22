//
//  SecondViewController.m
//  kitest
//
//  Created by HuamoMac on 15/7/1.
//  Copyright (c) 2015年 chen. All rights reserved.
//

#import "SecondViewController.h"
#import "KIConfig.h"
#import "KIImagesController.h"
#import "ViewRectController.h"
#import "AutoRecyleViewController.h"
#import "NormalTestController.h"
#import "BlockTestController.h"
#import "CoreTextController.h"
#import "TransformController.h"
#import "DijkstraAlgorithmController.h"
#import "VideoController.h"
#import "FPSController.h"
#import "XYScrollViewController.h"
#import "DatePickerAmPmController.h"


@interface SecondViewController () <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation SecondViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Second";
    //[self setNavBarStyleWithIndex:1];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIApplicationWidth, KIApplicationHeight-44-49) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self initDataArray];
    
    //[self.navigationController setNavBarClearColor];
}

- (void)initDataArray{
    _dataArray = [[NSMutableArray alloc] init];
    
    
    [_dataArray addObject:@"常规数据类型检查"];
    [_dataArray addObject:@"相册多选&&相机"];
    [_dataArray addObject:@"CGRectInset&&CGRectOffset"];
    [_dataArray addObject:@"自动循环滚动"];
    [_dataArray addObject:@"block研究"];
    [_dataArray addObject:@"coreText"];
    [_dataArray addObject:@"button缩放"];
    [_dataArray addObject:@"Dijkstra算法"];
    [_dataArray addObject:@"播放器"];
    [_dataArray addObject:@"FPS"];
    [_dataArray addObject:@"XYScroll"];
    [_dataArray addObject:@"DatePicker"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewContrller = nil;
    if (indexPath.row == 0) {
        viewContrller = [[NormalTestController alloc]init];
    }else if (indexPath.row == 1) {
        viewContrller = [[KIImagesController alloc]init];
    }else if (indexPath.row == 2){
        viewContrller = [[ViewRectController alloc]init];
    }else if (indexPath.row == 3){
        viewContrller = [[AutoRecyleViewController alloc]init];
    }else if (indexPath.row == 4){
        viewContrller = [[BlockTestController alloc]init];
    }else if (indexPath.row == 5){
        viewContrller = [[CoreTextController alloc]init];
    }else if (indexPath.row == 6){
        viewContrller = [[TransformController alloc]init];
    }else if (indexPath.row == 7){
        viewContrller = [[DijkstraAlgorithmController alloc]init];
    }else if (indexPath.row == 8){
        viewContrller = [[VideoController alloc]init];
    }else if (indexPath.row == 9){
        viewContrller = [[FPSController alloc]init];
    }else if (indexPath.row == 10){
        viewContrller = [[XYScrollViewController alloc]init];
    }else if (indexPath.row == 11){
        viewContrller = [[DatePickerAmPmController alloc] init];
    }
    
    
    
    viewContrller.title = [_dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewContrller animated:YES];
}

@end

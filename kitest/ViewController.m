//
//  ViewController.m
//  kitest
//
//  Created by bearmac on 14-11-13.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "ViewController.h"
#import "KIConfig.h"
#import "RoundView.h"
#import "CollectionViewController.h"
#import "KIImagePickerController.h"
#import "KIThemeTest.h"
#import "KKAdvertiseScrollView.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, KIRefreshTableViewDelegate, DataHttpLoaderDelegate, KIImagePickerControllerDelegate>

@property (nonatomic,retain) KITableView *tableView;
@property (nonatomic,strong) KKAdvertiseScrollView *adviewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KITest";
    
    //[self inittableView];
    
    
    
    //[self btnTest];
    
    
    //[self otherTest];
    
    //[self testCoding];
    
    //[self blockTest];
    
    //[self testImageMode];
    
    [self httpTest];
    
    //[self setNeedsStatusBarAppearanceUpdate];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self setNavBarStyleWithIndex:1];
    //[self viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    //[self dispathTest];
    
}


//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
//}
//
//- (BOOL)prefersStatusBarHidden
//{
//    return YES; //返回NO表示要显示，返回YES将hiden
//}
//
//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//    CGRect viewBounds = self.view.bounds;
//    CGFloat topBarOffset = 20.0;
//    viewBounds.origin.y = -topBarOffset;
//    self.view.bounds = viewBounds;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//for status bar style
//}

- (void)otherTest{
    //    CGRectDump(b.frame);
    //    NSStringFromCGRect(b.frame);
    //    CFShow((__bridge CFTypeRef)(NSStringFromCGRect(b.frame)));
    
    //http://www.wislightgroup.com:8080/publicservice/publicServiceAction_login.htm?json=true&loginname=geren1&password=e10adc3949ba59abbe56e057f20f883e
    //NSString *httpUrl = @"http://www.wislightgroup.com:8080/publicservice/publicServiceAction_login.htm?json=true&loginname=geren1&password=e10adc3949ba59abbe56e057f20f883e";
    
    
    
    //NSLog(@"%f---%ld----%@",[UIDevice getSystemVersion], (long)[UIDevice getSystemVerIntValue], [NSBundle bundleShortVersion]);
    
    //[NSBundle checkVersionWithAppleID:@"2222000" showNewestMsg:YES];
    
    
    //    RoundView *round = [[RoundView alloc]init];
    //    [self.view addSubview:round];
    
    //    [self dateStringWithFormat:KKDateFormatter04];
}


- (NSDate *) dateStringWithFormat:(NSString *) format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *oldDate = [formatter dateFromString:@"2014-12-01"];
    return oldDate;
}

- (void)dispathTest{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group1");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group2");
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"updateUi");
    });
    
}

- (void)httpTest{
    _adviewView = [[KKAdvertiseScrollView alloc]initWithFrame:CGRectMake(0, 0, KIApplicationWidth, 155.5) dataArray:nil];
    _adviewView.backgroundColor = [UIColor clearColor];
    //_adviewView.delegate = self;
    [self.view addSubview:_adviewView];
    
    
    DataHttpLoader *loader = nil;//[DataHttpLoader get_artisans_list:@"level" sort:nil page:nil page_size:nil name:nil delegate:self];
    NSString *pathStr = [NSString stringWithFormat:@"%@/default.bundle/%@",
                                            [[NSBundle mainBundle] bundlePath],
                                            @"aaaaaaaa"];;
    loader = [DataHttpLoader post_order_addEvaluate:self communication_rank:0 content:nil fileArrar:@[pathStr] object_id:nil professional_rank:0 punctual_rank:0 rating:0 order_no:nil];
    [loader startRequest];
    
    //[DataHttpLoader register_user:self];
    
//    DataHttp *loader = [DataLoader get_artisans_list:@"level" delegate:self];
//    [loader startRequest];
}

- (void)dataHttpLoader:(DataHttpLoader *)DataHttpLoader respondData:(RespondData *)respondData{
    NSLog(@"%@", respondData);
    
    [_adviewView setDataArray:respondData.allData];
}



- (void)btnTest{
    
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(6, 100, 60, 66);
    //    [button setBackgroundColor:[UIColor greenColor] forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"ico_notice"] forState:UIControlStateNormal];
    //    [button setTitle:@"说明" forState:UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:10];
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self.view addSubview:button];
    //    [button setContentPadding:0 aligmentVertical:YES];
    
    
    
    [self setBtn];
    
//    NSString *botunPath = [NSString stringWithFormat:@"%@/default.bundle/",
//                           [[NSBundle mainBundle] bundlePath]];
    
    
    UIImage *image = KIThemeTestImage(@"咪咖应用ICON-1024");
    UIImage *image1 = [UIImage imageNamed:@"屏幕快照 2015-04-14 下午7.18.08"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, 20, 100, 100);
    //[button setImage:[UIImage imageNamed:@"Xcode"] forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image1 forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    button.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setBtn{
    
    UIImage *buttonImage = [UIImage imageNamed:@"Xcode"];
    NSString *buttonTitle = @"中华人民共和国";
    UIFont *buttonTitleFont = [UIFont systemFontOfSize:17.0f];
    UIButton *b = [[UIButton alloc] init];
    b.frame = CGRectMake(10, 100, 100, 160);
    [b.titleLabel setFont:buttonTitleFont];
    [b setBackgroundColor:[UIColor redColor]];
    [b setImage:buttonImage forState:UIControlStateNormal];
    [b.imageView setBackgroundColor:[UIColor greenColor]];
    [b setTitle:buttonTitle forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[b setTitleColor:[UIColor scrollViewTexturedBackgroundColor] forState:UIControlStateHighlighted];
    [b.titleLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:b];
    [b setContentPadding:20 aligmentVertical:YES];
    [b addTarget:self action:@selector(avatarButonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //[b addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside]
}

- (void)pushView{
    CollectionViewController *viewController = [[CollectionViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)inittableView{
    _tableView = [[KITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    //[_tableView showRefreshHeader];
    [_tableView showRefreshHeaderAndFooterDragging];
    //    _tableView.refreshDeleagate = self;
    //    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyExchangeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 网络数据

// scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView tableViweDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView tableViewDidEndDragging:scrollView willDecelerate:decelerate];
}

//refresh delegate
- (void)refreshTableHeaderDidTriggerRefresh:(KIRefreshHeaderView *)view {
    
}

- (void)refreshTableFooterDraggingViewDidTriggerRefresh:(KIRefreshFooterDraggingView*)view {
    
}




- (void)testCoding{
    KICodingData *data = [[KICodingData alloc]initWithObject:@[@"1", @"2", @"3"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[data toData] forKey:@"DataArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
 
    
    NSData *da = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataArray"];
    KICodingData *data2 = [KICodingData fromData:da];
    NSLog(@"%@", data2.codeObject);
}



- (void)testImageMode{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(100, 100, 200, 300);
    imageView.backgroundColor = [UIColor lightGrayColor];
    imageView.image = [UIImage imageNamed:@"Xcode.png"];
    imageView.contentMode = UIViewContentModeBottom;
    [self.view addSubview:imageView];
    
}



#pragma mark - 切换用户图片



- (void)avatarButonClick{
    
    
    KIImagePickerController *picker = [[KIImagePickerController alloc]initWithDelegate:self viewController:[[[UIApplication sharedApplication]keyWindow]rootViewController]];
    
    [picker showWithDeleteButton:NO cropSize:CGSizeMake(200, 200) otherItems:nil];
    
    
}
- (void)imagePickerController:(KIImagePickerController *)controller didFinishPickImage:(UIImage *)image{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/userIcon.jpg", NSHomeDirectory()];
    if (image != nil) {
        [UIImageJPEGRepresentation(image, 0.5f) writeToFile:path atomically:YES];
        
        //[self performSelector:@selector(setPersonIcon:) withObject:image afterDelay:.2];
        
        //[self updateIconRequestWithImageName:@"" imagePath:path];
    }
}





@end

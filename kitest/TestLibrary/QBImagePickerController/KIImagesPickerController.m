//
//  KIImagesPickerController.m
//  QBImagePickerControllerDemo
//
//  Created by HuamoMac on 15/10/15.
//  Copyright © 2015年 Katsuma Tanaka. All rights reserved.
//

#import "KIImagesPickerController.h"


@interface KIImagesPickerController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
    
}
@property (nonatomic,weak) id<KIImagesPickerControllerDelegate> delegate;

@end



@implementation KIImagesPickerController


+ (void)showWithDelegate:(id<KIImagesPickerControllerDelegate>)delegate{
    
    KIImagesPickerController *controller = [[KIImagesPickerController alloc]init];
    controller.delegate = delegate;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:controller cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"1", @"2", nil];
    [sheet showInView:[[[UIApplication sharedApplication]delegate]window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 2){
        
    }else{
        
    }
    NSLog(@"dddddddd");
}



//打开相机
-(void)addCarema
{
    if (TARGET_IPHONE_SIMULATOR) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"模拟器不能使用相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        UIViewController *viewController = [[[[UIApplication sharedApplication]delegate]window] rootViewController];
        [viewController presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    
    [self dismissController];
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissController];
}

- (void)dismissController{
    UIViewController *viewController = [[[[UIApplication sharedApplication]delegate]window] rootViewController];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end

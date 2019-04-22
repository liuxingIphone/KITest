//
//  KIImagesController.m
//  kitest
//
//  Created by HuamoMac on 15/10/15.
//  Copyright © 2015年 chen. All rights reserved.
//

#import "KIImagesController.h"
#import "KIImagesPickerController.h"


@interface KIImagesController () <KIImagesPickerControllerDelegate> {
    
}

@end

@implementation KIImagesController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [KIImagesPickerController showWithDelegate:self];
    
}


@end

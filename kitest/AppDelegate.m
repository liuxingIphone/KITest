//
//  AppDelegate.m
//  kitest
//
//  Created by bearmac on 14-11-13.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "KIConfig.h"
#import "ViewController.h"
#import "RootTabController.h"
#import "UserManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //[[UserManager defaultManager]isLogin];
    [self initRootController];
    
    [self ssssss];
    
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initRootController{
//    ViewController *viewController = [[ViewController alloc]init];
//    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:viewController];
//    self.window.rootViewController =rootNav;
    
    
    RootTabController *viewController = [[RootTabController alloc]init];
    //UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:viewController];
    self.window.rootViewController = viewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




- (void)ssssss{
    NSMutableArray *fileList = [[NSMutableArray alloc]init];
    
    NSString *appDocDir = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
    
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
    for (NSString *aPath in contentOfFolder) {
        NSLog(@"apath: %@", aPath);
        NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
        {
            [fileList addObject:aPath];
        }
    }
}




@end

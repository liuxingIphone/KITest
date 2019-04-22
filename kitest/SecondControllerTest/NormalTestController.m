//
//  NormalTestController.m
//  kitest
//
//  Created by Huamo on 15/11/5.
//  Copyright © 2015年 chen. All rights reserved.
//

#import "NormalTestController.h"

@interface NormalTestController () {
    NSCondition *condition;
    NSMutableArray *products;
}



@end

@implementation NormalTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavBarClearColor];
    
    BOOL a = true;
    NSLog(@"---%d---", a);
    
    for (int i=-1; i<5; i++) {
        NSLog(@"-----%d", i);
    }
    
    
    //[self conditionTest];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


- (void)conditionTest
{
    
    products = [[NSMutableArray alloc] init];
    condition = [[NSCondition alloc] init];
    
    [NSThread detachNewThreadSelector:@selector(createConsumenr) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(createProducter) toTarget:self withObject:nil];
}

- (void)createConsumenr
{
    [condition lock];
    
    while ([products count] == 0) {
        NSLog(@"wait for products");
        [condition wait];
    }
    
    [products removeObjectAtIndex:0];
    NSLog(@"comsume a product");
    [condition unlock];
}

- (void)createProducter
{
    [condition lock];
    [products addObject:[[NSObject alloc] init]];
    NSLog(@"produce a product");
    [condition signal];
    [condition unlock];
}




@end

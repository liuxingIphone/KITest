//
//  LockViewController.m
//  kitest
//
//  Created by Huamo on 16/4/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "LockViewController.h"

#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>

#define ITERATIONS (1024*1024*32)


@interface LockViewController ()

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)testLock
{
    double then, now;
    unsigned int i, count;
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    OSSpinLock spinlock = OS_SPINLOCK_INIT;
    
    @autoreleasepool {
        NSLock *lock = [NSLock new];
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            [lock lock];
            [lock unlock];
        }
        now = CFAbsoluteTimeGetCurrent();
        printf("NSLock: %f sec\n", now-then);
        
        
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            pthread_mutex_lock(&mutex);
            pthread_mutex_unlock(&mutex);
        }
        now = CFAbsoluteTimeGetCurrent();
        printf("pthread_mutex: %f sec\n", now-then);
        
        
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            OSSpinLockLock(&spinlock);
            OSSpinLockUnlock(&spinlock);
        }
        now = CFAbsoluteTimeGetCurrent();
        printf("OSSpinlock: %f sec\n", now-then);
        
        id obj = [NSObject new];
        
        then = CFAbsoluteTimeGetCurrent();
        for(i=0;i<ITERATIONS;++i)
        {
            @synchronized(obj)
            {
            }
        }
        now = CFAbsoluteTimeGetCurrent();
        printf("@synchronized: %f sec\n", now-then);
    }
    
    
}




@end

//
//  BlockTestController.m
//  kitest
//
//  Created by Huamo on 15/11/16.
//  Copyright © 2015年 chen. All rights reserved.
//

#import "BlockTestController.h"


/*
 -fno-objc-arc
 
 由于Block是默认建立在栈上, 所以如果离开方法作用域, Block就会被丢弃,
 在非ARC情况下, 我们要返回一个Block ,需要 [Block copy];
 
 在ARC下, 以下几种情况, Block会自动被从栈复制到堆:
 
 1.被执行copy方法
 2.作为方法返回值
 3.将Block赋值给附有__strong修饰符的id类型的类或者Blcok类型成员变量时
 4.在方法名中含有usingBlock的Cocoa框架方法或者GDC的API中传递的时候.
 */

#if __has_feature(objc_arc) && __clang_major__ >= 3
#define OBJC_ARC_ENABLED 1
#endif // __has_feature(objc_arc)

#if OBJC_ARC_ENABLED
#define OBJC_RETAIN(object)         (object)
#define OBJC_COPY(object)           (object)
#define OBJC_RELEASE(object)        object = nil
#define OBJC_AUTORELEASE(object)    (object)
#else
#define OBJC_RETAIN(object)           [object retain]
#define OBJC_COPY(object)             [object copy]
#define OBJC_RELEASE(object)          [object release], object = nil
#define OBJC_AUTORELEASE(object)      [object autorelease]
#endif



@interface BlockTestController ()

@property (nonatomic,assign) void (^myblock) (void);
@property (nonatomic,assign) NSInteger resultCode;

@end

@implementation BlockTestController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self globalBlock];
    
    [self stackBlock];
    
    [self testCycleRetain];
    
    
    //[self onTest:nil];
    [self onTest2:nil];
    
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
}


#pragma mark - block memory type test

//create NSGlobalBlock
- (void)globalBlock{
    float (^sum)(float, float) = ^(float a, float b){
        
        return a + b;
    };
    
    NSLog(@"block is %@", sum);
}

- (void)stackBlock{
    NSArray *testArr = @[@"1", @"2"];
    
    void (^TestBlock)(void) = ^{
        
         NSLog(@"testArr :%@", testArr);
        
    };
    
    
    
    NSLog(@"block is %@", ^{
               NSLog(@"test Arr :%@", testArr);
              
          });
    
    //block is <__NSStackBlock__: 0xbfffdac0>
    
    //打印可看出block是一个
    //NSStackBlock, 即在栈上, 当函数返回时block将无效
    
    
    
    NSLog(@"block is %@", TestBlock);
    //block is <__NSMallocBlock__: 0x7a90e9e0>
    
    //上面这句在非arc中打印是  NSStackBlock, 但是在arc中就是NSMallocBlock
    
    //即在arc中默认会将block从栈复制到堆上，而在非arc中，则需要手动copy.
}


#pragma mark - test


- (void)testCycleRetain{
    __weak BlockTestController *bSelf = self;
    self.myblock = ^{
        [bSelf doSomethingWithComplent:^(id object) {
            NSLog(@"%@", object);
        }];
    };
    _myblock();
    
    void (^myBlock) (void) = ^{
        [self doSomethingWithComplent:^(id object) {
            NSLog(@"%@", object);
        }];
    };
    
    myBlock();
}

- (void)doSomethingWithComplent:(void (^)(id object))finished{
    NSLog(@"---doSomething---");
    
    NSArray *array = @[@"1"];
    
    finished(array);
}

- (void)dealloc{
    NSLog(@"no cycle retain");
}





#pragma mark - retain cycle test

+ (BlockTestController *)blockdemo
{
    return [[BlockTestController alloc]init];
}

- (void)setExecuteFinished:(executeFinishedBlock)block
{
    finishblock = block; //在非ARC下这里不能使用retain
}

- (void)setExecuteFinishedParam:(executeFinishedBlockParam)block
{
    finishblockparam = block; //在非ARC下这里不能使用retain
}

- (void)executeTest
{
    [self performSelector:@selector(executeCallBack) withObject:nil afterDelay:2];
}

- (void)executeCallBack
{
    _resultCode = 200;
    
    if (finishblock)
    {
        finishblock();
    }
    
    if (finishblockparam)
    {
        finishblockparam(self);
    }
}


- (IBAction)onTest:(id)sender
{
    BlockTestController *demo = [[BlockTestController alloc]init];
    [demo setExecuteFinished:^{
        if (demo.resultCode == 200) {
            NSLog(@"call back ok.");
        }
    }];
    
    [demo executeTest];
    
}


- (IBAction)onTest2:(id)sender
{
    //1正常
//    BlockTestController *weakDemo = [[BlockTestController alloc]init];
//    __weak typeof(BlockTestController) *demo = weakDemo;
    
    //2正常
    __weak BlockTestController *weakDemo = [BlockTestController blockdemo];
    
    //3失败
//    __weak BlockTestController *weakDemo = [[BlockTestController alloc]init];
    
    //4weakDemo不会释放
//    BlockTestController *weakDemo = [BlockTestController blockdemo];
    
    [self setExecuteFinished:^{
        if (self.resultCode == 200) {
            NSLog(@"call back ok.---1");
        }
    }];
    
    [weakDemo setExecuteFinishedParam:^(BlockTestController *control) {
        if (weakDemo.resultCode == 200) {
            NSLog(@"call back ok.--2");
        }
        
    }];
    
    [weakDemo executeTest];
}

@end

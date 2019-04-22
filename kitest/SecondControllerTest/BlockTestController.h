//
//  BlockTestController.h
//  kitest
//
//  Created by Huamo on 15/11/16.
//  Copyright © 2015年 chen. All rights reserved.
//

#import "KIViewController.h"

@class BlockTestController;
typedef void(^executeFinishedBlock)(void);
typedef void(^executeFinishedBlockParam)(BlockTestController *);


@interface BlockTestController : KIViewController{
    executeFinishedBlock finishblock;
    executeFinishedBlockParam finishblockparam;
}



/**
 *  每次调用都产生一个新对象
 *
 *  @return
 */
+ (BlockTestController *)blockdemo;

/**
 *  不带参数的block
 *
 *  @param block
 */
- (void)setExecuteFinished:(executeFinishedBlock)block;

/**
 *  带参数的block
 *
 *  @param block
 */
- (void)setExecuteFinishedParam:(executeFinishedBlockParam)block;

- (void)executeTest;


@end

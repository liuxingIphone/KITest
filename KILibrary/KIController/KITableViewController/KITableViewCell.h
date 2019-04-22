//
//  KITableViewCell.h
//  Kitalker
//
//  Created by chen on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KITableViewCellObject.h"
#import "UITableViewCell+KIAdditions.h"

#define kCellDefaultHeight 44.0f

@protocol KITableViewCellDelegate;
@interface KITableViewCell : UITableViewCell {
    @private
    __unsafe_unretained id<KITableViewCellDelegate> _delegate;
    CGFloat                     _cellHeight;
    @protected
    id                          _cellObject;
}

@property (nonatomic, assign) id<KITableViewCellDelegate>   delegate;
@property (nonatomic, assign) UITableViewStyle              tableStyle;

+ (CGFloat)cellHeight;

- (void)setIndexPath:(NSIndexPath *)indexPath numberOfRows:(NSUInteger)rows;

- (void)setCellObject:(id)object;
- (id)cellObject;

- (void)setCellHeight:(CGFloat)height;
- (CGFloat)cellHeight;

- (void)selectedObject:(id)object;
- (void)postMessage:(NSString *)message object:(id)object;

- (void)updateView;

@end

@protocol KITableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(KITableViewCell *)tableViewCell didSelectedObject:(id)object;
- (void)tableViewCell:(KITableViewCell *)tableViewCell didPostMessage:(NSString *)message object:(id)object;
- (void)tableViewCell:(KITableViewCell *)tableViewCell updateCellHeight:(CGFloat)height;
@end
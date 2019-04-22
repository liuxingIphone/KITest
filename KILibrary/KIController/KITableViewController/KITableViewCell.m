//
//  KITableViewCell.m
//  Kitalker
//
//  Created by chen on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITableViewCell.h"

@implementation KITableViewCell

@synthesize delegate = _delegate;

+ (CGFloat)cellHeight {
    return kCellDefaultHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setIndexPath:(NSIndexPath *)indexPath numberOfRows:(NSUInteger)rows {
    [self setIndexPath:indexPath];
}

- (void)setCellObject:(id)object {
    _cellObject = object;
}

- (id)cellObject {
    return _cellObject;
}

- (void)setCellHeight:(CGFloat)height {
    _cellHeight = height;
    if (_delegate != nil
        && [_delegate respondsToSelector:@selector(tableViewCell:updateCellHeight:)]) {
        [_delegate tableViewCell:self updateCellHeight:_cellHeight];
    }
}

- (CGFloat)cellHeight {
    return _cellHeight;
}

- (void)selectedObject:(id)object {
    if (_delegate != nil 
        && [_delegate respondsToSelector:@selector(tableViewCell:didSelectedObject:)]) {
        [_delegate tableViewCell:self didSelectedObject:object];
    }
}

- (void)postMessage:(NSString *)message object:(id)object {
    if (_delegate != nil
        && [_delegate respondsToSelector:@selector(tableViewCell:didPostMessage:object:)]) {
        [_delegate tableViewCell:self didPostMessage:message object:object];
    }
}

- (void)updateView {
    
}


@end

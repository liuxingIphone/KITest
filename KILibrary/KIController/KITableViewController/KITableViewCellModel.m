//
//  KITableViewCellModel.m
//  Kitalker
//
//  Created by chen on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITableViewCellModel.h"
#import "KITableViewCell.h"

@implementation KITableViewCellModel

@synthesize cellIdentifier  = _cellIdentifier;
@synthesize cellObject      = _cellObject;
@synthesize cellHeight      = _cellHeight;

- (KITableViewCellModel *)initWithIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        [self setCellIdentifier:identifier];
    }
    return self;
}

- (KITableViewCellModel *)initWithIdentifier:(NSString *)identifier cellObject:(id)object {
    if (self = [super init]) {
        [self setCellIdentifier:identifier];
        [self setCellObject:object];
    }
    return self;
}

- (CGFloat)cellHeight {
    if(_cellHeight == 0) {
        Class class = NSClassFromString(_cellIdentifier);
        _cellHeight = [class cellHeight];
    }
    return _cellHeight;
}

@end

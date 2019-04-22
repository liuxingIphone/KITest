//
//  KITableViewSectionModel.m
//  Kitalker
//
//  Created by chen on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITableViewSectionModel.h"
#import "KITableViewSection.h"

@implementation KITableViewSectionModel

@synthesize headerIdentifier    = _headerIdentifier;
@synthesize footerIdentifier    = _footerIdentifier;
@synthesize headerObject        = _headerObject;
@synthesize footerObject        = _footerObject;
@synthesize headerHeight        = _headerHeight;
@synthesize footerHeight        = _footerHeight;
@synthesize cellModels          = _cellModels;
@synthesize cellModels2         = _cellModels2;

- (KITableViewSectionModel *)init {
    if (self = [super init]) {
        _cellModels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (CGFloat)headerHeight {
    if (_headerHeight == 0) {
        Class class = NSClassFromString(_headerIdentifier);
        _headerHeight = [class headerHeight];
    }
    return _headerHeight;
}

- (NSMutableArray *)cellModels {
    if (_cellModels == nil) {
        _cellModels = [[NSMutableArray alloc] init];
    }
    return _cellModels;
}

- (CGFloat)footerHeight {
    if (_footerHeight == 0) {
        Class class = NSClassFromString(_footerIdentifier);
        _footerHeight = [class footerHeight];
    }
    return _footerHeight;
}

- (void)releaseCellModels2{
    _cellModels2 = nil;
}

- (void)copyCellModels_To_CellModels2{
    _cellModels2 = _cellModels;
    _cellModels = nil;
}


@end

//
//  KITableViewSection.m
//  Kitalker
//
//  Created by chen on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITableViewSection.h"

@implementation KITableViewSection

@synthesize delegate = _delegate;
@synthesize index = _index;

+ (CGFloat)headerHeight {
    return kSectionDefaultHeight;
}

+ (CGFloat)footerHeight {
    return kSectionDefaultHeight;
}

- (KITableViewSection *)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setSectionObject:(id)object {
    _sectionObject = object;
}

- (id)sectionObject {
    return _sectionObject;
}

- (void)postMessage:(NSString *)message object:(id)object {
    if (_delegate != nil
        && [_delegate respondsToSelector:@selector(tableViewSection:didPostMessage:object:)]) {
        [_delegate tableViewSection:self didPostMessage:message object:object];
    }
}

@end

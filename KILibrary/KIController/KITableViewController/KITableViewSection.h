//
//  KITableViewSection.h
//  Kitalker
//
//  Created by chen on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSectionDefaultHeight 22.0f

@protocol KITableViewSectionDelegate;
@interface KITableViewSection : UIView {
    __unsafe_unretained id<KITableViewSectionDelegate>  _delegate;
    @protected
    id                              _sectionObject;
    NSUInteger                      _index;
}

@property (nonatomic, assign) id<KITableViewSectionDelegate>    delegate;
@property (nonatomic, assign) NSUInteger                        index;

+ (CGFloat)headerHeight;
+ (CGFloat)footerHeight;

- (void)setSectionObject:(id)object;
- (id)sectionObject;

- (void)postMessage:(NSString *)message object:(id)object;
@end


@protocol KITableViewSectionDelegate <NSObject>
@optional
- (void)tableViewSection:(KITableViewSection *)section didPostMessage:(NSString *)message object:(id)object;
@end
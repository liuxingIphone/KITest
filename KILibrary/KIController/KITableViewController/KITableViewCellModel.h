//
//  KITableViewCellModel.h
//  Kitalker
//
//  Created by chen on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KITableViewCellModel : NSObject {
    NSString    *_cellIdentifier;
    id          _cellObject;
    CGFloat     _cellHeight;
}

@property (nonatomic, retain) NSString  *cellIdentifier;
@property (nonatomic, retain) id        cellObject;
@property (nonatomic, assign) CGFloat   cellHeight;

- (KITableViewCellModel *)initWithIdentifier:(NSString *)identifier;
- (KITableViewCellModel *)initWithIdentifier:(NSString *)identifier cellObject:(id)object;
@end

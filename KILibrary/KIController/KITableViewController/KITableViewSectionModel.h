//
//  KITableViewSectionModel.h
//  Kitalker
//
//  Created by chen on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KITableViewSectionModel : NSObject {
    NSString        *_headerIdentifier;
    NSString        *_footerIdentifier;
    id              _headerObject;
    id              _footerObject;
    CGFloat         _headerHeight;
    CGFloat         _footerHeight;
    
    NSMutableArray  *_cellModels;
    NSMutableArray  *_cellModels2; //用于展开/收缩时存放cellModels里面的值
}

@property (nonatomic, retain) NSString          *headerIdentifier;
@property (nonatomic, retain) NSString          *footerIdentifier;
@property (nonatomic, retain) id                headerObject;
@property (nonatomic, retain) id                footerObject;
@property (nonatomic, assign) CGFloat           headerHeight;
@property (nonatomic, assign) CGFloat           footerHeight;

@property (nonatomic, retain) NSMutableArray    *cellModels;
@property (nonatomic, retain) NSMutableArray    *cellModels2;

- (void)releaseCellModels2;
- (void)copyCellModels_To_CellModels2;

@end

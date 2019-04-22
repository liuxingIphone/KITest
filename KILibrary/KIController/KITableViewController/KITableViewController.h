//
//  KITableViewController.h
//  Kitalker
//
//  Created by chen on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KITableViewCell.h"
#import "KITableViewCellModel.h"
#import "KITableViewSection.h"
#import "KITableViewSectionModel.h"
#import "KITableViewCellObject.h"

@interface KITableViewController : UITableViewController <KITableViewCellDelegate, KITableViewSectionDelegate> {
    @private
    NSMutableArray      *_tableViewDataSource;
    BOOL                _isShowSearchResult;
}

- (void)reloadCurrentCells;

- (BOOL)hasDataSource;

- (NSMutableArray *)tableViewDataSource;

- (void)reloadTableViewDataSource:(NSArray *)dataSource;
- (void)reloadTableViewDataSourceForSearchResult:(NSArray *)dataSource;
- (void)removeTableViewDataSource;

- (id)cellObjectAtIndexPath:(NSIndexPath *)indexPath;
- (id)cellObjectAtIndex:(NSUInteger)index;

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;

- (void)deselectCell:(UITableViewCell *)cell;

- (KITableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;
- (KITableViewCellModel *)cellModelAtIndex:(NSUInteger)index;

- (KITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
- (KITableViewCell *)cellAtIndex:(NSUInteger)index;

- (KITableViewSectionModel *)sectionModelAtIndexPath:(NSIndexPath *)indexPath;
- (KITableViewSectionModel *)sectionModelAtIndex:(NSUInteger)index;

/*cell*/
- (void)insertCellModelToFirst:(KITableViewCellModel *)cellModel;
- (void)insertCellModelToFirst:(KITableViewCellModel *)cellModel inSection:(NSUInteger)section;
- (void)insertCellModelsToFirst:(NSArray *)cellModels;
- (void)insertCellModelsToFirst:(NSArray *)cellModels inSection:(NSUInteger)section;

- (void)insertCellModelToLast:(KITableViewCellModel *)cellModel;
- (void)insertCellModelToLast:(KITableViewCellModel *)cellModel inSection:(NSUInteger)section;
- (void)insertCellModelsToLast:(NSArray *)cellModels;
- (void)insertCellModelsToLast:(NSArray *)cellModels inSection:(NSUInteger)section;

- (void)insertCellModel:(KITableViewCellModel *)cellModel toRowAtIndex:(NSUInteger)index;
- (void)insertCellModel:(KITableViewCellModel *)cellModel toRowAtIndex:(NSUInteger)index inSection:(NSUInteger)section;

- (void)insertCellModel:(KITableViewCellModel *)cellModel toRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)insertCellModels:(NSArray *)cellModels toRowsAtIndexPaths:(NSArray *)indexPaths;

- (void)deleteTableViewCell:(KITableViewCell *)cell;

- (void)deleteCellModelsInSection:(NSUInteger)index;
- (void)deleteCellModelAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteCellModelsAtIndexPaths:(NSArray *)indexPaths;

- (void)reloadCellModelAtIndex:(NSUInteger)index;
- (void)reloadCellModelAtIndexPath:(NSIndexPath *)indexPath;
- (void)relaodCellModelsAtIndexPaths:(NSArray *)indexPaths;

/*section*/
- (void)insertSectionModel:(KITableViewSectionModel *)sectionModel toIndex:(NSUInteger)index;

- (void)insertSectionModelToFirst:(KITableViewSectionModel *)sectionModel;
- (void)insertSectionModelToLast:(KITableViewSectionModel *)sectionModel;

- (void)deleteSectionAtIndex:(NSUInteger)index;
- (void)deleteSectionsAtIndexs:(NSArray *)indexs;

- (void)reloadSectionModelAtIndex:(NSUInteger)index;
- (void)reloadSectionModelsAtIndexs:(NSArray *)indexs;

- (BOOL)sectionCanExpandWithIndex:(NSUInteger)index;
- (void)expandSectionWithIndex:(NSUInteger)index;
- (void)closeSectionWithIndex:(NSUInteger)index;
@end

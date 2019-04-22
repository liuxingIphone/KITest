//
//  KITableViewController.m
//  Kitalker
//
//  Created by chen on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KITableViewController.h"

@interface KITableViewController ()

@end

@implementation KITableViewController

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)initComplete {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureHandler:)];
    [tapGesture setCancelsTouchesInView:NO];
    [self.currentTableView addGestureRecognizer:tapGesture];
    
}

- (void)tapGestureHandler:(UIGestureRecognizer *)gesture {
    /*
     用这行代码来关闭Cell里面输入框打开的键盘
     */
    [[self currentTableView] endEditing:YES];
    [[[self currentTableView] superview] endEditing:YES];
    if (self.navigationItem != nil) {
        [self.navigationItem.titleView endEditing:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initComplete];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)isSections {
    if ([self tableViewDataSource] != nil && [self tableViewDataSource].count > 0) {
        id object = [[self tableViewDataSource] objectAtIndex:0];
        if ([object isKindOfClass:[KITableViewSectionModel class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)reloadCurrentCells {
    [self.currentTableView reloadRowsAtIndexPaths:[self.currentTableView indexPathsForVisibleRows]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL)hasDataSource {
    if (_tableViewDataSource == nil || _tableViewDataSource.count <= 0) {
        return NO;
    }
    return YES;
}

- (NSMutableArray *)tableViewDataSource {
    if (_tableViewDataSource == nil) {
        _tableViewDataSource = [[NSMutableArray alloc] init];
    }
    return _tableViewDataSource;
}

- (UITableView *)currentTableView {
    if (_isShowSearchResult) {
        return self.searchDisplayController.searchResultsTableView;
    }
    return self.tableView;
}

- (void)reloadTableViewDataSource:(NSArray *)dataSource {
    _isShowSearchResult = NO;
    [self reloadData:dataSource];
}

- (void)reloadTableViewDataSourceForSearchResult:(NSArray *)dataSource {
    _isShowSearchResult = YES;
    [self reloadData:dataSource];
}

- (void)reloadData:(NSArray *)dataSource {
    [[self tableViewDataSource] removeAllObjects];
//    [[self tableViewDataSource] addObjectsFromArray:dataSource];
    
    [self.currentTableView reloadData];
    
    if (dataSource.count > 0) {
        BOOL isCell = [[dataSource objectAtIndex:0] isKindOfClass:[KITableViewCellModel class]];
        if (isCell) {
            [self insertCellModelsToFirst:dataSource];
        } else {
            [[self tableViewDataSource] addObjectsFromArray:dataSource];
            [self.currentTableView reloadData];
        }
    }
}

- (void)removeTableViewDataSource {
    [[self tableViewDataSource] removeAllObjects];
    [self.currentTableView reloadData];
}

- (id)cellObjectAtIndexPath:(NSIndexPath *)indexPath {
    return [[self cellModelAtIndexPath:indexPath] cellObject];
}

- (id)cellObjectAtIndex:(NSUInteger)index {
    return [self cellObjectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    return [self.currentTableView indexPathForCell:cell];
}

- (void)deselectCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    [self.currentTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (KITableViewCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isSections]) {
        KITableViewSectionModel *sectionModel = [self sectionModelAtIndexPath:indexPath];
        return [[sectionModel cellModels] objectAtIndex:indexPath.row];
    }
    return [self cellModelAtIndex:indexPath.row];
}

- (KITableViewCellModel *)cellModelAtIndex:(NSUInteger)index {
    if ([self tableViewDataSource].count > 0) {
        return [[self tableViewDataSource] objectAtIndex:index];
    }
    return nil;
}

- (KITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    return (KITableViewCell *)[self.currentTableView cellForRowAtIndexPath:indexPath];
}
- (KITableViewCell *)cellAtIndex:(NSUInteger)index {
    return (KITableViewCell *)[self.currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (KITableViewSectionModel *)sectionModelAtIndexPath:(NSIndexPath *)indexPath {
    return [self sectionModelAtIndex:indexPath.section];
}

- (KITableViewSectionModel *)sectionModelAtIndex:(NSUInteger)index {
    if ([self isSections]) {
        return [[self tableViewDataSource] objectAtIndex:index];
    }
    return nil;
}

/*cell model*/
- (void)insertCellModelToFirst:(KITableViewCellModel *)cellModel {
    [self insertCellModelsToFirst:[NSArray arrayWithObjects:cellModel, nil]];
}

- (void)insertCellModelToFirst:(KITableViewCellModel *)cellModel inSection:(NSUInteger)section {
    [self insertCellModel:cellModel toRowAtIndex:0 inSection:section];
}

- (void)insertCellModelsToFirst:(NSArray *)cellModels {
    [self insertCellModelsToFirst:cellModels inSection:0];
}

- (void)insertCellModelsToFirst:(NSArray *)cellModels inSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    NSIndexPath *indexPath;
    for (int i=0; i<cellModels.count; i++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    
    [self insertCellModels:cellModels toRowsAtIndexPaths:indexPaths];
}

- (void)insertCellModelToLast:(KITableViewCellModel *)cellModel {
    [self insertCellModelsToLast:[NSArray arrayWithObjects:cellModel, nil]];
}

- (void)insertCellModelToLast:(KITableViewCellModel *)cellModel inSection:(NSUInteger)section {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:section];
    [self insertCellModel:cellModel toRowAtIndex:sectionModel.cellModels.count inSection:section];
}

- (void)insertCellModelsToLast:(NSArray *)cellModels {
    [self insertCellModelsToLast:cellModels inSection:0];
}

- (void)insertCellModelsToLast:(NSArray *)cellModels inSection:(NSUInteger)section {
    NSUInteger row = [[self tableViewDataSource] count] - 1;
    if ([self isSections]) {
        KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:section];
        row = [sectionModel.cellModels count]-1;
    }
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    NSIndexPath *indexPath;
    for (int i=1; i<cellModels.count+1; i++) {
        indexPath = [NSIndexPath indexPathForRow:row+i inSection:section];
        [indexPaths addObject:indexPath];
    }
    [self insertCellModels:cellModels toRowsAtIndexPaths:indexPaths];
}

- (void)insertCellModel:(KITableViewCellModel *)cellModel toRowAtIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self insertCellModel:cellModel toRowAtIndexPath:indexPath];
}

- (void)insertCellModel:(KITableViewCellModel *)cellModel toRowAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
    [self insertCellModel:cellModel toRowAtIndexPath:indexPath];
}

- (void)insertCellModel:(KITableViewCellModel *)cellModel toRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    NSArray *cellModels = [NSArray arrayWithObjects:cellModel, nil];
    [self insertCellModels:cellModels toRowsAtIndexPaths:indexPaths];
}

- (void)insertCellModels:(NSArray *)cellModels toRowsAtIndexPaths:(NSArray *)indexPaths {
    NSIndexPath *indexPath;
    id cellModel;
    NSMutableArray *tempCellModels;
    KITableViewSectionModel *sectionModel;
    
    BOOL isSection = [self isSections];
    
    for (int i=0; i<indexPaths.count; i++) {
        indexPath = [indexPaths objectAtIndex:i];
        cellModel = [cellModels objectAtIndex:i];
        
        tempCellModels = [self tableViewDataSource];
        
        if (isSection) {
            sectionModel = [self sectionModelAtIndexPath:indexPath];
//            if (sectionModel.cellModels == nil) {
//                sectionModel.cellModels = [[NSMutableArray alloc] init];
//            }
            tempCellModels = sectionModel.cellModels;
        }
        
        if ([tempCellModels count] == 0) {
            [tempCellModels addObject:cellModel];
        } else {
            [tempCellModels insertObject:cellModel atIndex:indexPath.row];
        }
    }
    
    [self.currentTableView beginUpdates];
    [self.currentTableView insertRowsAtIndexPaths:indexPaths 
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView endUpdates];
}

- (void)deleteTableViewCell:(KITableViewCell *)cell {
    NSIndexPath *indexPath = [self.currentTableView indexPathForCell:cell];
    [self deleteCellModelAtIndexPath:indexPath];
}

- (void)deleteCellModelsInSection:(NSUInteger)index {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:index];
    
    if (sectionModel.cellModels == nil
        || [sectionModel.cellModels count] <= 0) {
        return ;
    }
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath;
    for (int i=0; i<sectionModel.cellModels.count; i++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:index];
        [indexPaths addObject:indexPath];
    }
    
    sectionModel.cellModels = nil;
    
    [self.currentTableView beginUpdates];
    [self.currentTableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView endUpdates];
}

- (void)deleteCellModelAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    [self deleteCellModelsAtIndexPaths:indexPaths];
}

- (void)deleteCellModelsAtIndexPaths:(NSArray *)indexPaths {
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath;
    NSMutableArray *cellModels;
    KITableViewSectionModel *sectionModel;
    BOOL isSection = [self isSections];
    for (NSInteger i=indexPaths.count-1; i>=0; i--) {
        indexPath = [indexPaths objectAtIndex:i];
        
        cellModels = [self tableViewDataSource];
        
        if (isSection) {
            sectionModel = [self sectionModelAtIndexPath:indexPath];
            cellModels = sectionModel.cellModels;
        }
        
        if (indexPath.row < cellModels.count) {
            [cellModels removeObjectAtIndex:indexPath.row];
            [indexPathsToDelete addObject:indexPath];
        }
    }
    [self.currentTableView beginUpdates];
    [self.currentTableView deleteRowsAtIndexPaths:indexPathsToDelete
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView endUpdates];
}

- (void)reloadCellModelAtIndex:(NSUInteger)index {
    [self reloadCellModelAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)reloadCellModelAtIndexPath:(NSIndexPath *)indexPath {
    [self relaodCellModelsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}

- (void)relaodCellModelsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count <= 0) {
        return ;
    }
    [self.currentTableView beginUpdates];
    [self.currentTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView endUpdates];
}

/*section*/
- (void)insertSectionModel:(KITableViewSectionModel *)sectionModel toIndex:(NSUInteger)index {
    NSUInteger length = [sectionModel.cellModels count];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, length)];
    [[self tableViewDataSource] insertObject:sectionModel atIndex:index];
    
    [self.currentTableView beginUpdates];
    [self.currentTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView endUpdates];
}

- (void)insertSectionModelToFirst:(KITableViewSectionModel *)sectionModel {
    [self insertSectionModel:sectionModel toIndex:0];
}

- (void)insertSectionModelToLast:(KITableViewSectionModel *)sectionModel {
    NSUInteger index = [self tableViewDataSource].count;
    [self insertSectionModel:sectionModel toIndex:index];
}

- (void)deleteSectionAtIndex:(NSUInteger)index {
    [self deleteSectionsAtIndexs:[NSArray arrayWithObjects:[NSNumber numberWithInteger:index],
                                       nil]];
}

- (void)deleteSectionsAtIndexs:(NSArray *)indexs {
    [self.currentTableView beginUpdates];
    NSUInteger index;
    NSIndexSet *indexSet;
    for (int i=0; i<indexs.count; i++) {
        index = [[indexs objectAtIndex:i] intValue];
        indexSet = [NSIndexSet indexSetWithIndex:index];
        [[self tableViewDataSource] removeObjectAtIndex:index];
        [self.currentTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.currentTableView endUpdates];
}

- (void)reloadSectionModelAtIndex:(NSUInteger)index {
    [self reloadSectionModelsAtIndexs:[NSArray arrayWithObjects:[NSNumber numberWithInteger:index],
                                       nil]];
}

- (void)reloadSectionModelsAtIndexs:(NSArray *)indexs {
    [self.currentTableView beginUpdates];
    NSIndexSet *indexSet;
    for (int i=0; i<indexs.count; i++) {
        indexSet = [NSIndexSet indexSetWithIndex:[[indexs objectAtIndex:i] intValue]];
        [self.currentTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.currentTableView endUpdates];
}

- (BOOL)sectionCanExpandWithIndex:(NSUInteger)index {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:index];
    if (sectionModel.cellModels2 == nil
        || [sectionModel.cellModels2 count] <= 0) {
        return NO;
    }
    return YES;
}

- (void)expandSectionWithIndex:(NSUInteger)index {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:index];
    if (sectionModel.cellModels2 == nil
        || [sectionModel.cellModels2 count] <= 0) {
        return ;
    }
    sectionModel.cellModels = [NSMutableArray arrayWithArray:sectionModel.cellModels2];
    [sectionModel releaseCellModels2];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath;
    for (int i=0; i<sectionModel.cellModels.count; i++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:index];
        [indexPaths addObject:indexPath];
    }
    [self.currentTableView beginUpdates];
    [self.currentTableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView endUpdates];
}

- (void)closeSectionWithIndex:(NSUInteger)index {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:index];
    if (sectionModel.cellModels == nil
        || [sectionModel.cellModels count] <= 0) {
        return ;
    }
    [sectionModel copyCellModels_To_CellModels2];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath;
    for (int i=0; i<sectionModel.cellModels2.count; i++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:index];
        [indexPaths addObject:indexPath];
    }
    [self.currentTableView beginUpdates];
    [self.currentTableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.currentTableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self isSections]) {
        return [[self tableViewDataSource] count];
    }
    return 1;
}

/*section header*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionModelAtIndex:section] headerIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:section];
    if (sectionModel.headerHeight != 0) {
        return sectionModel.headerHeight;
    }
    if (sectionModel.headerIdentifier != nil) {
        return kSectionDefaultHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:section];
    KITableViewSection *headerView = nil;
    if (sectionModel.headerIdentifier != nil) {
        if ([[NSBundle mainBundle] pathForResource:sectionModel.headerIdentifier ofType:@"nib"] != nil) {
            headerView = [[[NSBundle mainBundle] loadNibNamed:sectionModel.headerIdentifier owner:self options:nil] objectAtIndex:0];
        } else {
            Class HeaderViewClass = NSClassFromString(sectionModel.headerIdentifier);
            headerView = [[HeaderViewClass alloc] init];
        }
    }
    if (headerView != nil) {
        [headerView setDelegate:self];
        [headerView setSectionObject:sectionModel.headerObject];
        [headerView setIndex:section];
    }
    return headerView;
}

/*section footer*/
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[self sectionModelAtIndex:section] footerIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:section];
    if (sectionModel.footerHeight != 0) {
        return sectionModel.footerHeight;
    }
    
    if (sectionModel.footerIdentifier != nil) {
        return kSectionDefaultHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:section];
    KITableViewSection *footerView = nil;
    if (sectionModel.footerIdentifier != nil) {
        if ([[NSBundle mainBundle] pathForResource:sectionModel.footerIdentifier ofType:@"nib"] != nil) {
            footerView = [[[NSBundle mainBundle] loadNibNamed:sectionModel.footerIdentifier owner:self options:nil] objectAtIndex:0];
        } else {
            Class FooterViewClass = NSClassFromString(sectionModel.footerIdentifier);
            footerView = [[FooterViewClass alloc] init];
        }
    }
    if (footerView != nil) {
        [footerView setDelegate:self];
        [footerView setSectionObject:sectionModel.footerObject];
        [footerView setIndex:section];
    }
    return footerView;
}


/*tableview cell*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isSections]) {
        KITableViewSectionModel *sectionModel = [self sectionModelAtIndex:section];
        
        NSInteger rowCount = [sectionModel.cellModels count];
        if (rowCount==0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else{
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        
        return rowCount;

    }
    
    NSInteger rowCount = [[self tableViewDataSource] count];
    if (rowCount==0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KITableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    
    NSString *cellIdentifier = [cellModel cellIdentifier];
    KITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        if ([[NSBundle mainBundle] pathForResource:cellIdentifier ofType:@"nib"] != nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
        } else {
            Class CellClass = NSClassFromString(cellIdentifier);
            cell = [[CellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setDelegate:self];
    }
    [cell setTableStyle:tableView.style];
    [cell setCellObject:[cellModel cellObject]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KITableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    
    if (cellModel != nil) {
        return cellModel.cellHeight;
    }
    return kSectionDefaultHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.currentTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - KITableViewSectionDelegate
- (void)tableViewSection:(KITableViewSection *)section didPostMessage:(NSString *)message object:(id)object {
#pragma mark 在子类重写
}

#pragma mark - KITableViewCellDelegate
- (void)tableViewCell:(KITableViewCell *)tableViewCell didSelectedObject:(id)object {
#pragma mark 在子类中重写
}

- (void)tableViewCell:(KITableViewCell *)tableViewCell didPostMessage:(NSString *)message object:(id)object {
#pragma mark 在子类中重写
}

- (void)tableViewCell:(KITableViewCell *)tableViewCell updateCellHeight:(CGFloat)height {
    NSIndexPath *indexPath = [self indexPathForCell:(UITableViewCell *)tableViewCell];
    KITableViewCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    [cellModel setCellHeight:height];
    [self reloadCellModelAtIndexPath:indexPath];
}


@end

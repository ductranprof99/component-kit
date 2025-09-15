//
//  ComponentKitViewController.mm
//  CKTest
//
//  Created by Duc Tran on 11/9/25.
//
#import <ComponentKit/ComponentKit.h>
#import "ComponentKitViewController.h"
#import "CellModel.h"
#import "CellDataLoader.h"
#import "WrapperComponent.h"
#import "CellContext.h"

@interface ComponentKitViewController () <CKComponentProvider, UICollectionViewDelegateFlowLayout>

@end

@implementation ComponentKitViewController
{
    CKCollectionViewTransactionalDataSource *_dataSource;
    CKComponentFlexibleSizeRangeProvider *_sizeRangeProvider;
    CellDataLoader *_cellDataLoader;
    BOOL isRendered;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
        _cellDataLoader = [[CellDataLoader alloc] init];
        // Demo data
    }
    isRendered = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
}
- (void)viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    if (isRendered) {
        return;
    }
    isRendered = YES;
    const CKSizeRange sizeRange = [_sizeRangeProvider sizeRangeForBoundingSize:self.collectionView.bounds.size];
    NSSet *imageNames = [NSSet setWithObjects:
                         @"LosAngeles",
                         @"MarketStreet",
                         @"Drops",
                         @"Powell",
                         nil];
    CKTransactionalComponentDataSourceConfiguration *config =
    [[CKTransactionalComponentDataSourceConfiguration alloc]
     initWithComponentProvider:[self class]
     context:nil
     sizeRange:sizeRange];
    
    _dataSource = [[CKCollectionViewTransactionalDataSource alloc]
                       initWithCollectionView:self.collectionView
                       supplementaryViewDataSource:nil
                       configuration:config];
    
    // Insert section 0.
    CKTransactionalComponentDataSourceChangeset *initial =
    [[[CKTransactionalComponentDataSourceChangesetBuilder transactionalComponentDataSourceChangeset]
      withInsertedSections:[NSIndexSet indexSetWithIndex:0]]
     build];
    [_dataSource applyChangeset:initial mode:CKUpdateModeSynchronous userInfo:nil];
    
    // Insert an initial batch of items so we actually render cells.
    NSArray<CellModel *> *firstBatch = [_cellDataLoader fetchNextWithCount:4];
    NSMutableDictionary<NSIndexPath *, CellModel *> *items = [NSMutableDictionary new];
    [firstBatch enumerateObjectsUsingBlock:^(CellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        items[[NSIndexPath indexPathForItem:idx inSection:0]] = obj;
    }];

    CKTransactionalComponentDataSourceChangeset *insertItems =
    [[[CKTransactionalComponentDataSourceChangesetBuilder transactionalComponentDataSourceChangeset]
      withInsertedItems:items]
     build];

    [_dataSource applyChangeset:insertItems mode:CKUpdateModeAsynchronous userInfo:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [_dataSource sizeForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
  [_dataSource announceWillDisplayCell:cell];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
  [_dataSource announceDidEndDisplayingCell:cell];
}

#pragma mark - Load helper
- (void) _updateDataSource
{
//    [self.dataSource c]
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(CellModel *)model
                           context:(CellContext *)context
{
  // A simple label row with full-width layout and dynamic height.
    return [WrapperComponent newWithCellModel:model];
}

@end

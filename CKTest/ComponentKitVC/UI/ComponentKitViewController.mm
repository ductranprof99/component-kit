//
//  ComponentKitViewController.mm
//  CKTest
//
//  Created by Duc Tran on 11/9/25.
//
#import <ComponentKit/ComponentKit.h>
#import "ComponentKitViewController.h"
#import "CellModel.h"

#import "WrapperComponent.h"
#import "CellContext.h"
#import "ComponentKitViewViewModel.h"


@interface ComponentKitViewController () <CKComponentProvider, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) ComponentKitViewViewModel *viewmodel;

- (void) loadNewDataFromVM:(NSArray<NSIndexPath *> *) indexPath;
- (void) changeDataFromVM:(NSIndexPath *) indexPath;
@end

@implementation ComponentKitViewController
{
    CKCollectionViewTransactionalDataSource *_dataSource;
    CKComponentFlexibleSizeRangeProvider *_sizeRangeProvider;
    
    BOOL isRendered;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.viewmodel = [ComponentKitViewViewModel sharedInstance];
        __weak ComponentKitViewController* weakSelf = self;
        self.viewmodel.onChange = ^(
            NSArray<NSIndexPath *> *reloaded,
            NSArray<NSIndexPath *> *inserted
        ) {
            if (reloaded.count != 0) {
                [weakSelf changeDataFromVM:reloaded.firstObject];
            } else if (inserted.count != 0) {
                [weakSelf loadNewDataFromVM:inserted];
            }

        };
        
        _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
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
    
    [self.viewmodel loadNextPage];
}

- (void)viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    
    
    if (isRendered) {
        return;
    }
    [self.collectionView setBackgroundColor:[UIColor blackColor]];
    isRendered = YES;
    const CKSizeRange sizeRange = [_sizeRangeProvider sizeRangeForBoundingSize:self.collectionView.bounds.size];
    NSSet *imageNames = [NSSet setWithObjects:
                         @"LosAngeles",
                         @"MarketStreet",
                         @"Drops",
                         @"Powell",
                         nil];
    CellContext *context = [[CellContext alloc] initWithImageNames:imageNames];
    CKTransactionalComponentDataSourceConfiguration *config =
    [[CKTransactionalComponentDataSourceConfiguration alloc]
     initWithComponentProvider:[self class]
     context:context
     sizeRange:sizeRange];
    
    _dataSource = [[CKCollectionViewTransactionalDataSource alloc]
                   initWithCollectionView:self.collectionView
                   supplementaryViewDataSource:nil
                   configuration:config];
    
    // Insert section 0.
    CKTransactionalComponentDataSourceChangeset *initial = [
        [
            [
                CKTransactionalComponentDataSourceChangesetBuilder
                transactionalComponentDataSourceChangeset
            ]
            withInsertedSections:[NSIndexSet indexSetWithIndex:0]
        ]
        build
    ];
    
    [
        _dataSource
        applyChangeset:initial
        mode:CKUpdateModeSynchronous
        userInfo:nil
    ];
    
  
}

- (void)changeDataFromVM:(NSIndexPath *)indexPath {
    if (!indexPath) return;
    
    CKTransactionalComponentDataSourceChangesetBuilder *b =
    [
        CKTransactionalComponentDataSourceChangesetBuilder
        transactionalComponentDataSourceChangeset
    ];
    
    NSMutableDictionary<NSIndexPath *, CellModel *> *reloaded = [NSMutableDictionary new];
    NSArray<CellModel *> *items = self.viewmodel.items;
    
    if (indexPath.section == 0 && indexPath.item < items.count) {
        reloaded[indexPath] = items[indexPath.item];
    }
    
    CKTransactionalComponentDataSourceChangeset *cs =[
        [
            b
            withUpdatedItems:reloaded
        ]
        build
    ];
    
    [
        _dataSource
        applyChangeset:cs
        mode:CKUpdateModeAsynchronous
        userInfo:nil
    ];
}

- (void)loadNewDataFromVM:(NSArray<NSIndexPath *> *)indexPaths {
    if (indexPaths.count == 0) return;

    CKTransactionalComponentDataSourceChangesetBuilder *b = [
        CKTransactionalComponentDataSourceChangesetBuilder
        transactionalComponentDataSourceChangeset
    ];

    // Map indexPath -> model hiện tại trong VM
    NSMutableDictionary<NSIndexPath *, CellModel *> *inserted = [NSMutableDictionary new];
    NSArray<CellModel *> *items = self.viewmodel.items;

    for (NSIndexPath *ip in indexPaths) {
        if (ip.section == 0 && ip.item < items.count) {
            inserted[ip] = items[ip.item];
        }
    }

    CKTransactionalComponentDataSourceChangeset *cs = [
        [
            b
            withInsertedItems:inserted
        ]
        build
    ];

    [
        _dataSource
        applyChangeset:cs
        mode:CKUpdateModeAsynchronous
        userInfo:nil
    ];
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

#pragma mark - Detect last load
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL isEnd =scrolledToBottomWithBuffer(
                   scrollView.contentOffset,
                   scrollView.contentSize,
                   scrollView.contentInset,
                   scrollView.bounds
                );

    if (isEnd) {
        [_viewmodel loadNextPage];
    }
}

static BOOL scrolledToBottomWithBuffer(
    CGPoint contentOffset,
    CGSize contentSize,
    UIEdgeInsets contentInset,
    CGRect bounds
) {
    CGFloat buffer = CGRectGetHeight(bounds) - contentInset.top - contentInset.bottom;
    const CGFloat maxVisibleY = (contentOffset.y + bounds.size.height);
    const CGFloat actualMaxY = (contentSize.height + contentInset.bottom);
    return ((maxVisibleY + buffer) >= actualMaxY);
}

@end

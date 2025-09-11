//
//  ComponentKitViewController.mm
//  CKTest
//
//  Created by Duc Tran on 11/9/25.
//

#import "ComponentKitViewController.h"
#import <UIKit/UIKit.h>
#import <ComponentKit/ComponentKit.h>
#import "Data/CellModel.h"
#import "Data/CellDataLoader.h"

@interface ComponentKitViewController () <CKComponentProvider, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) CKCollectionViewTransactionalDataSource *dataSource;
@property (nonatomic, strong) CKComponentFlexibleSizeRangeProvider *sizeRangeProvider;
@property (nonatomic, strong) CellDataLoader *cellDataLoader;
@end

@implementation ComponentKitViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
        _cellDataLoader = [[CellDataLoader alloc] init];
        // Demo data
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.delegate = self;
    
    const CKSizeRange sizeRange = [self.sizeRangeProvider sizeRangeForBoundingSize:self.collectionView.bounds.size];
    
    CKTransactionalComponentDataSourceConfiguration *config =
    [[CKTransactionalComponentDataSourceConfiguration alloc]
     initWithComponentProvider:[self class]
     context:nil
     sizeRange:sizeRange];
    
    self.dataSource = [[CKCollectionViewTransactionalDataSource alloc]
                       initWithCollectionView:self.collectionView
                       supplementaryViewDataSource:nil
                       configuration:config];
    
    // Insert section 0.
    CKTransactionalComponentDataSourceChangeset *initial =
    [[[CKTransactionalComponentDataSourceChangesetBuilder transactionalComponentDataSourceChangeset]
      withInsertedSections:[NSIndexSet indexSetWithIndex:0]]
     build];
    [self.dataSource applyChangeset:initial mode:CKUpdateModeSynchronous userInfo:nil];
    
    
    // Insert all items.
//    [self ]
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.dataSource sizeForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
  [self.dataSource announceWillDisplayCell:cell];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
  [self.dataSource announceDidEndDisplayingCell:cell];
}

#pragma mark - Load helper
- (void) _updateDataSource
{
//    [self.dataSource c]
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(NSString *)title context:(id)context
{
  // A simple label row with full-width layout and dynamic height.
  CKComponentSize size;
  size.width = CKRelativeDimension::Percent(1.0); // full width
  size.height = CKRelativeDimension::Auto();      // auto height

  CKLabelAttributes attrs = {};
  attrs.string = title;
  attrs.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
  attrs.color = [UIColor blackColor];
  attrs.alignment = NSTextAlignmentLeft;
  attrs.maximumLineHeight = 0;

  CKViewComponentAttributeValueMap viewAttrs = {
    { @selector(setBackgroundColor:), [UIColor colorWithWhite:0.97 alpha:1.0] },
    { @selector(setContentMode:), @(UIViewContentModeRedraw) }
  };

  CKComponent *insets = [CKInsetComponent
    newWithInsets:{ .top = 12, .left = 16, .bottom = 12, .right = 16 }
    component:[CKLabelComponent newWithLabelAttributes:attrs viewAttributes:viewAttrs size:size]];

  return insets;
}

@end

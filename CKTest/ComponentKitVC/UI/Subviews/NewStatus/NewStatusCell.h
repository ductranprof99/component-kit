//
//  ImageCell.h
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"
#import "NewStatusChipModel.h"
#import "NewStatusChipComponent.h"
#import "UIColor+Hex.h"
#import "AppImageDownloader.h"
#import <vector>
#import "CustomEditTextView.h"

@interface NewStatusCellState: NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;
@property (nonatomic, copy) NSArray<NSString *> *videoURLs;

- (instancetype)initEmptyValue;
@end


@interface NewStatusCell : CKCompositeComponent
+ (instancetype) newWithModel: (CellModel *) model;
- (void)didTapChip:(NewStatusChipModel *)chip;
- (void)onEndEditingText:(CustomEditTextView *)tv
          withText:(NSString *)tv2;
@end


@interface NewStatusCellController: CKComponentController
@end


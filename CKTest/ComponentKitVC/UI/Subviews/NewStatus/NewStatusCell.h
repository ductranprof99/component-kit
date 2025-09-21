//
//  ImageCell.h
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import <ComponentKit/ComponentKit.h>

@class CellModel;
@class NewStatusChipModel;
@class CustomTextView;

@interface NewStatusCellState: NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;
@property (nonatomic, copy) NSArray<NSString *> *videoURLs;

- (instancetype)initEmptyValue;
@end


@interface NewStatusCell : CKCompositeComponent
+ (instancetype) newWithModel: (CellModel *) model;
- (void)didTapChip:(NewStatusChipModel *)chip;
- (void)onEndEditingText:(CustomTextView *)tv
          withText:(NSString *)tv2;
@end


@interface NewStatusCellController: CKComponentController
@end


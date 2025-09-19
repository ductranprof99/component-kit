//
//  ImageCell.h
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import <ComponentKit/ComponentKit.h>
@class CellModel;
@class CellContext;
@interface ImageCell : CKCompositeComponent
+ (instancetype) newWithData: (CellModel *) model
                     context: (CellContext *) context;
@end

@interface ImageCellController: CKComponentController
@end

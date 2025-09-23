//
//  ListShortCell.h
//  CKTest
//
//  Created by Duc Tran  on 21/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import "CellModel.h"
#import "ListShortCellModel.h"
#import "ShortItemComponent.h"

@interface ListShortCell : CKCompositeComponent
+ (instancetype) newWithData: (CellModel *) model;
@end

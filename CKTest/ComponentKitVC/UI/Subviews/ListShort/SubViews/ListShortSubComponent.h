//
//  ListShortCell.h
//  CKTest
//
//  Created by ductd on 23/9/25.
//



#import <ComponentKit/ComponentKit.h>
#import "CellModel.h"
#import "ListShortCellModel.h"
#import "ShortItemComponent.h"

@interface ListShortSubComponent: CKCompositeComponent
+ (instancetype) newWithData: (CellModel *) model;
- (void) didTap: (ShortItemComponent *) sender
      withModel: (ListShortCellModel *) item;
@end

@interface ListShortSubComponentController : CKComponentController
@end

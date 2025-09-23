//
//  ShortItemComponent.h
//  CKTest
//
//  Created by ductd on 22/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import "ListShortCellShortItem.h"

/// Dumb “short” tile (thumbnail) component.
/// Model: URL string for the image.
@interface ShortItemComponent : CKCompositeComponent
+ (instancetype)newWithItem: (ListShortCellShortItem *) item
                     action: (const CKTypedComponentAction<ListShortCellShortItem *> &) action;
- (void) didTap;
@end


//
//  WrapperComponent.h
//  CKTest
//
//  Created by ductd on 12/9/25.
//

#import <ComponentKit/ComponentKit.h>

@class CellModel;

@interface WrapperComponent : CKCompositeComponent

+ (instancetype)newWithCellModel: (CellModel *) model;

@end

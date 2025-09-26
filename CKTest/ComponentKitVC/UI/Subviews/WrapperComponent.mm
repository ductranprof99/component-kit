//
//  WrapperComponent.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "WrapperComponent.h"
#import "CellModel.h"
#import <ComponentKit/CKComponent.h>
#import "CellModelType.h"
#import "NewStatusCell.h"
#import "ListShortCell.h"
#import "UserPostCell.h"
#import "RecommendVideoCell.h"

@implementation WrapperComponent
{
    
}

+ (instancetype)newWithCellModel: (CellModel *) model {
    CKComponent *body;
    
    switch (model.cellType) {
        case CellModelTypeNewStatus:
            body = [NewStatusCell newWithModel:model];
            break;
        case CellModelTypeShortList:
            body = [ListShortCell newWithModel:model];
            break;
        case CellModelTypeUserPost:
            body = [UserPostCell newWithModel:model];
            break;
        case CellModelTypeRecomendationVideo:
            body = [RecommendVideoCell newWithModel:model];
            break;
    }
    return [super newWithComponent:body];
}
@end

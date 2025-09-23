//
//  UserPostCell.m
//  CKTest
//
//  Created by ductd on 23/9/25.
//

#import "UserPostCell.h"

@implementation UserPostCell
+ (instancetype)newWithModel:(CellModel *)model
{
    //    if (model.cellType == )
    CKComponent *placeholder = [
        CKComponent
        newWithView: {
            [UIView class]
        }
        size:{}
    ];
    return [
        super
        newWithComponent:placeholder
    ];
}
@end


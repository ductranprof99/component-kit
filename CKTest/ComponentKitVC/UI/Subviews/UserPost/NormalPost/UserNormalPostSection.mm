//
//  UserNormalPostSection.m
//  CKTest
//
//  Created by ductd on 25/9/25.
//


#import "UserNormalPostSection.h"

@implementation UserNormalPostSection

+ (instancetype)newWithModel:(CellModel *)model {
    CKComponent *combined = [
        CKComponent
        newWithView: {
            [UIView class]
        }
        size:{
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Points(400),
        }
    ];
    return [super newWithComponent:combined];
}

@end

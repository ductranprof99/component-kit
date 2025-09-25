//
//  UserVideoPostSection.m
//  CKTest
//
//  Created by ductd on 25/9/25.
//

#import "UserVideoPostSection.h"

@implementation UserVideoPostSection

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

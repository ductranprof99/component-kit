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
    CKComponent *userSection = [
        CKStackLayoutComponent
        newWithView: { }
        size: {
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Points(20)
        }
        style: {
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = CGFloat(10),
        }
        children: {
            {
                
            }
        }
    ];
    
    if (model.userPostType == UserPostTypeNormal) {
        
    }
    
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


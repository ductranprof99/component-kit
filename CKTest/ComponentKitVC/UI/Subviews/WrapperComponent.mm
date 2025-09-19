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
#import "ImageCell.h"
#import "NewStatusCell.h"

@implementation WrapperComponent
{
    
}

+ (instancetype)newWithCellModel: (CellModel *) model {
    CKComponent *header = [CKComponent
                           newWithView:{
        [UIView class],
        {
            {@selector(setBackgroundColor:), [UIColor redColor]}
        }
    }
                           size:{
        .width = CKRelativeDimension::Percent(1),
        .height = CKRelativeDimension::Points(90),
    }];
    CKComponent *footer = [CKComponent
                           newWithView:{
        [UIView class],
        {
            {@selector(setBackgroundColor:), [UIColor blueColor]}
        }
    }
                           size:{
        .width = CKRelativeDimension::Percent(1),
        .height = CKRelativeDimension::Points(50),
    }];
    
    CKComponentViewConfiguration kWhiteBackgroundView = {
      [UIView class], {{@selector(setBackgroundColor:), [UIColor whiteColor]}}
    };
    
    CKComponent *body;
    
    switch (model.cellType) {
        case CellModelTypeNewStatus:
            body = [NewStatusCell newWithModel:model];
            break;
        case CellModelTypeUserPost:
            body = [CKStackLayoutComponent
                 newWithView: kWhiteBackgroundView
                 size:{}
                 style:{
                    .direction = CKStackLayoutDirectionVertical,
                }
                 children:{
                    {
                        header
                    },
                    {
                        [ImageCell newWithData:model
                                       context: nil]
                    },
                    {
                        footer
                    },
                }];
            
            break;
        default:
            CKComponent *backgroundComponent = [
                CKComponent newWithView: {
                    [UIView class],
                    {
                        { @selector(setBackgroundColor:), [UIColor lightGrayColor] },
                        { @selector(setClipsToBounds:), @(YES)}
                    }
                }
                size: {}
            ];
            CKLabelAttributes attr = {};
            attr.string = @"Test string";
            attr.font = [UIFont systemFontOfSize: 16 weight: UIFontWeightBold];
            attr.color = [UIColor blackColor];
            attr.alignment = NSTextAlignmentCenter;
            CKComponent *foreground = [
                CKLabelComponent
                newWithLabelAttributes: attr
                viewAttributes:{}
                size:{}
            ];
            
            body = [super newWithComponent:
                        [CKBackgroundLayoutComponent
                         newWithComponent: foreground
                         background: backgroundComponent]
            ];
            break;
    }
    return [super newWithComponent:body];
}
@end

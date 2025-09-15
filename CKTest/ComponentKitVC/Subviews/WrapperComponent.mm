//
//  WrapperComponent.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "WrapperComponent.h"
#import "CellModel.h"

@implementation WrapperComponent
{
    
}

+ (instancetype)newWithCellModel: (CellModel *) model {
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
    
    return [super newWithComponent:
         [CKBackgroundLayoutComponent
          newWithComponent: foreground
          background: backgroundComponent]
    ];
}
@end


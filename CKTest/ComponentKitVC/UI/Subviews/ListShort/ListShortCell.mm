//
//  ListShortCell.h
//  CKTest
//
//  Created by Duc Tran  on 21/9/25.
//

#import "ListShortCell.h"
#import <UIKit/UIKit.h>
#import "ListShortSubComponent.h"
#import "UIColor+Hex.h"


@implementation ListShortCell
+ (id)initialState {
    return [ListShortCellModel initWithItems: @[]];
}


+ (instancetype)newWithModel:(CellModel *)model {
    
    CKComponent *scrollView = [
        ListShortSubComponent
        newWithData:model
    ];
    
    CKComponent *padding = [
        CKInsetComponent
        newWithInsets:{
            .top = 20,
            .left = 10,
            .right = 10,
            .bottom = 20
        }
        component: [
            CKStackLayoutComponent
            newWithView:{}
            size:{}
            style:{
                .direction = CKStackLayoutDirectionVertical,
                .spacing = 10,
                .alignItems = CKStackLayoutAlignItemsCenter,
            }
            children: {
                {
                    [
                        CKLabelComponent
                        newWithLabelAttributes: {
                            .string = @"Khoảnh khắc",
                            .font = [UIFont systemFontOfSize:14 weight: UIFontWeightBold],
                            .color = [UIColor whiteColor],
                            .alignment = NSTextAlignmentLeft,
                        }
                        viewAttributes:{
                            {@selector(setBackgroundColor:), [UIColor clearColor] }
                        }
                        size:{
                            .width = CKRelativeDimension::Percent(1)
                        }
                    ]
                },
                {
                    scrollView
                }
            }
        ]
    ];
    
    CKComponent *background = [CKComponent
                               newWithView: {
        [UIView class],
        {
            {@selector(setBackgroundColor:), [UIColor colorWithHexString: @"#242728"]},
        }
    } size:{
        .width = CKRelativeDimension::Auto(),
        .height = CKRelativeDimension::Auto(),
    }];
    
    CKComponent *finalise = [
        CKBackgroundLayoutComponent
        newWithComponent: padding
        background: background
    ];
    
    return [super newWithComponent:finalise];
}

@end

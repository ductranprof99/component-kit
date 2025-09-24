//
//  CKComponent_Ext.m
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import "CKComponent_Ext.h"

@implementation CKComponent (Sizing)

- (instancetype) withPadding: (UIEdgeInsets) inset {
    CKComponent *cpn = [
        CKInsetComponent
        newWithInsets: inset
        component:self
    ];
    return cpn;
}


- (instancetype) withBackground: (CKComponent *) background {
    return [
        CKBackgroundLayoutComponent
        newWithComponent:self
        background:background
    ];
}

- (instancetype) withBackgroundColor: (UIColor *) backgroundColor {
    CKComponent *background = [CKComponent
                               newWithView: {
        [UIView class],
        {
            {@selector(setBackgroundColor:), backgroundColor},
        }
    } size:{
        .width = CKRelativeDimension::Auto(),
        .height = CKRelativeDimension::Auto(),
    }];
    
    return [
        CKBackgroundLayoutComponent
        newWithComponent:self
        background:background
    ];
}

- (instancetype)cornerRaidus:(CGFloat)radius {
    return [
        CKCompositeComponent
        newWithView: {
            [UIView class],
            {
                {@selector(setClipsToBounds:), @(YES)},
                {CKComponentViewAttribute::LayerAttribute(@selector(setCornerRadius:)), radius}
            }
        }
        component: self
    ];
}

//- (instancetype)overlayWithTapGesture

@end


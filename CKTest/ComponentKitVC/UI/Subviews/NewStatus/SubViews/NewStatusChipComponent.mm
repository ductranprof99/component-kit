//
//  NewStatusChipComponent.m
//  CKTest
//
//  Created by ductd on 19/9/25.
//


#import "NewStatusChipComponent.h"
#import "NewStatusChipModel.h"
#import "ImageCell.h"

@implementation NewStatusChipComponent
{
  CKTypedComponentAction<NewStatusChipModel *> _action; // store typed action
  NewStatusChipModel *_model;
}

+ (instancetype)newWithModel:(NewStatusChipModel *)model
                      action:(const CKTypedComponentAction<NewStatusChipModel *> &)action
{
    UIImage *img = [UIImage imageNamed:model.imageName ?: @""];
    CKComponent *image = img ? [
        CKImageComponent
        newWithImage:img
        attributes:{
            { @selector(setTintColor:), model.backgroundColor }
        }
        size:{.width = 16, .height = 16}] : nil;
    
    
    CKComponent *label =
    [CKLabelComponent newWithLabelAttributes:{
        .string = model.text ?: @"",
        .font   = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold],
        .color  = [UIColor blackColor],
        
    }
                              viewAttributes:{
        {@selector(setBackgroundColor:), [UIColor clearColor]},
    }
                                        size:{}];
    
    // Chip view; we forward the tap with the typed payload (model, index)
    
    CKComponent *row =
    [CKStackLayoutComponent newWithView: {}
                                   size: {}
                                  style: {
        .direction = CKStackLayoutDirectionHorizontal,
        .alignItems = CKStackLayoutAlignItemsCenter,
        .spacing = 6 }
                               children:{
        {image},
        {label},
    }];
//    
//    CKComponentViewConfiguration backgroundView = {
//        
//    };
    
    CKComponentViewConfiguration invisibleBackground = {
        [UIView class],
        {{@selector(setBackgroundColor:), [UIColor clearColor]}}
    };
    
    CKComponent *padded = [CKBackgroundLayoutComponent
                           newWithComponent:[CKInsetComponent
                                             newWithInsets:{.top=8,.left=12,.bottom=8,.right=12}
                                             component:row]
                           background: [CKComponent
                                        newWithView: {
        [UIView class],
        {
            {@selector(setBackgroundColor:), [UIColor blueColor]},
            {CKComponentViewAttribute::LayerAttribute(@selector(setCornerRadius:)), @(12.0)}
        }
    }
                                        size:{
        .width = CKRelativeDimension::Auto(),
        .height = CKRelativeDimension::Auto(),
    }]];
    
    
    
    CKComponent *overlay = [CKComponent
                            newWithView: {
        [UIView class],
        {CKComponentTapGestureAttribute(@selector(_handleTap:))}
    }
                            size:{
        .width = CKRelativeDimension::Auto(),
        .height = CKRelativeDimension::Auto(),
    }];
    
    CKComponent *totalCombine = [CKOverlayLayoutComponent
                                 newWithComponent:padded
                                 overlay: overlay
    ];
    
    auto component = [super newWithComponent:totalCombine];
    component->_action = action;
    component->_model  = model;
    return component;
}

- (void)_handleTap:(CKComponent *)sender {
    _action.send(self, _model);
}

@end

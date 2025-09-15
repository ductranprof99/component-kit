//
//  ImageCell.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "ImageCell.h"
#import <ComponentKit/CKImageComponent.h>
#import <UIKit/UIKit.h>
#import "CellModel.h"


@implementation ImageCell


+ (instancetype)newWithData:(CellModel *)model
                    context:(CellContext *)context {
    UIImage *img = model.randomImage;
    if (!img) {
        
    }
    CKComponent *imgView = [CKImageComponent
                            newWithImage: img
                            attributes: {
        {@selector(setContentMode:), @(UIViewContentModeScaleAspectFill)},
        {@selector(setClipsToBounds:), @(YES)}
    }
                            size: {
        .width = CKRelativeDimension::Percent(1),
        .height = CKRelativeDimension::Auto(),
        .maxHeight = 420
    }
    ];
    
    return [super newWithComponent:imgView];
}

@end


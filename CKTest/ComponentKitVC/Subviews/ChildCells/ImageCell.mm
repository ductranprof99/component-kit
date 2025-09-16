//
//  ImageCell.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "ImageCell.h"
#import <ComponentKit/CKNetworkImageComponent.h>
#import <ComponentKit/CKNetworkImageDownloading.h>
#import <ComponentKit/CKImageComponent.h>
#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"


@implementation ImageCell
+ (instancetype)newWithData:(CellModel *)model
                    context:(CellContext *)context {
    NSURL *url = [NSURL URLWithString:model.imageURL];
    CKComponent *imgViewAsync = [CKNetworkImageComponent
                    newWithURL: url
                    imageDownloader: [[AppImageDownloader alloc] init]
                    size: {
        .width = CKRelativeDimension::Percent(1),
        .height = CKRelativeDimension::Auto(),
        .minHeight = 100,
        .maxHeight = 420
    }
                    options: {
        
    }
                attributes: {
        {@selector(setContentMode:), @(UIViewContentModeScaleAspectFill)},
        {@selector(setClipsToBounds:), @(YES)}
    }
    ];
    return [super newWithComponent:imgViewAsync];
}

@end


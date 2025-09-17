//
//  ImageCell.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "ImageCell.h"
#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"

@interface ImageCellState: NSObject
@property (nonatomic, readonly) BOOL isExpand;

- (instancetype)initWithExpaned:(BOOL)expanded;
@end

@implementation ImageCellState

- (instancetype)initWithExpaned:(BOOL)expanded {
    _isExpand = expanded;
    return self;
}

@end


@implementation ImageCell
+ (id)initialState {
    return [[ImageCellState alloc] initWithExpaned: NO];
}

+ (instancetype)newWithData:(CellModel *)model
                    context:(CellContext *)context {
    NSURL *url = [NSURL URLWithString:model.imageURL];
    CKComponentScope scope(self);
    const ImageCellState *state = scope.state();
    
    CKComponent *imgViewAsync = [CKNetworkImageComponent
                                 newWithURL: url
                                 imageDownloader: [[AppImageDownloader alloc] init]
                                 size: {
        .width = CKRelativeDimension::Percent(1),
        .height = CKRelativeDimension::Auto(),
        .minHeight = state.isExpand ? 300 : 100,
        .maxHeight = 420
    }
                                 options: {
        
    }
                                 attributes: {
        {@selector(setContentMode:), @(UIViewContentModeScaleAspectFill)},
        {@selector(setClipsToBounds:), @(YES)},
        {@selector(setUserInteractionEnabled:), @(YES)},
    }
    ];
    
    
    CKComponent *overlay = [CKComponent
                            newWithView: {
        [UIView class],
        {CKComponentTapGestureAttribute(@selector(didTap:))}
    }
                            size:{
        .width = CKRelativeDimension::Auto(),
        .height = CKRelativeDimension::Auto(),
    }];
    
    CKComponent *totalCombine = [CKOverlayLayoutComponent newWithComponent:imgViewAsync
                 overlay: overlay
    ];
    return [super newWithComponent:totalCombine];
}

- (void)didTap:(UITapGestureRecognizer *)gr {
    NSLog(@"Test sumthing wong");
    [self updateState: ^(ImageCellState *old) {
        ImageCellState *o = old;
        return [[ImageCellState alloc] initWithExpaned: !o.isExpand];
    } mode: CKUpdateModeSynchronous];
}

@end


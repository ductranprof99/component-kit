//
//  ImageCell.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "RecommendVideoCell.h"

#pragma mark - State
@implementation RecommendVideoCellState

- (instancetype)initWithExpaned:(NSInteger)expanded {
    if ((self = [super init])) {
        _isExpand = expanded;
    }
    return self;
}

@end


#pragma mark - Controller
@implementation RecommendVideoCellController
- (void)didMount {
    [super didMount];
    // Setup after the component’s view is mounted
    NSLog(@"Hey hey hey");
}

- (void)didRemount {
    [super didRemount];
    NSLog(@"This mtfk did remount");
}

- (void)didUnmount {
    // Cleanup before the view goes away
    [super didUnmount];
}

@end


#pragma mark - View
@implementation RecommendVideoCell
+ (id)initialState {
    return [[RecommendVideoCellState alloc] initWithExpaned: 0];
}


+ (instancetype)newWithModel:(CellModel *)model {
    NSURL *url = [NSURL URLWithString:  @"https://picsum.photos/400/300?1"];
    CKComponentScope scope(self);
    const RecommendVideoCellState *state = scope.state();
    
    CKComponent *imgViewAsync = [CKNetworkImageComponent
                                 newWithURL: url
                                 imageDownloader: [[AppImageDownloader alloc] init]
                                 size: {
        .width = CKRelativeDimension::Percent(1),
        .height = CKRelativeDimension::Auto(),
        .minHeight = state.isExpand  == 0 ? 100 : state.isExpand  == 1 ? 200 : 300,
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
    [
        self
        updateState: ^(RecommendVideoCellState *old) {
            RecommendVideoCellState *o = old;
            return [
                [RecommendVideoCellState alloc]
                initWithExpaned: !o.isExpand
            ];
        }
        mode: CKUpdateModeSynchronous
    ];
}

@end

//
//  ListShortCell.h
//  CKTest
//
//  Created by Duc Tran  on 21/9/25.
//

#import "ListShortCell.h"
#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"

@implementation ListShortCellState

- (instancetype)initWithExpaned:(NSInteger)expanded {
    if ((self = [super init])) {
        _isExpand = expanded;
    }
    return self;
}

@end


@implementation ListShortCell
+ (id)initialState {
    return [[ListShortCellState alloc] initWithExpaned: 0];
}


+ (instancetype)newWithData:(CellModel *)model
                    context:(CellContext *)context {
    NSURL *url = [NSURL URLWithString:  @"https://picsum.photos/400/300?1"];
    CKComponentScope scope(self);
    const ListShortCellState *state = scope.state();
    
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
    [self updateState: ^(ListShortCellState *old) {
        ListShortCellState *o = old;
        return [[ListShortCellState alloc] initWithExpaned: !o.isExpand];
    } mode: CKUpdateModeSynchronous];
}

@end

@implementation ListShortCellController
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

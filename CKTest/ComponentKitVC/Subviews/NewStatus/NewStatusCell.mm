//
//  ImageCell.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//

#import "NewStatusCell.h"
#import <UIKit/UIKit.h>
#import "CellModel.h"
#import "AppImageDownloader.h"

@implementation NewStatusCellState

- (instancetype)initEmptyValue {
    self = [super init];
    if (self) {
        _text = @"";
        _imageURLs = @[];
        _videoURLs = @[];
    }
    return self;
}

@end

@implementation NewStatusComponentController

- (instancetype)initWithComponent:(NewStatusCell *)component {
    self = [super initWithComponent:component];
    if (self) {
        // Wire things later if needed (gestures, timers, observers)
    }
    return self;
}

- (void)didMount {
    [super didMount];
    // Setup after the component’s view is mounted
}

- (void)didUnmount {
    // Cleanup before the view goes away
    [super didUnmount];
}

@end


@implementation NewStatusCell
+ (id)initialState {
    return [[NewStatusCellState alloc] initEmptyValue];
}

+ (Class)controllerClass {
    return [NewStatusComponentController class];
}


+ (instancetype)newWithModel:(CellModel *)model {
    
    
    CKComponentViewConfiguration invisibleBackground = {
        [UIView class],
        {{@selector(setBackgroundColor:), [UIColor clearColor]}}
    };
    
    CKComponentViewConfiguration backgroundView = {
        [UIView class],
        {{@selector(setBackgroundColor:), [UIColor whiteColor]}}
    };
                              
    CKComponent *topStack = [
        CKStackLayoutComponent
            newWithView: invisibleBackground
                   size:{
                    .width = CKRelativeDimension::Percent(1),
                    .height = CKRelativeDimension::Auto(),
            }
                  style: {
                      .direction = CKStackLayoutDirectionHorizontal,
                      .alignItems = CKStackLayoutAlignItemsStart,
                      .spacing = CGFloat(20)
            }
               children:{
                   {
                      
                   }
            }
    ];
    
    CKComponent *bottomStack = [
        CKComponent
            newWithView: invisibleBackground
            size:{}
    ];
    
    CKComponent *full = [CKStackLayoutComponent
     newWithView: backgroundView
     size:{
        .width = CKRelativeDimension::Percent(1),
        .height = CKRelativeDimension::Points(150),
    }
     style:{
        .direction = CKStackLayoutDirectionVertical,
    }
     children:{
        {
            topStack
        },
        {
            bottomStack
        }
    }];
    return [super newWithComponent:full];
}


- (void)didTap:(UITapGestureRecognizer *)gr {
    
    
}


@end


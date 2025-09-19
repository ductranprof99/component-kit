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
#import "NewStatusChipModel.h"
#import "NewStatusChipComponentScopeAction.h"

@interface NewStatusCellState ()
@property (nonatomic, strong) NSArray<NewStatusChipModel *> *chips;
@end

@implementation NewStatusCellState

- (instancetype)initEmptyValue {
    self = [super init];
    if (self) {
        _text = @"";
        _imageURLs = @[];
        _videoURLs = @[];
        _chips = @[];
    }
    return self;
}

@end

@implementation NewStatusCell
+ (id)initialState {
    return [[NewStatusCellState alloc] initEmptyValue];
}

+ (instancetype)newWithModel:(CellModel *)model {
    CKComponentScope scope(self);
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

    // Sample chip models (replace with real data when wiring with model/state)
    NewStatusChipModel *c1 = [[NewStatusChipModel alloc] initWithImage:@"photo" text:@"Ảnh" backgroundColor:[UIColor colorWithRed:0.93 green:0.96 blue:1.0 alpha:1.0]];
    NewStatusChipModel *c2 = [[NewStatusChipModel alloc] initWithImage:@"video" text:@"Video" backgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]];
    NewStatusChipModel *c3 = [[NewStatusChipModel alloc] initWithImage:@"paperclip" text:@"File" backgroundColor:[UIColor colorWithRed:0.96 green:0.94 blue:1.0 alpha:1.0]];

    CKComponent *scopeActionChip = [NewStatusChipComponentScopeAction
                                    newWithModel:c1
                                    action: {scope, @selector(scopeActionMethod:)}];
//    CKComponent *chip2 = [NewStatusChipComponent newWithModel:c2 onTap:onChipTap];
//    CKComponent *chip3 = [NewStatusChipComponent newWithModel:c3 onTap:onChipTap];
    
    CKComponent *bottomStack = [
        CKStackLayoutComponent
        newWithView: invisibleBackground
        size:{
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Points(50),
        }
        style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .alignItems = CKStackLayoutAlignItemsCenter,
            .spacing = CGFloat(8),
            .justifyContent = CKStackLayoutJustifyContentStart
        }
        children:{
            {scopeActionChip},
//            {chip2},
//            {chip3},
        }
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

- (void)scopeActionMethod:(NewStatusChipModel *)chip {
    NSLog(@"Yes i do, hentai 2");
}

@end


@implementation NewStatusCellController
- (void)didMount {
    [super didMount];
    // Setup after the component’s view is mounted
    NSLog(@"Hey hey hey");
}

- (void)didUnmount {
    // Cleanup before the view goes away
    [super didUnmount];
}

- (void)didTapChip:(NewStatusChipModel *)chip {
    if (![chip isKindOfClass:[NewStatusChipModel class]]) { return; }
    NSLog(@"Chip tapped: %@", chip.text);
    // TODO: forward event to delegate or post notification as needed
}

@end

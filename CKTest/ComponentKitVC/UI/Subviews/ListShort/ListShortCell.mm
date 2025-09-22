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
#import "CustomScrollView.h"
#import "ShortItemComponent.h"

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


+ (instancetype)newWithData:(CellModel *)model {
    CKComponentScope scope(self);
    const ListShortCellState *state = scope.state();
    
    // Build "short" items from model.listShortURL (array of NSString*)
    NSArray<NSString *> *shorts = [model.listShortURL isKindOfClass:[NSArray class]] ? model.listShortURL : @[];
    
    std::vector<CKStackLayoutComponentChild> children;
    children.reserve(shorts.count);
    for (NSString *s in shorts) {
        CKComponent *item = [ShortItemComponent newWithURLString:s];
        children.push_back({ .component = item });
    }
    
    // Horizontal row of shorts
    CKComponent *row = [
        CKStackLayoutComponent
        newWithView:{}
        size:{}
        style:{
            .direction = CKStackLayoutDirectionHorizontal,
            .spacing = 1,
            .alignItems = CKStackLayoutAlignItemsCenter,
        }
        children:children];
    
    // Wrap in a horizontal CustomScrollView (SwiftUI List-equivalent)
    CKComponent *scrollable = [
        CustomScrollView
        newWithSize:{
            .width = CKRelativeDimension::Percent(1),
            .height = CKRelativeDimension::Auto(),
            .minHeight = 160,
            .maxHeight = 260
        }
        axis:CSVScrollAxisHorizontal
        contentInsets:UIEdgeInsetsMake(0, 12, 0, 12)
        showsVerticalScrollIndicator:NO
        showsHorizontalScrollIndicator:NO
        bounces:YES
        content:row
        onScroll:{}
    ];
    
    return [super newWithComponent:scrollable];
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

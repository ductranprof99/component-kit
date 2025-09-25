//
//  ComponentKitViewViewModel.h
//  CKTest
//
//  Created by ductd on 25/9/25.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface ComponentKitViewViewModel : NSObject
@property (atomic, copy, readonly) NSArray<CellModel *> *items;
+ (instancetype)sharedInstance;
- (void)didTapLike:(id) sender
           isLiked:(BOOL) liked;
- (void)didTapComment:(id) sender;

- (void)toggleLikeAtIndexPath:(NSIndexPath *)indexPath;
- (void)loadNextPage;
@property (nonatomic, copy) void (^onChange)(NSArray<NSIndexPath *> *reloaded, NSArray<NSIndexPath *> *inserted);
@end

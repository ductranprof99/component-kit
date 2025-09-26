//
//  ComponentKitViewViewModel.m
//  CKTest
//
//  Created by ductd on 25/9/25.
//

#import "ComponentKitViewViewModel.h"

@implementation ComponentKitViewViewModel {
    NSMutableArray<CellModel *> *_mutable;
    dispatch_queue_t _vmQueue;
    CellDataLoader *_cellDataLoader;
}

+ (instancetype)sharedInstance {
    static id s; static dispatch_once_t once; dispatch_once(&once, ^{ s = [self new]; });
    return s;
}

- (instancetype)init {
    if ((self = [super init])) {
        _vmQueue = dispatch_queue_create("vm.queue", DISPATCH_QUEUE_SERIAL);
        _mutable = [NSMutableArray array];
        _cellDataLoader = [[CellDataLoader alloc] init];
    }
    return self;
}


- (NSArray<CellModel *> *)items { return _mutable.copy; }


- (void)toggleLikeAtIndexPath:(NSIndexPath *)ip {
    dispatch_async(_vmQueue, ^{
        if (ip.section != 0 || ip.item >= _mutable.count) {
            return;
        }
        
        CellModel *old = _mutable[ip.item];
        _mutable[ip.item] = [old newModelWithToggleLike];
        if (self.onChange) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.onChange(@[ip], @[]);
            });
        }
    });
}

- (void)loadNextPage {
    const int pageCount = 4;
    dispatch_async(_vmQueue, ^{
        NSArray<CellModel *> *batch = [_cellDataLoader fetchNextWithCount:pageCount];
        NSInteger start = _mutable.count;
        [_mutable addObjectsFromArray:batch];
        NSMutableArray<NSIndexPath *> *inserted = [NSMutableArray new];
        for (NSUInteger i = 0; i < batch.count; i++) {
            [inserted addObject:[NSIndexPath indexPathForItem:(start + i) inSection:0]];
        }
        
        dispatch_async(
            dispatch_get_main_queue(),
            ^{
                if (self.onChange) {
                    self.onChange(@[], inserted);
                }
            }
        );
    });
}

- (void)didTapComment: (id)sender
            withModel: (CellModel *)cellmodel {
    NSLog(@"Hahahhahahahahahaha");
}

- (void)didTapLike:(id)sender
         withModel: (CellModel *)cellmodel
           isLiked:(BOOL)liked {
    dispatch_async(_vmQueue, ^{
        NSUInteger idx = NSNotFound;
        for (NSUInteger i = 0; i < _mutable.count; i++) {
            CellModel *m = _mutable[i];
            if ([m.uuidString isEqualToString:cellmodel.uuidString]) {
                idx = i;
                break;
            }
        }
        if (idx == NSNotFound) {
            return;
        }
        
        NSIndexPath *idxP = [NSIndexPath indexPathForItem:idx inSection:0];
        
        [self toggleLikeAtIndexPath:idxP];
    });
}

@end

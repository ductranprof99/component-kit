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
}

+ (instancetype)sharedInstance {
    static id s; static dispatch_once_t once; dispatch_once(&once, ^{ s = [self new]; });
    return s;
}

- (instancetype)init {
    if ((self = [super init])) {
        _vmQueue = dispatch_queue_create("vm.queue", DISPATCH_QUEUE_SERIAL);
        _mutable = [NSMutableArray array];
    }
    return self;
}


- (NSArray<CellModel *> *)items { return _mutable.copy; }

- (void)toggleLikeAtIndexPath:(NSIndexPath *)ip {
    dispatch_async(_vmQueue, ^{
        if (ip.item >= _mutable.count) return;
        CellModel *m = _mutable[ip.item];
        m.isLiked = !m.isLiked;
        void (^emit)(void) = ^{ if (self.onChange) self.onChange(@[ip], @[]); };
        dispatch_async(dispatch_get_main_queue(), emit);
    });
}

- (void)loadNextPage {
//    dispatch_async(_vmQueue, ^{
//        // fetch/append; collect new indexPaths
//        NSMutableArray<NSIndexPath *> *inserted = [NSMutableArray array];
//        NSInteger start = _mutable.count;
//        NSArray<CellModel *> *batch = /* your loader */ cellListData(); // or next page
//        for (NSUInteger i = 0; i < batch.count; i++) { [_mutable addObject:batch[i]];
//            [inserted addObject:[NSIndexPath indexPathForItem:(start + i) inSection:0]];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{ if (self.onChange) self.onChange(@[], inserted); });
//    });
}

- (void)didTapComment: (id)sender
            withModel: (CellModel *)cellmodel {
    NSLog(@"Hahahhahahahahahaha");
}

- (void)didTapLike:(id)sender
         withModel: (CellModel *)cellmodel
           isLiked:(BOOL)liked {
    
    NSLog(@"Hahahhahahahahahaha");
    
}

@end

//
//  CellDataLoader.m
//  CKTest
//
//  Created by ductd on 11/9/25.
//

#import "CellDataLoader.h"
#import "CellModel.h"

extern NSArray *cellListData(void);

#pragma mark - Cell data loader

@implementation CellDataLoader {
    NSInteger _cursor;
    NSInteger _lastCursor;
    NSArray<NSDictionary *> *_raw;
}

-(instancetype) init
{
    if (self = [super init]) {
        
        _raw = cellListData();
        _cursor = 0;
        _lastCursor = 0;
    }
    return self;
}

- (NSArray<CellModel *> *)fetchNextWithCount: (NSInteger) count {
    // Import the declaration for cellListData()
    NSAssert(count >= 1, @"Not count  < 0");
    if ( _cursor >= (NSInteger)_raw.count ) {
        return @[];
    }
    NSInteger remaining = (NSInteger) _raw.count - _cursor;
    NSInteger take = MIN(MAX(count, 1), remaining);
    
    NSArray *slice = [_raw subarrayWithRange:NSMakeRange(_cursor, take)];
    _lastCursor = _cursor;
    _cursor += take;
    NSMutableArray<CellModel *> *result = [NSMutableArray arrayWithCapacity:slice.count];
    extern CellModel *CellModelFromDict(NSDictionary * dict);
    for (NSDictionary *dict in slice) {
        [result addObject:CellModelFromDict(dict)];
    }
    return result.copy;
    
}

-(void)reset {
    _cursor = 0;
    _lastCursor = 0;
}


- (NSInteger)getLastCursor {
    return _lastCursor;
}

@end


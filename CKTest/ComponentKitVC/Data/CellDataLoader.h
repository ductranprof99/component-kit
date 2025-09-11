//
//  CellDataLoader.h
//  CKTest
//
//  Created by ductd on 11/9/25.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"

@interface CellDataLoader : NSObject
- (NSArray<CellModel *> *) fetchNextWithCount: (NSInteger) count;
- (NSInteger) getLastCursor;
@end



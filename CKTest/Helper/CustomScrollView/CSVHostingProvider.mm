//
//  CSVHostingProvider.m
//  CKTest
//
//  Created by ductd on 22/9/25.
//


#import "CustomScrollView.h"

@implementation CSVHostingProvider
+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context
{
    if ([model isKindOfClass:[CKComponent class]]) {
        return (CKComponent *)model;
    }
    // Fallback to an empty stack to avoid returning nil.
    return [CKStackLayoutComponent newWithView:{} size:{} style:{} children:{}];
}
@end

//
//  QuoteContext.m
//  CKTest
//
//  Created by ductd on 15/9/25.
//


#import "CellContext.h"

@implementation CellContext
{
    NSSet *_images;
}

- (instancetype)initWithImageNames:(NSSet *)imageNames
{
  if (self = [super init]) {
       _images = imageNames;
  }
  return self;
}

@end

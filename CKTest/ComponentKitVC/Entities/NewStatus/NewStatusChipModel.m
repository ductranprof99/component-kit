//
//  ChipModel.m
//  CKTest
//
//  Created by ductd on 19/9/25.
//

#import "NewStatusChipModel.h"


@implementation NewStatusChipModel
- (instancetype)initWithImage:(NSString *)imageName
                         text:(NSString *)text
              foregroundColor:(UIColor *)foregroundColor {
  if (self = [super init]) {
    _imageName = [imageName copy];
    _text = [text copy];
    _foregroundColor = foregroundColor ?: [UIColor colorWithWhite:0.95 alpha:1.0];
  }
  return self;
}
@end

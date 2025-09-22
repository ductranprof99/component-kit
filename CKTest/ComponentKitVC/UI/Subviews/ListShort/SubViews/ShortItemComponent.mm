//
//  ShortItemComponent.m
//  CKTest
//
//  Created by ductd on 22/9/25.
//


//
//  ShortItemComponent.mm
//  CKTest
//

#import "ShortItemComponent.h"
#import <UIKit/UIKit.h>
#import "AppImageDownloader.h"

@implementation ShortItemComponent

+ (instancetype)newWithURLString:(NSString *)urlString
{
  NSURL *url = (urlString.length > 0) ? [NSURL URLWithString:urlString] : nil;

  // A simple thumbnail; tune the size to your design
  CKComponent *image = [CKNetworkImageComponent
    newWithURL:url
    imageDownloader:[[AppImageDownloader alloc] init]
    size:{
      .width  = CKRelativeDimension::Points(120),
      .height = CKRelativeDimension::Points(180),
      .maxHeight = 220
    }
    options:{}
    attributes:{
      {@selector(setContentMode:), @(UIViewContentModeScaleAspectFill)},
      {@selector(setClipsToBounds:), @(YES)},
      {@selector(setUserInteractionEnabled:), @(YES)},
    }];

  // Simple padding on the trailing edge to space items out
  CKComponent *padded = [CKInsetComponent newWithInsets:{.top=0,.left=0,.bottom=0,.right=12}
                                              component:image];

  return [super newWithComponent:padded];
}

@end
//
//  CustomNetworkImageView.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import <ComponentKit/ComponentKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppImageDownloader.h"


typedef NS_ENUM(NSInteger, CustomImageMaskType) {
    CustomImageMaskTypeNone,
    CustomImageMaskTypeCircle,
    CustomImageMaskTypeEllipse,
    CustomImageMaskTypeRounded
};

@interface CustomNetworkImageView : CKCompositeComponent

+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute;

+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                   maskType:(CustomImageMaskType)maskType;

+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                   cropRect: (CGRect) cropRect
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                   maskType:(CustomImageMaskType)maskType
                     radius:(CGFloat)cornerRadius;

+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                   maskType:(CustomImageMaskType)maskType
                     radius:(CGFloat)cornerRadius;

+ (CKViewComponentAttributeValueMap)createViewAttributeWithMaskType:(CustomImageMaskType)maskType
                                                         attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                                                       cornerRadius: (CGFloat)cornerRadius;
@end

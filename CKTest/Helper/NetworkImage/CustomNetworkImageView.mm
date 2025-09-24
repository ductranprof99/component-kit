//
//  CustomNetworkImageView.m
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import "CustomNetworkImageView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation CustomNetworkImageView
+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute {
    NSURL *url = [NSURL URLWithString:urlString];
    
    CKComponent *img =[
        CKNetworkImageComponent
        newWithURL:url
        imageDownloader:[[AppImageDownloader alloc] init]
        size:size
        options: {
            .defaultImage = placeholderImage,
        }
        attributes: viewAttribute
    ];
    return [
        super newWithComponent:img
    ];
}


+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                   maskType:(CustomImageMaskType)maskType {
    return [
        self
        newWithURL:urlString
        placeholder:placeholderImage
        size:size
        attributes:viewAttribute
        maskType:maskType
        radius:0
    ];
}


+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                   maskType:(CustomImageMaskType)maskType
                     radius:(CGFloat)cornerRadius {
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    CKViewComponentAttributeValueMap maskedAttrs = [
        self
        createViewAttributeWithMaskType: maskType
        attributes:viewAttribute
        cornerRadius:cornerRadius
    ];
    
    CKComponent *img =[
        CKNetworkImageComponent
        newWithURL:url
        imageDownloader:[[AppImageDownloader alloc] init]
        size:size
        options: {
            .defaultImage = placeholderImage,
        }
        attributes: maskedAttrs
    ];
    return [
        super newWithComponent:img
    ];
}


+ (instancetype) newWithURL: (NSString *) urlString
                placeholder: (UIImage *) placeholderImage
                   cropRect: (CGRect) cropRect
                       size:(const CKComponentSize &)size
                 attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                   maskType:(CustomImageMaskType)maskType
                     radius:(CGFloat)cornerRadius {
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    CKViewComponentAttributeValueMap maskedAttrs = [
        self
        createViewAttributeWithMaskType: maskType
        attributes:viewAttribute cornerRadius:cornerRadius
    ];
    
    CKComponent *img =[
        CKNetworkImageComponent
        newWithURL:url
        imageDownloader:[[AppImageDownloader alloc] init]
        size:size
        options: {
            .defaultImage = placeholderImage,
            .cropRect = cropRect
        }
        attributes: maskedAttrs
    ];
    return [
        super newWithComponent:img
    ];
}

+ (CKViewComponentAttributeValueMap)createViewAttributeWithMaskType:(CustomImageMaskType)maskType
                                                         attributes:(const CKViewComponentAttributeValueMap &)viewAttribute
                                                       cornerRadius: (CGFloat)cornerRadius{
    CKViewComponentAttributeValueMap maskedAttrs = viewAttribute;
    switch (maskType) {
        case CustomImageMaskTypeCircle: {
            const CKComponentViewAttribute kCircleMask("custom.circleMask", ^(UIView *view, id value){
                view.layer.masksToBounds = YES;
                CGFloat r = MIN(view.bounds.size.width, view.bounds.size.height) * 0.5f;
                view.layer.cornerRadius = r;
                view.layer.mask = nil; // ensure we don't keep a shape mask from reuse
            });
            maskedAttrs.insert({kCircleMask, (id)kCFBooleanTrue});
            break;
        }
        case CustomImageMaskTypeEllipse: {
            const CKComponentViewAttribute kEllipseMask("custom.ellipseMask", ^(UIView *view, id value){
                view.clipsToBounds = YES;
                CAShapeLayer *mask = [CAShapeLayer layer];
                mask.path = [UIBezierPath bezierPathWithOvalInRect:view.bounds].CGPath;
                view.layer.mask = mask;
            });
            maskedAttrs.insert({kEllipseMask, (id)kCFBooleanTrue});
            break;
        }
        case CustomImageMaskTypeRounded: {
            const CKComponentViewAttribute kRoundedMask("custom.roundedMask.variable", ^(UIView *view, id value){
                view.layer.masksToBounds = YES;
                view.layer.cornerRadius = cornerRadius;
                view.layer.mask = nil; // if the view was previously ellipse-masked, clear it
            });
            maskedAttrs.insert({kRoundedMask, (id)kCFBooleanTrue});
            break;
        }
        case CustomImageMaskTypeNone:
        default:
            break;
    }
    return maskedAttrs;
}

@end

//
//  ExpandableLabelContentView.h
//  CKTest
//
//  Created by ductd on 24/9/25.
//

#import "ExpandableLabel.h"
#import <CoreText/CoreText.h>

#pragma mark - ExpandableLabelContentView
@interface ExpandableLabelContentView()

@property(copy, nonatomic)NSAttributedString *attributedText;

@end

@implementation ExpandableLabelContentView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (!_attributedText) {
        return;
    }
    [self drawText];
}

#pragma mark - Setters Method
-(void)setAttributedText:(NSAttributedString *)attributedText{
    _attributedText = attributedText;
    
    [self setNeedsDisplay];
}

-(void)drawText{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
    
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, _attributedText.length), CGPathCreateWithRect(self.bounds, nil), NULL);
    
    CTFrameDraw(ctFrame, context);
}

@end


#pragma mark - ExpandableLabel

typedef void(^AttributedTextDrawCompletion)(CGFloat height, NSAttributedString *drawAttributedText);



@implementation ExpandableLabel
{
    CGFloat _lineHeightErrorDimension; //误差值
}

#pragma mark - Initial Method
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        [self initData];
        
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initData];
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.backgroundColor = [UIColor clearColor];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGestureTapped:)]];
}

-(void)initData{
    _lineHeightErrorDimension = 0.5;
    _maximumLines = 3;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(actionNotificationReceived:) name:UIDeviceOrientationDidChangeNotification object:nil];
}


#pragma mark - Lifecycle Method

- (CGSize)sizeThatFits:(CGSize)size
{
    if (!_attributedText) { return CGSizeMake(size.width, 0); }
    CGFloat targetWidth = size.width > 0 ? size.width : UIScreen.mainScreen.bounds.size.width;

    __block CGFloat h = 0;
    __block NSAttributedString *drawAttr = nil;

    [self drawTextForWidth:targetWidth completion:^(CGFloat height, NSAttributedString *drawAttributedText) {
        h = height;
        drawAttr = drawAttributedText;
    }];

    self.measuredHeight = h;
    self.lastMeasuredWidth = targetWidth;
    self.lastDrawAttributedText = drawAttr;
    if (self.action) { self.action(ExpandableLabelActionDidCalculate, @(h)); }

    return CGSizeMake(targetWidth, h);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_attributedText) { return; }

    // Re-measure if the width changed
    if (fabs(self.bounds.size.width - self.lastMeasuredWidth) > 0.5) {
        (void)[self sizeThatFits:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    }

    if (!self.contentView.superview) {
        [self addSubview:self.contentView];
    }
    self.contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.measuredHeight);
    self.contentView.attributedText = self.lastDrawAttributedText;
}

-(void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - Setters Method
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setMaximumLines:(NSUInteger)maximumLines
{
    _maximumLines = maximumLines;
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setIsExpanded:(BOOL)isExpanded
{
    _isExpanded = isExpanded;
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (CGSize)intrinsicContentSize
{
    CGFloat w = self.bounds.size.width > 0 ? self.bounds.size.width : UIScreen.mainScreen.bounds.size.width;
    return [self sizeThatFits:CGSizeMake(w, CGFLOAT_MAX)];
}

#pragma mark - Public Method


#pragma mark - Action Method
-(void)actionNotificationReceived: (NSNotification*)sender{
    if ([sender.name isEqualToString:UIDeviceOrientationDidChangeNotification]) {
        self.isExpanded = _isExpanded;
    }
}

-(void)actionGestureTapped: (UITapGestureRecognizer*)sender{
    if (CGRectContainsPoint(_clickArea, [sender locationInView:self])) {
        self.isExpanded = !_isExpanded;
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
//        _action ? _action(ExpandableLabelActionClick, nil) : nil;
    }
}

#pragma mark - Private Method

- (void)drawTextForWidth:(CGFloat)width completion:(AttributedTextDrawCompletion)completion
{
    if (_isExpanded) {
        [self calculateFullTextForWidth:width completion:completion];
    } else {
        [self calculatePartialTextForWidth:width completion:completion];
    }
}

- (void)drawTextWithCompletion:(AttributedTextDrawCompletion)completion
{
    [self drawTextForWidth:self.bounds.size.width completion:completion];
}

-(void)calculateFullTextForWidth:(CGFloat)width completion:(AttributedTextDrawCompletion)completion
{
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, width, UIScreen.mainScreen.bounds.size.height), nil);
    
    NSMutableAttributedString *drawAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:_attributedText];
    [drawAttributedText appendAttributedString:self.clickAttributedText];
    
    // CTFrameRef
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)drawAttributedText);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, drawAttributedText.length), path, NULL);
    
    // CTLines
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    
    CGFloat totalHeight = 0;
    
    for (int i=0; i<lines.count; i++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        totalHeight += [self heightForCTLine:line];
        
        if (i == lines.count - 1) {
            CTLineRef moreLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.clickAttributedText);
            
            NSArray *runs = (NSArray*)CTLineGetGlyphRuns(line);
            CGFloat w = 0;
            for (int i=0; i<runs.count; i++) {
                if (i == runs.count - 1) {
                    break;
                }
                CTRunRef run = (__bridge CTRunRef)runs[i];
                w += CTRunGetTypographicBounds(run, CFRangeMake(0, 0), NULL, NULL, NULL);
            }
            
            CGSize moreSize = CTLineGetBoundsWithOptions(moreLine, 0).size;
            CGFloat h = moreSize.height + lines.count * _lineHeightErrorDimension;
            self.clickArea = CGRectMake(w, totalHeight - h, moreSize.width, h);
            
            if (moreLine) CFRelease(moreLine);
        }
    }
    
    completion(totalHeight, drawAttributedText);
    
    if (ctFrame) CFRelease(ctFrame);
    if (setter) CFRelease(setter);
    if (path) CFRelease(path);
}

-(void)calculatePartialTextForWidth:(CGFloat)width completion:(AttributedTextDrawCompletion)completion
{
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, width, UIScreen.mainScreen.bounds.size.height), nil);
    
    // CTFrameRef
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, _attributedText.length), path, NULL);
    
    // CTLines
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    
    // CTLine Origins
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    CGFloat totalHeight = 0;
    
    NSMutableAttributedString *drawAttributedText = [NSMutableAttributedString new];
    
    for (int i=0; i<lines.count; i++) {
        if (lines.count > _maximumLines && i == _maximumLines) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        
        CGPoint lineOrigin = origins[i];
        
        CFRange range = CTLineGetStringRange(line);
        NSAttributedString *subAttr = [_attributedText attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        if (lines.count > _maximumLines && i == _maximumLines - 1) {
            NSMutableAttributedString *drawAttr = [[NSMutableAttributedString alloc] initWithAttributedString:subAttr];
            
            for (int j=0; j<drawAttr.length; j++) {
                NSMutableAttributedString *lastLineAttr = [[NSMutableAttributedString alloc] initWithAttributedString:[drawAttr attributedSubstringFromRange:NSMakeRange(0, drawAttr.length-j)]];
                
                [lastLineAttr appendAttributedString:self.clickAttributedText];
                
                NSInteger number = [self numberOfLinesForAttributtedText:lastLineAttr withOriginPoint:lineOrigin];
                
                if (number == 1) {
                    [drawAttributedText appendAttributedString:lastLineAttr];
                    
                    CTLineRef moreLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.clickAttributedText);
                    CGSize moreSize = CTLineGetBoundsWithOptions(moreLine, 0).size;
                    
                    self.clickArea = CGRectMake(self.bounds.size.width-moreSize.width, totalHeight, moreSize.width, moreSize.height);
                    
                    totalHeight += [self heightForCTLine:line];
                    
                    if (moreLine) CFRelease(moreLine);
                    break;
                }
            }
        }
        else{
            [drawAttributedText appendAttributedString:subAttr];
            
            totalHeight += [self heightForCTLine:line];
        }
    }
    
    completion(totalHeight, drawAttributedText);
    
    if (ctFrame) CFRelease(ctFrame);
    if (setter) CFRelease(setter);
    if (path) CFRelease(path);
}

-(CGFloat)heightForCTLine: (CTLineRef)line{
    CGFloat h = 0;
    
    NSArray *runs = (NSArray*)CTLineGetGlyphRuns(line);
    for (int i=0; i<runs.count; i++) {
        CTRunRef run = (__bridge CTRunRef)runs[i];
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
        h = MAX(h, ascent + descent + leading);
    }
    return h + _lineHeightErrorDimension;
}

-(NSInteger)numberOfLinesForAttributtedText: (NSAttributedString*)text
                            withOriginPoint: (CGPoint)origin{
    CGFloat width = self.lastMeasuredWidth > 0 ? self.lastMeasuredWidth : UIScreen.mainScreen.bounds.size.width;
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, width, UIScreen.mainScreen.bounds.size.height), nil);
    
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)text);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(setter, CFRangeMake(0, text.length), path, nil);
    NSArray *lines = (NSArray*)CTFrameGetLines(ctFrame);
    NSInteger count = lines.count;
    
    if (ctFrame) CFRelease(ctFrame);
    if (setter) CFRelease(setter);
    if (path) CFRelease(path);
    
    return count;
}


#pragma mark - Getters Method
-(NSAttributedString *)clickAttributedText{
    return _isExpanded
    ? [[NSAttributedString alloc] initWithString:@"thu gọn" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor orangeColor]}]
    : [[NSAttributedString alloc] initWithString:@"...xem thêm" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor orangeColor]}];
}

-(ExpandableLabelContentView *)contentView{
    if (!_contentView) {
        ExpandableLabelContentView *v = [ExpandableLabelContentView new];
        v.backgroundColor = [UIColor clearColor];
        
        _contentView = v;
    }
    return _contentView;
}
@end

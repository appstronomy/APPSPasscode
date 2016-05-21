//
//  APPSNumericKeypadView.m
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import "APPSNumericKeypadView.h"

static const CGFloat kNumericKeypadTitleVerticalSpacing    =  2.0;
static const CGFloat kNumericKeypadTitleVerticalSpacingAlt = 10.0;
static const CGFloat kNumericKeypadSubtitleVerticalSpacing = -2.0;

static const CGFloat kNumericKeypadTitleFontSize           = 28.0;
static const CGFloat kNumericKeypadSubtitleFontSize        = 12.0;

static const CGFloat kNumericKeypadTitleTextHeight         = 34.0;
static const CGFloat kNumericKeypadSubtitleTextHeight      = 15.0;


@interface APPSNumericKeypadView ()

/**
 The key that is currently highlighted.  The finger is down on this key.
 */
@property (assign, nonatomic) APPSNumericKeypadKey activeKey;

/**
 Redeclare this property as readwrite.
 */
@property (readwrite, nonatomic) APPSNumericKeypadKey lastKey;

@end

@implementation APPSNumericKeypadView


+ (CGFloat)hairlineThickness
{
    static CGFloat hairlineThickness;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Protect against dividing by 0.
        // NativeScale returns 0 when used in an IB_DESIGNABLE view, scale does not.
        CGFloat scale = ([UIScreen mainScreen].nativeScale > 0) ? [UIScreen mainScreen].nativeScale : [UIScreen mainScreen].scale;
        hairlineThickness = 1.0 / scale;
    });
    
    return hairlineThickness;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setup];
}

/**
 Appropriate default values.
 */
- (void)setup
{
    self.activeKey = APPSNumericKeypadKeyInvalid;
    self.lastKey   = APPSNumericKeypadKeyInvalid;
    self.buttonSpacing = CGSizeMake([APPSNumericKeypadView hairlineThickness], [APPSNumericKeypadView hairlineThickness]);
}



#pragma mark - Properties

- (void)setLastKey:(APPSNumericKeypadKey)lastKey
{
    _lastKey = lastKey;

    if (lastKey != APPSNumericKeypadKeyInvalid) {
        [self.delegate numericKeypadView:self
                               didTapKey:lastKey];
    }

    [self setNeedsDisplay];
}

- (void)setActiveKey:(APPSNumericKeypadKey)activeKey
{
    _activeKey = activeKey;

    [self setNeedsDisplay];
}

- (UIImage *)deleteKeyImage
{
    if (_deleteKeyImage) {
        return _deleteKeyImage;
    }
    
    return [UIImage imageNamed:@"Icon-KeypadDelete-normal"
                      inBundle:[NSBundle bundleForClass:self.class]
 compatibleWithTraitCollection:nil];
}



#pragma mark - Titles

- (UIImage *)iconForKey:(APPSNumericKeypadKey)key
{
    if (key != APPSNumericKeypadKeyDelete) {
        return nil;
    }

    return self.deleteKeyImage;
}

- (NSString *)titleForKey:(APPSNumericKeypadKey)key
{
    static NSArray         *titleLookup;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        titleLookup = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"", @""];
    });

    if (key != APPSNumericKeypadKeyInvalid) {
        return titleLookup[key];
    }

    return nil;
}

- (NSString *)subtitleForKey:(APPSNumericKeypadKey)key
{
    static NSArray         *subtitleLookup;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        subtitleLookup = @[@"", @"", @"ABC", @"DEF", @"GHI", @"JKL", @"MNO", @"PQRS", @"TUV", @"WXYZ", @"", @""];
    });

    if (key != APPSNumericKeypadKeyInvalid) {
        return subtitleLookup[key];
    }

    return nil;
}



#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    [self drawBackdrop:currentContext];
    [self drawButtonBackgrounds:currentContext];
    [self drawButtonTitles:currentContext];
}

- (void)drawBackdrop:(CGContextRef)context
{
    CGContextSaveGState(context);

    [[self backdropColor] setFill];

    CGContextFillRect(context, self.bounds);

    CGContextRestoreGState(context);
}

// TODO: It appears that in the system keypad, the invalid key in the lower
//       left is drawn slightly different.  I am not sure if it is worth the
//       effort to make this match exactly, but just pointing it out.
- (void)drawButtonBackgrounds:(CGContextRef)context
{
    CGContextSaveGState(context);

    for (APPSNumericKeypadKey key = APPSNumericKeypadKeyZero; key <= APPSNumericKeypadKeyDelete; key++) {
        CGRect   buttonFrame = [self buttonFrameForKey:key];
        UIColor *fillColor   = (key == self.activeKey) ? [self highlightColorForKey:key] : [self defaultColorForKey:key];

        [fillColor setFill];

        CGContextFillRect(context, buttonFrame);
    }

    CGContextRestoreGState(context);
}

- (void)drawButtonTitles:(CGContextRef)context
{
    CGContextSaveGState(context);

    for (APPSNumericKeypadKey key = APPSNumericKeypadKeyZero; key <= APPSNumericKeypadKeyDelete; key++) {
        UIImage *icon = [self iconForKey:key];

        if (icon) {
            [icon drawInRect:[self iconFrameForKey:key]];
        }
        else {
            NSString  *title    = [self titleForKey:key];
            NSString  *subtitle = [self subtitleForKey:key];

            [title drawInRect:[self titleFrameForKey:key]
               withAttributes:[self textAttributesForTitle]];

            [subtitle drawInRect:[self subtitleFrameForKey:key]
                  withAttributes:[self textAttributesForSubtitle]];
        }
    }
    
    CGContextRestoreGState(context);
}



#pragma mark - Conveniences

#pragma mark Text

- (NSDictionary *)textAttributesForTitle
{
    return [self textAttributesWithFont:[UIFont fontWithName:@"HelveticaNeue" size:kNumericKeypadTitleFontSize]];
}

- (NSDictionary *)textAttributesForSubtitle
{
    return [self textAttributesWithFont:[UIFont fontWithName:@"HelveticaNeue" size:kNumericKeypadSubtitleFontSize]];
}

- (NSDictionary *)textAttributesWithFont:(UIFont *)font
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.alignment     = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;

    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];

    attributes[NSForegroundColorAttributeName] = [self textColor];
    attributes[NSFontAttributeName]            = font;
    attributes[NSParagraphStyleAttributeName]  = paragraphStyle;

    return [attributes copy];
}


#pragma mark Colors

- (UIColor *)defaultColorForNumericKey
{
    if (_defaultColorForNumericKey) {
        return _defaultColorForNumericKey;
    }
    
    return [UIColor colorWithRed:252.0/255.0
                           green:252.0/255.0
                            blue:252.0/255.0
                           alpha:1.0];
}

- (UIColor *)highlightColorForNumericKey
{
    if (_highlightColorForNumericKey) {
        return _highlightColorForNumericKey;
    }
    
    return [UIColor colorWithRed:187.0/255.0
                           green:189.0/255.0
                            blue:192.0/255.0
                           alpha:1.0];
}

- (UIColor *)backdropColor
{
    if (_backdropColor) {
        return _backdropColor;
    }
    
    return [UIColor colorWithRed:182.0/255.0
                           green:182.0/255.0
                            blue:185.0/255.0
                           alpha:1.0];
}

- (UIColor *)textColor
{
    if (_textColor) {
        return _textColor;
    }
    
    return [UIColor blackColor];
}

- (UIColor *)defaultColorForKey:(APPSNumericKeypadKey)key
{
    UIColor *color = self.customKeyColors[@(key)] ?: [self chooseColorForKey:key
                                                            fromNumericColor:[self defaultColorForNumericKey]
                                                                 deleteColor:[self backdropColor]
                                                                  extraColor:[self highlightColorForNumericKey]];
    return color;
}

- (UIColor *)highlightColorForKey:(APPSNumericKeypadKey)key
{
    return [self chooseColorForKey:key
                  fromNumericColor:[self highlightColorForNumericKey]
                       deleteColor:[self defaultColorForNumericKey]
                        extraColor:[self highlightColorForNumericKey]];
}

- (UIColor *)chooseColorForKey:(APPSNumericKeypadKey)key
              fromNumericColor:(UIColor *)numericColor
                   deleteColor:(UIColor *)deleteColor
                  extraColor:(UIColor *)extraColor
{
    UIColor *color = extraColor;

    if ([[self class] isKeyNumeric:key]) {
        color = numericColor;
    }
    else if (key == APPSNumericKeypadKeyDelete) {
        color = deleteColor;
    }

    return color;
}



#pragma mark - Geometry/Layout

- (NSInteger)columnForKey:(APPSNumericKeypadKey)key
{
    NSInteger column;
    
    switch (key) {
        case APPSNumericKeypadKeyInvalid:
            column = -1;
            break;
            
        case APPSNumericKeypadKeyExtra:
            column = 0;
            break;
            
        case APPSNumericKeypadKeyZero:
            column = 1;
            break;
            
        case APPSNumericKeypadKeyDelete:
            column = 2;
            break;
            
        default:
            column = (key - 1) % 3;
            break;
    }

    return column;
}

- (NSInteger)rowForKey:(APPSNumericKeypadKey)key
{
    NSInteger row;
    
    switch (key) {
        case APPSNumericKeypadKeyInvalid:
            row = -1;
            break;
        
        case APPSNumericKeypadKeyExtra:
        case APPSNumericKeypadKeyZero:
        case APPSNumericKeypadKeyDelete:
            row = 3;
            break;
            
        default:
            row = (key - 1) / 3;
            break;
    }
    
    return row;
}


#pragma mark Dimensions

/**
 These dimensions are based on the dimensions in the system keypad.
 */
- (CGFloat)widthForColumn:(NSUInteger)column
{
    // These are the expected dimensions
    if (CGRectGetWidth(self.bounds) == 320.0) {
        return (column % 2) == 1 ? 110.0 : (105.0 - self.buttonSpacing.width);
    }

    // If not the expected dimensions, at least try to scale.  We are just
    // providing this so that if a larger screen iPhone comes out, this will not break
    return (CGRectGetWidth(self.bounds) - (2 * self.buttonSpacing.width)) / 3;
}

/**
 These dimensions are based on the dimensions in the system keypad.
 */
- (CGFloat)heightForRow:(NSUInteger)row
{
    // These are the expected dimensions
    if (CGRectGetHeight(self.bounds) == 216.0) {
        return (row == 0) ? 54.0 : (54.0 - self.buttonSpacing.height);
    }

    // If not the expected dimensions, at least try to scale.  We are just
    // providing this so that if a larger screen iPhone comes out, this will not break
    return (CGRectGetHeight(self.bounds) - (3 * self.buttonSpacing.height)) / 4;
}


#pragma mark Frames

- (CGRect)buttonFrameForKey:(APPSNumericKeypadKey)key
{
    if (key == APPSNumericKeypadKeyInvalid) {
        return CGRectZero;
    }

    CGRect    frame  = CGRectZero;
    NSInteger column = [self columnForKey:key];
    NSInteger row    = [self rowForKey:key];

    frame.size.width  = [self widthForColumn:column];
    frame.size.height = [self heightForRow:row];

    for (int i = 0; i < column; i++) {
        frame.origin.x += [self widthForColumn:i];
        frame.origin.x += self.buttonSpacing.width;
    }

    for (int i = 0; i < row; i++) {
        frame.origin.y += [self heightForRow:i];
        frame.origin.y += self.buttonSpacing.height;
    }

    return frame;
}

- (CGRect)iconFrameForKey:(APPSNumericKeypadKey)key
{
    UIImage *icon = [self iconForKey:key];

    if (!icon) {
        return CGRectZero;
    }

    CGRect buttonFrame = [self buttonFrameForKey:key];
    CGRect iconFrame   = CGRectZero;

    iconFrame.size     = icon.size;
    iconFrame.origin.x = CGRectGetMidX(buttonFrame) - (CGRectGetWidth(iconFrame)  / 2);
    iconFrame.origin.y = CGRectGetMidY(buttonFrame) - (CGRectGetHeight(iconFrame) / 2);

    return iconFrame;
}

- (CGRect)titleFrameForKey:(APPSNumericKeypadKey)key
{
    CGRect  frame           = [self buttonFrameForKey:key];
    CGFloat verticalSpacing = kNumericKeypadTitleVerticalSpacing;

    if (key == APPSNumericKeypadKeyZero || key == APPSNumericKeypadKeyDelete) {
        verticalSpacing = kNumericKeypadTitleVerticalSpacingAlt;
    }

    frame.origin.y    += verticalSpacing;
    frame.size.height  = kNumericKeypadTitleTextHeight;

    return frame;
}

- (CGRect)subtitleFrameForKey:(APPSNumericKeypadKey)key
{
    CGRect frame = [self titleFrameForKey:key];

    frame.origin.y    += CGRectGetHeight(frame) + kNumericKeypadSubtitleVerticalSpacing;
    frame.size.height  = kNumericKeypadSubtitleTextHeight;

    return frame;
}

/**
 Given a point in the view's coordinate system, what is the key at
 that location.
 */
- (APPSNumericKeypadKey)keyForPoint:(CGPoint)point
{
    for (APPSNumericKeypadKey key = APPSNumericKeypadKeyZero; key <= APPSNumericKeypadKeyDelete; key++) {
        
        // Ignore tapping Extra key
        if (key == APPSNumericKeypadKeyExtra) {
            continue;
        }
        
        CGRect currentFrame = [self buttonFrameForKey:key];

        if (CGRectContainsPoint(currentFrame, point)) {
            return key;
        }
    }

    return APPSNumericKeypadKeyInvalid;
}



#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tapPoint = [[touches anyObject] locationInView:self];

    self.activeKey = [self keyForPoint:tapPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tapPoint = [[touches anyObject] locationInView:self];

    self.activeKey = [self keyForPoint:tapPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint tapPoint = [[touches anyObject] locationInView:self];

    // Actually register that the key was tapped
    self.lastKey   = [self keyForPoint:tapPoint];
    self.activeKey = APPSNumericKeypadKeyInvalid;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.lastKey   = APPSNumericKeypadKeyInvalid;
    self.activeKey = APPSNumericKeypadKeyInvalid;
}



#pragma mark - Helpers

+ (BOOL)isKeyNumeric:(APPSNumericKeypadKey)key
{
    return (key >= APPSNumericKeypadKeyZero && key <= APPSNumericKeypadKeyNine);
}


@end

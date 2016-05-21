//
//  APPSSecurePlaceholderView.m
//  APPSPasscode
//
//  Created by Chris Morris on 7/22/14.
//  Copyright (c) 2014 Appstronomy. All rights reserved.
//

#import "APPSSecurePlaceholderView.h"

static const CGFloat kSecurePlaceholderHyphenWidth = 3.0;

@implementation APPSSecurePlaceholderView


#pragma mark - Properties

- (void)setOccupied:(BOOL)occupied
{
    _occupied = occupied;

    [self setNeedsDisplay];
}

- (UIColor *)foregroundColor
{
    if (_foregroundColor) {
        return _foregroundColor;
    }
    
    return [UIColor blackColor];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    if (self.isOccupied) {
        [self drawBullet:currentContext];
    }
    else {
        [self drawHyphen:currentContext];
    }
}

- (void)drawBullet:(CGContextRef)context
{
    CGContextSaveGState(context);

    [[self foregroundColor] setFill];

    CGContextFillEllipseInRect(context, self.bounds);

    CGContextRestoreGState(context);
}

- (void)drawHyphen:(CGContextRef)context
{
    CGContextSaveGState(context);

    [[self foregroundColor] setStroke];

    UIBezierPath *path = [[UIBezierPath alloc] init];

    [path moveToPoint:CGPointMake(0, CGRectGetMidY(self.bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMidY(self.bounds))];

    path.lineWidth = kSecurePlaceholderHyphenWidth;
    
    [path stroke];

    CGContextRestoreGState(context);
}

@end

//
//  GraphView.m
//  My Weight
//
//  Created by Александр Карцев on 9/17/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import "GraphView.h"
#import "MainTableViewController.h"
@implementation GraphView

static int AVERAGE_NUMBER_OF_DAYS_IN_MONTH_FROM_ZERO = 30;

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    
    //adding gradient
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.8];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    
    UIColor *tempColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    CGContextSetStrokeColorWithColor(context,tempColor.CGColor);
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.bounds byRoundingCorners: UIRectCornerAllCorners cornerRadii: (CGSize){20.0, 10.}].CGPath;
    
    self.layer.mask = maskLayer;

    
    UIColor * whiteColor = [UIColor colorWithRed:0.0 green:128.0 blue:0.0 alpha:0.25];
    UIColor * lightGrayColor = [UIColor colorWithRed:255.0 green:0.0 blue:0.0 alpha:0.25];

    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, whiteColor.CGColor, lightGrayColor.CGColor);
    
    CGContextSetLineWidth(context, 2.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSNumber *y = [NSNumber numberWithDouble:rect.size.height/130];
    NSNumber *x = [NSNumber numberWithDouble:(rect.size.width-70)/30];
    CGFloat xRate = [x floatValue];
    CGFloat yRate = [y floatValue];
    CGFloat yLine = 20*yRate;
    
    //horizontal lines
    for (int i=0; i<10; i++) {
        CGContextMoveToPoint(context, 20, rect.size.height-(yLine));
        CGContextAddLineToPoint(context, rect.size.width-20, rect.size.height-(yLine));
        yLine=yLine+(10*yRate);
    }
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    UIColor *tempColor1 = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    CGContextSetStrokeColorWithColor(context,tempColor1.CGColor);
    CGContextSetLineWidth(context, 3.0);
    int firstIndex = 0;
    
    //finding the first element
    for (int i=AVERAGE_NUMBER_OF_DAYS_IN_MONTH_FROM_ZERO; i>=0; i--) {
        if (![[self.arrayOfPoints objectAtIndex:i] isEqualToNumber:@-1]) {
            firstIndex = i;
            break;
        }
    }
    
    CGFloat xNow = 30;
    
    //drawing graph
    for (int i=AVERAGE_NUMBER_OF_DAYS_IN_MONTH_FROM_ZERO; i>=0; i--) {
        
        if ([[self.arrayOfPoints objectAtIndex:i] isEqualToNumber:@-1]) {
            xNow=xNow+xRate;
        }
        else if (i==firstIndex)
            {
                CGContextMoveToPoint(context, xNow, rect.size.height-([[self.arrayOfPoints objectAtIndex:i] floatValue]*yRate));
                xNow=xNow+xRate;
            }
                else
                {
                    CGFloat temp1 = ([[self.arrayOfPoints objectAtIndex:i] floatValue]*yRate);
                    CGFloat temp = rect.size.height-temp1;
                    CGContextAddLineToPoint(context, xNow+xRate, temp);
                    xNow=xNow+xRate;
                }

    }
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
}

@end

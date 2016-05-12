//
//  LXDProgressLayer.m
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import "LXDProgressLayer.h"
#import <UIKit/UIKit.h>

typedef enum MovePoint
{
    MovePoint_B,
    MovePoint_D
} MovePoint;

#define outsideRectSize 90

@interface LXDProgressLayer ()

@property (nonatomic, assign) CGRect outsideRect;
@property (nonatomic, assign) CGFloat lastProgress;
@property (nonatomic, assign) MovePoint movePoint;

@end

@implementation LXDProgressLayer

- (instancetype)init
{
    if (self = [super init]) {
        self.lastProgress = 0.5f;
    }
    return self;
}

- (instancetype)initWithLayer: (LXDProgressLayer *)layer
{
    if (self = [super initWithLayer: layer]) {
        self.movePoint = layer.movePoint;
        self.outsideRect = layer.outsideRect;
        self.lastProgress = layer.lastProgress;
    }
    return self;
}

- (void)setProgress: (CGFloat)progress
{
    _progress = MIN(1.f, MAX(0.f, progress));
    _movePoint = _progress <= 0.5f ? MovePoint_D : MovePoint_B;
    
    CGFloat x = self.position.x - outsideRectSize * 0.5f + (_progress - 0.5f) * (CGRectGetWidth(self.frame) - outsideRectSize);
    CGFloat y = self.position.y - outsideRectSize * 0.5f;
    self.outsideRect = CGRectMake(x, y, outsideRectSize, outsideRectSize);
    
    [self setNeedsDisplay];
}

- (void)drawInContext: (CGContextRef)ctx
{
    NSLog(@"draw");
    CGFloat offset = _outsideRect.size.width / 3.6;
    CGFloat moveDistance = (_outsideRect.size.width * 1 / 6) * fabs(_progress - 0.5f) * 2;
    
    CGPoint rectCenter = CGPointMake(CGRectGetMidX(_outsideRect), CGRectGetMidY(_outsideRect));
    CGPoint A = CGPointMake(rectCenter.x, _outsideRect.origin.y + moveDistance);
    CGPoint B = CGPointMake(_movePoint == MovePoint_B ? CGRectGetMaxX(_outsideRect) + 2 * moveDistance : CGRectGetMaxX(_outsideRect), rectCenter.y);
    CGPoint C = CGPointMake(rectCenter.x, CGRectGetMaxY(_outsideRect) - moveDistance);
    CGPoint D = CGPointMake(_movePoint == MovePoint_D ? CGRectGetMinX(_outsideRect) - 2 * moveDistance : CGRectGetMinX(_outsideRect), rectCenter.y);
    
    CGPoint AB1 = CGPointMake(A.x + offset, A.y);
    CGPoint AB2 = CGPointMake(B.x, _movePoint == MovePoint_B ? B.y - offset + moveDistance : B.y - offset);
    CGPoint BC1 = CGPointMake(B.x, _movePoint == MovePoint_B ? B.y + offset - moveDistance : B.y + offset);
    CGPoint BC2 = CGPointMake(C.x + offset, C.y);
    CGPoint CD1 = CGPointMake(C.x - offset, C.y);
    CGPoint CD2 = CGPointMake(D.x, _movePoint == MovePoint_D ? D.y + offset - moveDistance : D.y + offset);
    CGPoint DA1 = CGPointMake(D.x, _movePoint == MovePoint_D ? D.y - offset + moveDistance : D.y - offset);
    CGPoint DA2 = CGPointMake(A.x - offset, A.y);
    
    CGMutablePathRef ovalPath = CGPathCreateMutable();
    CGPathMoveToPoint(ovalPath, NULL, A.x, A.y);
    CGPathAddCurveToPoint(ovalPath, NULL, AB1.x, AB1.y, AB2.x, AB2.y, B.x, B.y);
    CGPathAddCurveToPoint(ovalPath, NULL, BC1.x, BC1.y, BC2.x, BC2.y, C.x, C.y);
    CGPathAddCurveToPoint(ovalPath, NULL, CD1.x, CD1.y, CD2.x, CD2.y, D.x, D.y);
    CGPathAddCurveToPoint(ovalPath, NULL, DA1.x, DA1.y, DA2.x, DA2.y, A.x, A.y);
    CGPathCloseSubpath(ovalPath);
    
    CGContextAddPath(ctx, ovalPath);
    CGContextSetStrokeColorWithColor(ctx, _strokeColor);
    CGContextSetFillColorWithColor(ctx, _fillColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGPathRef rectPath = CGPathCreateWithRect(self.outsideRect, NULL);
    CGContextAddPath(ctx, rectPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGFloat lengths[2] = {5.f, 5.f};
    CGContextSetLineDash(ctx, 0.0, lengths, 2);
    CGContextStrokePath(ctx);
    
    CGPathRelease(ovalPath);
    CGPathRelease(rectPath);
}


@end

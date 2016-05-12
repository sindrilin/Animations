//
//  LXDProgressLayer.m
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2515年 sindri lin. All rights reserved.
//

#import "LXDProgressLayer.h"
#import <UIKit/UIKit.h>

#define MAX_LENGTH (CGRectGetWidth([UIScreen mainScreen].bounds) - 50)

@interface LXDProgressLayer ()

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGRect textRect;
@property (nonatomic, assign) CGFloat maxOffset;

@end

@implementation LXDProgressLayer

- (instancetype)init
{
    if (self = [super init]) {
        self.origin = CGPointMake(25.f, 76.f);
        self.strokeEnd = 1.f;
        self.progress = 0.f;
        self.maxOffset = 25.f;
        self.textRect = CGRectMake(5, _origin.y - 30, 40, 20);
    }
    return self;
}

- (void)dealloc
{
    CGColorRelease(_strokeColor);
}

- (instancetype)initWithLayer: (LXDProgressLayer *)layer
{
    if (self = [super initWithLayer: layer]) {
        self.strokeEnd = 1.f;
    }
    return self;
}

- (void)setProgress: (CGFloat)progress
{
    _progress = MIN(1.f, MAX(0.f, progress));
    [self setNeedsDisplay];
}

- (void)setStrokeColor: (CGColorRef)strokeColor
{
    CGColorRelease(_strokeColor);
    _strokeColor = strokeColor;
    CGColorRetain(_strokeColor);        //必须进行这一步持有，否则对象将释放
    [self setNeedsDisplay];
}

- (void)drawInContext: (CGContextRef)ctx
{
    CGFloat offsetX = _origin.x + MAX_LENGTH * _progress;
    CGFloat offsetY = _origin.y + _maxOffset * (1 - fabs(_progress - 0.5f) * 2);
    CGFloat contactX = 25.f + MAX_LENGTH * _strokeEnd;
    CGFloat contactY = _origin.y + _maxOffset * (1 - fabs(_strokeEnd - 0.5f) * 2);
    
    CGRect textRect = CGRectOffset(_textRect, MAX_LENGTH * _progress, _maxOffset * (1 - fabs(_progress - 0.5f) * 2));
    if (_report) {
        _report((NSUInteger)(_progress * 100), textRect, _strokeColor);
    }
    
    CGMutablePathRef linePath = CGPathCreateMutable();

    //绘制背景线条
    if (_strokeEnd > _progress) {
        CGFloat scale =  _progress == 0 ?: (1 - (_strokeEnd - _progress) / (1 - _progress));
        contactY = _origin.y + (offsetY - _origin.y) * scale;
        CGPathMoveToPoint(linePath, NULL, contactX, contactY);
    } else {
        CGFloat scale = _progress == 0 ?: _strokeEnd / _progress;
        contactY = (offsetY - _origin.y) * scale + _origin.y;
        CGPathMoveToPoint(linePath, NULL, contactX, contactY);
        CGPathAddLineToPoint(linePath, NULL, offsetX, offsetY);
    }
    CGPathAddLineToPoint(linePath, NULL, _origin.x + MAX_LENGTH, _origin.y);
    [self setPath: linePath onContext: ctx color: [UIColor colorWithRed: 204/255.f green: 204/255.f blue: 204/255.f alpha: 1.f].CGColor];
    
    CGPathRelease(linePath);
    linePath = CGPathCreateMutable();
    
    //绘制进度线条
    if (_progress != 0.f) {
        NSLog(@"%f, progress", _progress);
        CGPathMoveToPoint(linePath, NULL, _origin.x, _origin.y);
        if (_strokeEnd > _progress) { CGPathAddLineToPoint(linePath, NULL, offsetX, offsetY); }
            CGPathAddLineToPoint(linePath, NULL, contactX, contactY);
    } else {
        if (_strokeEnd != 1.f && _strokeEnd != 0.f) {
            NSLog(@"%f, end", _progress);
            CGPathMoveToPoint(linePath, NULL, _origin.x, _origin.y);
            CGPathAddLineToPoint(linePath, NULL, contactX, contactY);
        }
    }
    [self setPath: linePath onContext: ctx color: [UIColor colorWithRed: 66/255.f green: 1.f blue: 66/255.f alpha: 1.f].CGColor];
    CGPathRelease(linePath);
}

- (void)setPath: (CGPathRef)path onContext: (CGContextRef)ctx color: (CGColorRef)color
{
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, 5.f);
    CGContextSetStrokeColorWithColor(ctx, color);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextStrokePath(ctx);
}


@end

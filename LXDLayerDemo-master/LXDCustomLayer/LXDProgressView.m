//
//  LXDProgressView.m
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import "LXDProgressView.h"

@interface LXDProgressView ()

@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) LXDProgressLayer * progressLayer;

@property (nonatomic, strong) CAShapeLayer * background;
@property (nonatomic, strong) CAShapeLayer * top;

@end


@implementation LXDProgressView

- (instancetype)initWithFrame: (CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        
        self.progressLayer = [LXDProgressLayer layer];
        self.progressLayer.strokeColor = [UIColor colorWithRed: 66/255.f green: 1.f blue: 66/255.f alpha: 1.f].CGColor;
        self.progressLayer.frame = self.bounds;
        __weak UILabel * weakLbl = self.progressLabel;
        self.progressLayer.report = ^(NSUInteger progress, CGRect textRect, CGColorRef textColor) {
            NSString * progressStr = [NSString stringWithFormat: @"%lu%%", progress];
            weakLbl.text = progressStr;
            weakLbl.frame = textRect;
            weakLbl.textColor = [UIColor colorWithCGColor: textColor];
        };
        self.progressLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer: self.progressLayer];
        [self addSubview: self.progressLabel];
        
        [self.layer addSublayer: self.background];
        [self.layer addSublayer: self.top];
    }
    return self;
}

- (void)setProgress: (CGFloat)progress
{
    _progress = progress;
    self.progressLayer.strokeEnd = progress;
    self.progressLayer.progress = progress;
    [self updatePath];
}


#pragma mark - getter
- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _progressLabel.font = [UIFont systemFontOfSize: 13.f];
        
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}

- (CAShapeLayer *)background
{
    if (!_background) {
        _background = [CAShapeLayer layer];
        _background.fillColor = [UIColor clearColor].CGColor;
        _background.strokeColor = [UIColor colorWithRed: 204/255.f green: 204/255.f blue: 204/255.f alpha: 1.f].CGColor;
        _background.lineWidth = 5.f;
        _background.lineJoin = kCALineJoinRound;
        _background.lineCap = kCALineCapRound;
    }
    return _background;
}

- (CAShapeLayer *)top
{
    if (!_top) {
        _top = [CAShapeLayer layer];
        _top.fillColor = [UIColor clearColor].CGColor;
        _top.strokeColor = [UIColor colorWithRed: 66/255.f green: 1.f blue: 66/255.f alpha: 1.f].CGColor;
        _top.lineCap = kCALineCapRound;
        _top.lineJoin = kCALineJoinRound;
        _top.lineWidth = 5.f;
    }
    return _top;
}

- (void)updatePath
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(25, 150)];
    [path addLineToPoint: CGPointMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 50) * _progress + 25, 150 + (25.f * (1 - fabs(_progress - 0.5) * 2)))];
    [path addLineToPoint: CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 25, 150)];
    self.background.path = path.CGPath;
    self.top.path = path.CGPath;
    self.top.strokeEnd = _progress;
}


@end

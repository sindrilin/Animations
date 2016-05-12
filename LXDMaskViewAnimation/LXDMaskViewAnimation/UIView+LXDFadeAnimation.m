//
//  UIView+LXDFadeAnimation.m
//  LXDPersonalBlog
//
//  Created by 林欣达 on 16/5/10.
//  Copyright © 2016年 SindriLin. All rights reserved.
//

#import "UIView+LXDFadeAnimation.h"
#import <objc/runtime.h>

const void * kIsFadeKey = &kIsFadeKey;
const void * kIsAnimatingKey = &kIsAnimatingKey;
const void * kVerticalCountKey = &kVerticalCountKey;
const void * kHorizontalCountKey = &kHorizontalCountKey;
const void * kIntervalDurationKey = &kIntervalDurationKey;
const void * kAnimationDurationKey = &kAnimationDurationKey;

static NSInteger kMaskViewTag = 0x1000000;


@implementation UIView (LXDFadeAnimation)


#pragma mark - getter & setter
- (BOOL)isFade
{
    return [objc_getAssociatedObject(self, kIsFadeKey) boolValue];
}

- (BOOL)isFading
{
    return [objc_getAssociatedObject(self, kIsAnimatingKey) boolValue];
}

- (NSInteger)verticalCount
{
    NSNumber * count = objc_getAssociatedObject(self, kVerticalCountKey);
    if (!count) {
        self.verticalCount = 2;
    }
    return [objc_getAssociatedObject(self, kVerticalCountKey) integerValue];
}

- (NSInteger)horizontalCount
{
    NSNumber * count = objc_getAssociatedObject(self, kHorizontalCountKey);
    if (!count) {
        self.horizontalCount = 18;
    }
    return [objc_getAssociatedObject(self, kHorizontalCountKey) integerValue];
}

- (NSTimeInterval)intervalDuration
{
    NSNumber * count = objc_getAssociatedObject(self, kIntervalDurationKey);
    if (!count) {
        objc_setAssociatedObject(self, kIntervalDurationKey, @(0.175), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, kIntervalDurationKey) doubleValue];
}

- (NSTimeInterval)fadeAnimationDuration
{
    NSNumber * count = objc_getAssociatedObject(self, kAnimationDurationKey);
    if (!count) {
        objc_setAssociatedObject(self, kAnimationDurationKey, @(0.7), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [objc_getAssociatedObject(self, kAnimationDurationKey) doubleValue];
}

- (void)setIsFade: (BOOL)isFade
{
    objc_setAssociatedObject(self, kIsFadeKey, @(isFade), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsFading: (BOOL)isFading
{
    objc_setAssociatedObject(self, kIsAnimatingKey, @(isFading), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setVerticalCount: (NSInteger)verticalCount
{
    verticalCount = MAX(1, MIN(4, verticalCount));
    objc_setAssociatedObject(self, kVerticalCountKey, @(verticalCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHorizontalCount: (NSInteger)horizontalCount
{
    horizontalCount = MAX(16, MIN(20, horizontalCount));
    objc_setAssociatedObject(self, kHorizontalCountKey, @(horizontalCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIntervalDuration: (NSTimeInterval)intervalDuration
{
    intervalDuration = MAX(LXDMINDURATION * LXDMULTIPLED, MIN(self.fadeAnimationDuration * LXDMULTIPLED, intervalDuration));
    objc_setAssociatedObject(self, kIntervalDurationKey, @(intervalDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFadeAnimationDuration: (NSTimeInterval)fadeAnimationDuration
{
    fadeAnimationDuration = MAX(LXDMINDURATION, MIN(LXDMAXDURATION, fadeAnimationDuration));
    if (self.intervalDuration > fadeAnimationDuration * LXDMULTIPLED || self.intervalDuration <= 0) {
        self.intervalDuration = fadeAnimationDuration * LXDMULTIPLED;
    }
    objc_setAssociatedObject(self, kAnimationDurationKey, @(fadeAnimationDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 操作
- (void)configurateWithVerticalCount: (NSInteger)verticalCount horizontalCount: (NSInteger)horizontalCount interval: (NSTimeInterval)interval duration: (NSTimeInterval)duration
{
    self.verticalCount = verticalCount;
    self.horizontalCount = horizontalCount;
    self.intervalDuration = interval;
    self.fadeAnimationDuration = duration;
    if (!self.maskView) {
        self.maskView = self.fadeMaskView;
    }
}

- (void)animateFadeWithComplete: (void (^)(void))complete
{
    if (self.isFading) {
        NSLog(@"It's animating!");
        return;
    }
    if (!self.maskView) {
        self.maskView = self.fadeMaskView;
    }
    self.isFading = YES;
    if (self.fadeAnimationDuration <= 0) { self.fadeAnimationDuration = (LXDMAXDURATION + LXDMINDURATION) / 2; }
    if (self.intervalDuration <= 0) { self.intervalDuration = self.fadeAnimationDuration * LXDMULTIPLED; }

    __block NSInteger timeCount = 0;
    NSInteger fadeCount = self.verticalCount * self.horizontalCount;
    for (NSInteger idx = 0; idx < fadeCount; idx++) {
        UIView * subview = [self.maskView viewWithTag: [self subViewTag: idx]];
        if (!subview) { continue; }
        [UIView animateWithDuration: self.fadeAnimationDuration delay: self.intervalDuration * idx options: UIViewAnimationOptionCurveLinear animations: ^{
            subview.alpha = 0;
        } completion: ^(BOOL finished) {
            if (timeCount != fadeCount - 1) {
                timeCount++;
            } else {
                self.isFade = YES;
                self.isFading = NO;
                if (complete) { complete(); }
            }
        }];
    }
}

- (void)reverseWithComplete: (void(^)(void))complete
{
    NSParameterAssert(self.maskView);
    if (self.isFading) {
        NSLog(@"It's animating!");
        return;
    }
    self.isFading = YES;
    if (self.fadeAnimationDuration <= 0) { self.fadeAnimationDuration = (LXDMAXDURATION + LXDMINDURATION) / 2; }
    if (self.intervalDuration <= 0) { self.intervalDuration = self.fadeAnimationDuration * LXDMULTIPLED; }
    
    __block NSInteger timeCount = 0;
    NSInteger fadeCount = self.verticalCount * self.horizontalCount;
    for (NSInteger idx = fadeCount - 1; idx >= 0; idx--) {
        UIView * subview = [self.maskView viewWithTag: [self subViewTag: idx]];
        [UIView animateWithDuration: self.fadeAnimationDuration delay: self.intervalDuration * (fadeCount - 1 - idx) options: UIViewAnimationOptionCurveLinear animations: ^{
            subview.alpha = 1;
        } completion: ^(BOOL finished) {
            if (++timeCount == fadeCount) {
                self.isFade = NO;
                self.isFading = NO;
                if (complete) { complete(); }
            }
        }];
    }
}

- (UIView *)fadeMaskView
{
    UIView * fadeMaskView = [[UIView alloc] initWithFrame: self.bounds];
    if (self.horizontalCount <= 0) { self.horizontalCount = 10; }
    if (self.verticalCount <= 0) { self.verticalCount = 3; }
    
    CGFloat itemWidth = CGRectGetWidth(self.frame) / (self.horizontalCount);
    CGFloat itemHeight = CGRectGetHeight(self.frame) / (self.verticalCount);
    for (NSInteger line = 0; line < self.horizontalCount; line++) {
        for (NSInteger row = 0; row < self.verticalCount; row++) {
            UIView * maskSubview = [[UIView alloc] initWithFrame: CGRectMake(itemWidth * line, itemHeight * row, itemWidth, itemHeight)];
            maskSubview.tag = [self subViewTag: line * self.verticalCount + row];
            maskSubview.backgroundColor = [UIColor blackColor];
            [fadeMaskView addSubview: maskSubview];
        }
    }
    return fadeMaskView;
}

- (NSInteger)subViewTag: (NSInteger)idx
{
    return kMaskViewTag + idx;
}

- (void)reverseWithoutAnimate
{
    if (self.isFading) {
        NSLog(@"It's animating!");
        return;
    }
    for (UIView * subview in self.maskView.subviews) {
        subview.alpha = 1;
    }
}


@end

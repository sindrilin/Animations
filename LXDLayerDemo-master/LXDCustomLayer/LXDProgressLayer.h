//
//  LXDProgressLayer.h
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef void(^LXDProgressReport)(NSUInteger progress, CGRect textRect, CGColorRef textColor);

@interface LXDProgressLayer : CALayer

@property (nonatomic, copy) LXDProgressReport report;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat strokeEnd;
@property (nonatomic, assign) CGColorRef fillColor;
@property (nonatomic, assign) CGColorRef strokeColor;

@end

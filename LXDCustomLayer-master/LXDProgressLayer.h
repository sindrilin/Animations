//
//  LXDProgressLayer.h
//  LXDProgressView
//
//  Created by 林欣达 on 15/11/17.
//  Copyright © 2015年 sindri lin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface LXDProgressLayer : CALayer

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGColorRef fillColor;
@property (nonatomic, assign) CGColorRef strokeColor;

@end

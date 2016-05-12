//
//  LXDSegmentControlDefine.h
//  LXDTwoDimensionalBarcode
//
//  Created by linxinda on 15/10/26.
//  Copyright © 2015年 cnpayany. All rights reserved.
//

#ifndef LXDSegmentControlDefine_h
#define LXDSegmentControlDefine_h

#define SMALLSCALE 0.75f
#define INITSCALE 1.f
#define BIGSCALE 1.25f
#define ANIMATION_DURATION 0.15f
#define CLEAR_COLOR [UIColor clearColor]


/*! 分栏控制器类型。不同类型有不同默认属性*/
typedef enum
{
    /*! 滑块移动(默认)*/
    LXDSegmentControlTypeSlideBlock = 0,
    /*! 选中类型*/
    LXDSegmentControlTypeSelectBlock,
    /*!  选中放大*/
    LXDSegmentControlTypeScaleTitle
} LXDSegmentControlType;


static inline UIColor * kRGB(CGFloat red, CGFloat green, CGFloat blue)
{
    return [UIColor colorWithRed: red/255.f green: green/255.f blue: blue/255.f alpha: 1.f];
}

static inline UIColor * kNumberColor(NSUInteger rgb)
{
    NSUInteger red = (rgb >> 16) & 0xff;
    NSUInteger green = (rgb >> 8) & 0xff;
    NSUInteger blue = rgb & 0xff;
    return kRGB(red, green, blue);
}

#endif /* LXDSegmentControlDefine_h */

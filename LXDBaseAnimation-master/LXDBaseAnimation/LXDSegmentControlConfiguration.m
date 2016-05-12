//
//  LXDSegmentControlConfiguration.m
//  LXDTwoDimensionalBarcode
//
//  Created by 林欣达 on 15/10/26.
//  Copyright © 2015年 cnpayany. All rights reserved.
//

#import "LXDSegmentControlConfiguration.h"

@implementation LXDSegmentControlConfiguration


#pragma mark - initializer - 构造器
/*! 构造器方法*/
- (instancetype)init
{
    return [self initWithControlType: LXDSegmentControlTypeSlideBlock items: nil];
}

/*! 构造器方法*/
- (instancetype)initWithItems: (NSArray<NSString *> *)items
{
    return [self initWithControlType: LXDSegmentControlTypeSlideBlock items: items];
}

/*! 构造器方法*/
- (instancetype)initWithControlType: (LXDSegmentControlType)controlType items: (NSArray<NSString *> *)items
{
    NSAssert((items != nil && items.count > 0), @"Can not init configuration for segment control with nil array");
    if (self = [super init]) {
        self.items = items;
        self.controlType = controlType;
        [self setupConfiguration];
    }
    return self;
}

/*! 构造器方法*/
+ (instancetype)configurationWithItems: (NSArray<NSString *> *)items
{
    return [[self alloc] initWithControlType: LXDSegmentControlTypeSlideBlock items: items];
}

/*! 构造器方法*/
+ (instancetype)configurationWithControlType: (LXDSegmentControlType)controlType items: (NSArray<NSString *> *)items
{
    return [[self alloc] initWithControlType: controlType items: items];
}


#pragma mark - setup - 配置
/*!
 *  配置属性
 */
- (void)setupConfiguration
{
    switch (_controlType) {
        case LXDSegmentControlTypeSlideBlock:
            [self slideBlockConfiguration];
            break;
            
        case LXDSegmentControlTypeSelectBlock:
            [self selectBlockConfiguration];
            break;
            
        case LXDSegmentControlTypeScaleTitle:
            [self scaleTitleConfiguration];
            break;
    }
}

/*!
 *  滑块属性
 */
- (void)slideBlockConfiguration
{
    self.itemNormalScale = self.itemSelectScale = INITSCALE;
    self.backgroundColor = CLEAR_COLOR;
    self.itemSelectedColor = CLEAR_COLOR;
    self.itemBackgroundColor = CLEAR_COLOR;
    self.itemSelectedColor = CLEAR_COLOR;
    self.itemTextColor = [UIColor colorWithWhite: 0.2f alpha: 0.9f];
    self.itemSelectedTextColor = kNumberColor(0x28ac85);
    self.animationDuration = ANIMATION_DURATION;
    self.slideBlockColor = kNumberColor(0x28ac85);
}

/*!
 *  选中属性
 */
- (void)selectBlockConfiguration
{
    self.itemNormalScale = self.itemSelectScale = INITSCALE;
    self.cornerRadius = 5.f;
    self.cornerWidth = 1.f;
    self.cornerColor = kRGB(123, 189, 229);
    self.backgroundColor = CLEAR_COLOR;
    self.itemBackgroundColor = CLEAR_COLOR;
    self.itemSelectedColor = kRGB(123, 189, 229);
    self.itemTextColor = kRGB(123, 189, 229);
    self.itemSelectedTextColor = [UIColor whiteColor];
    self.animationDuration = ANIMATION_DURATION;
    self.slideBlockColor = CLEAR_COLOR;
}

/*!
 *  形变属性
 */
- (void)scaleTitleConfiguration
{
    self.itemNormalScale = SMALLSCALE;
    self.itemSelectScale = BIGSCALE;
    self.backgroundColor = CLEAR_COLOR;
    self.itemBackgroundColor = CLEAR_COLOR;
    self.itemSelectedColor = CLEAR_COLOR;
    self.itemTextColor = [UIColor colorWithWhite: 0.2f alpha: 0.9f];
    self.itemSelectedTextColor = kRGB(223, 83, 84);
    self.animationDuration = ANIMATION_DURATION;
    self.slideBlockColor = CLEAR_COLOR;
}


@end

//
//  LXDSegmentControlConfiguration.h
//  LXDTwoDimensionalBarcode
//
//  Created by 林欣达 on 15/10/26.
//  Copyright © 2015年 cnpayany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXDSegmentControlDefine.h"

/*!
 *  @class  LXDSegmentControlConfiguration
 *  @abstract   分栏控制器配置属性
 */
@interface LXDSegmentControlConfiguration : NSObject

/*! 构造器方法*/
- (instancetype)initWithItems: (NSArray<NSString *> *)items;
/*! 构造器方法*/
- (instancetype)initWithControlType: (LXDSegmentControlType)controlType items: (NSArray<NSString *> *)items;
/*! 构造器方法*/
+ (instancetype)configurationWithItems: (NSArray<NSString *> *)items;
/*! 构造器方法*/
+ (instancetype)configurationWithControlType: (LXDSegmentControlType)controlType items: (NSArray<NSString *> *)items;

/*! 分栏控制器的标题数组*/
@property (nonatomic, copy) NSArray<NSString *> * items;
/*! 分栏控制器样式*/
@property (nonatomic, assign) LXDSegmentControlType controlType;

/*! 放大比例*/
@property (nonatomic, assign) CGFloat itemSelectScale;
/*! 正常比例*/
@property (nonatomic, assign) CGFloat itemNormalScale;
/*! 分栏控制器的圆角半径*/
@property (nonatomic, assign) CGFloat cornerRadius;
/*! 分栏控制器的圆角线条宽度*/
@property (nonatomic, assign) CGFloat cornerWidth;
/*! 分栏控制器的边缘线条颜色*/
@property (nonatomic, strong) UIColor * cornerColor;
/*! 分栏控制器当前选中的下标*/
@property (nonatomic, assign) NSUInteger currentIndex;
/*! 分栏控制器的背景颜色*/
@property (nonatomic, strong) UIColor * backgroundColor;

/*! 分栏按钮的选中颜色*/
@property (nonatomic, strong) UIColor * itemSelectedColor;
/*! 分栏按钮的背景颜色*/
@property (nonatomic, strong) UIColor * itemBackgroundColor;
/*! 分栏按钮的字体颜色*/
@property (nonatomic, strong) UIColor * itemTextColor;
/*! 分栏按钮的选中字体颜色*/
@property (nonatomic, strong) UIColor * itemSelectedTextColor;

/*! 点击动画时间*/
@property (nonatomic, assign) NSTimeInterval animationDuration;
/*! 滑块颜色*/
@property (nonatomic, strong) UIColor * slideBlockColor;

@end

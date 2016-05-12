//
//  LXDSegmentControl.h
//  LXDTwoDimensionalBarcode
//
//  Created by 林欣达 on 15/10/26.
//  Copyright © 2015年 cnpayany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXDSegmentControlConfiguration.h"

#pragma mark - notification - 通知
/*! 点击分栏控制器在没有代理人的情况下进行通知*/
extern NSString * const LXDSegmentControlSelectIndexNotification;
/*! 通知传递点击下标信息的key值*/
extern NSString * const LXDSegmentControlIndexKey;


#pragma mark - protocol - 协议
@class LXDSegmentControl;
@protocol LXDSegmentControlDelegate <NSObject>

/*! 
 *  @method segmentControl: didSelectAtIndex:
 *  @abstract   点击分栏按钮回调协议方法。如果要刷新数据源显示，应该在这个方法中进行刷新
 */
- (void)segmentControl: (LXDSegmentControl *)segmentControl didSelectAtIndex: (NSUInteger)index;

@end


#pragma mark - class - 类
/*! 
 *  @class  LXDSegmentControl
 *  @abstract   分栏控制器。暂只支持横向滚动视图
 */
@interface LXDSegmentControl : UIView

/*!
 *  @property   configuration
 *  @abstract   分栏控制器的配置属性
 */
@property (nonatomic, strong) LXDSegmentControlConfiguration * configuration;

/*!
 *  @property   delegate
 *  @abstract   协议回调代理人
 */
@property (nonatomic, weak) id<LXDSegmentControlDelegate> delegate;

/*!
 *  @property   scrollView
 *  @abstract   滚动视图。如果此项不为空，分栏控制器可以控制滚动视图的滚动
 */
@property (nonatomic, weak) UIScrollView * scrollView;

/*!
 *  @property   pageControl
 *  @abstract   页面显示视图。如果此项不为空，分栏控制器可以控制页面显示控件的移动
 */
@property (nonatomic, weak) UIPageControl * pageControl;

/*!
 *  @property   currentIndex
 *  @abstract   控制器当前选中的分栏下标。不要直接通过获取此下标来刷新数据源
 */
@property (nonatomic, assign) NSUInteger currentIndex;

/*!
 *  @method initWithConfiguration: 
 *  @abstract   使用属性配置对象构造分栏控制器
 */
- (instancetype)initWithFrame: (CGRect)frame configuration: (LXDSegmentControlConfiguration *)configuration delegate: (id<LXDSegmentControlDelegate>)delegate;

/*!
 *  @method segmentControlWithConfiguration:
 *  @abstract   使用属性配置对象构造分栏控制器
 */
+ (instancetype)segmentControlWithFrame: (CGRect)frame configuration: (LXDSegmentControlConfiguration *)configuration delegate: (id<LXDSegmentControlDelegate>)delegate;


@end

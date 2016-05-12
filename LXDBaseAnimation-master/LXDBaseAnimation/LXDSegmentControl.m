//
//  LXDSegmentControl.m
//  LXDTwoDimensionalBarcode
//
//  Created by 林欣达 on 15/10/26.
//  Copyright © 2015年 cnpayany. All rights reserved.
//

#import "LXDSegmentControl.h"

#define BUTTONINITTAG 10000
NSString * const LXDSegmentControlSelectIndexNotification = @"LXDSegmentControlSelectIndexNotification";
NSString * const LXDSegmentControlIndexKey = @"LXDSegmentControlIndexKey";


@interface LXDSegmentControl ()

@property (nonatomic, strong) NSLock * lock;
@property (nonatomic, strong) UIView * slideBlock;
@property (nonatomic, weak) UIButton * currentItem;

@end

@implementation LXDSegmentControl


#pragma mark - initializer - 构造器
/*!
 *  @method initWithConfiguration:
 *  @abstract   使用属性配置对象构造分栏控制器
 */
- (instancetype)initWithFrame: (CGRect)frame configuration: (LXDSegmentControlConfiguration *)configuration delegate: (id<LXDSegmentControlDelegate>)delegate
{
    frame.size.height = 40.f;
    if (self = [super initWithFrame: frame]) {
        self.configuration = configuration;
        self.delegate = delegate;
        
        [self setupSelf];
        [self setupItems];
    }
    return self;
}

/*!
 *  @method segmentControlWithConfiguration:
 *  @abstract   使用属性配置对象构造分栏控制器
 */
+ (instancetype)segmentControlWithFrame: (CGRect)frame configuration: (LXDSegmentControlConfiguration *)configuration delegate: (id<LXDSegmentControlDelegate>)delegate
{
    return [[self alloc] initWithFrame: frame configuration: configuration delegate: delegate];
}


#pragma mark - setup - 配置
/*!
 *  配置分栏控制器属性
 */
- (void)setupSelf
{
    self.backgroundColor = _configuration.backgroundColor;
    self.layer.cornerRadius = _configuration.cornerRadius;
    self.layer.borderColor = _configuration.cornerColor.CGColor;
    self.layer.borderWidth = _configuration.cornerWidth;
    self.clipsToBounds = YES;
}

/*!
 *  配置分栏按钮属性
 */
- (void)setupItems
{
    [_configuration.items enumerateObjectsUsingBlock: ^(NSString * _Nonnull itemTitle, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * item = [self segmentItemWithIndex: idx];
        [item setTitle: itemTitle forState: UIControlStateNormal];
        [self addSubview: item];
        if (idx == 0) { [self clickSegmentItem: item]; }
    }];
    if (_configuration.controlType == LXDSegmentControlTypeSlideBlock) {
        [self addSubview: self.slideBlock];
    }
}


#pragma mark - subview init - 子控件初始化
/*!
 *  创建分隔栏按钮
 */
- (UIButton *)segmentItemWithIndex: (NSUInteger)index
{
    CGFloat itemWidth = CGRectGetWidth(self.bounds) / _configuration.items.count;
    CGFloat itemHeight = CGRectGetHeight(self.bounds);
    UIButton * segmentItem = [[UIButton alloc] initWithFrame: CGRectMake(index * itemWidth, 0, itemWidth, itemHeight)];
    
    segmentItem.tag = BUTTONINITTAG + index;
    segmentItem.backgroundColor = _configuration.itemBackgroundColor;
    [segmentItem setTitleColor: _configuration.itemTextColor forState: UIControlStateNormal];
    [segmentItem setTitleColor: _configuration.itemSelectedTextColor forState: UIControlStateSelected];
    [segmentItem addTarget: self action: @selector(clickSegmentItem:) forControlEvents: UIControlEventTouchUpInside];
    segmentItem.transform = CGAffineTransformMakeScale(_configuration.itemNormalScale, _configuration.itemNormalScale);
    
    return segmentItem;
}

/*!
 *  创建滑动
 */
- (UIView *)slideBlock
{
    if (!_slideBlock) {
        CGFloat itemWidth = CGRectGetWidth(self.bounds) / _configuration.items.count;
        CGFloat height = CGRectGetHeight(self.bounds);
        _slideBlock = [[UIView alloc] initWithFrame: CGRectMake(itemWidth * 0.25f, height - 3.f, itemWidth * 0.5f, 2.f)];
        _slideBlock.backgroundColor = _configuration.slideBlockColor;
    }
    return _slideBlock;
}

/*!
 *  线程锁
 */
- (NSLock *)lock
{
    if (!_lock) { _lock = [NSLock new]; }
    return _lock;
}


#pragma mark - setter
/*!
 *  设置新选中按钮时取消旧选中效果
 */
- (void)setCurrentItem: (UIButton *)currentItem
{
    [_currentItem setSelected: NO];
    _currentItem.backgroundColor = _configuration.itemBackgroundColor;
    
    [UIView animateWithDuration: _configuration.animationDuration animations: ^{
        _currentItem.transform = CGAffineTransformMakeScale(_configuration.itemNormalScale, _configuration.itemNormalScale);
        currentItem.transform = CGAffineTransformMakeScale(_configuration.itemSelectScale, _configuration.itemSelectScale);
    }];
    [currentItem setSelected: YES];
    currentItem.backgroundColor = _configuration.itemSelectedColor;
    _currentItem = currentItem;
}

/**
 *  设置选中下标
 */
- (void)setCurrentIndex: (NSUInteger)currentIndex
{
    if (_currentIndex == currentIndex || currentIndex >= _configuration.items.count) { return; }
    UIButton * clickedButton = [self viewWithTag: BUTTONINITTAG+currentIndex];
    [self clickSegmentItem: clickedButton];
}


#pragma mark - event
/*!
 *  点击分栏按钮回调
 */
- (void)clickSegmentItem: (UIButton *)segmentItem
{
    if (segmentItem == _currentItem) { return; }
    [self.lock lock];
    
    self.currentItem = segmentItem;
    NSUInteger index = segmentItem.tag - BUTTONINITTAG;
    [self changeAssociateViewWithIndex: index];
    [self callbackWithIndex: index];
    
    [self.lock unlock];
}

/*!
 *  改变关联的视图
 */
- (void)changeAssociateViewWithIndex: (NSUInteger)index
{
    _currentIndex = index;
    if (_scrollView) {
        if (_scrollView.contentSize.width / CGRectGetWidth(_scrollView.frame) >= index) {
            [_scrollView setContentOffset: CGPointMake(index * CGRectGetWidth(_scrollView.frame), 0) animated: YES];
        }
    }
    if (_pageControl) {
        if (_pageControl.numberOfPages > index) {
            _pageControl.currentPage = index;
        }
    }
    if (_slideBlock) {
        CGRect frame = _slideBlock.frame;
        CGFloat itemWidth = CGRectGetWidth(self.bounds) / _configuration.items.count;
        frame.origin.x = (index + 0.25f) * itemWidth;
        [UIView animateWithDuration: _configuration.animationDuration animations: ^{
            _slideBlock.frame = frame;
        }];
    }
}

/*!
 *  通过代理或者通知回调
 */
- (void)callbackWithIndex: (NSUInteger)index
{
    _configuration.currentIndex = index;
    if ([_delegate respondsToSelector: @selector(segmentControl:didSelectAtIndex:)]) {
        [_delegate segmentControl: self didSelectAtIndex: index];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName: LXDSegmentControlSelectIndexNotification object: self userInfo: @{LXDSegmentControlIndexKey: @(index)}];
    }
}


@end

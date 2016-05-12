//
//  LXDSlideManager.m
//  LXDSlideMenuObjectiveC
//
//  Created by linxinda on 15/11/29.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

#import "LXDSlideManager.h"


#define kMaxOpenRatio 0.7
#define kWidth CGRectGetWidth([UIScreen mainScreen].bounds)


@interface LXDSlideManager ()

@property (nonatomic, strong) UITapGestureRecognizer * tap;
@property (nonatomic, strong) UIView * snapView;
@property (nonatomic, assign) BOOL isOpen;

@end


@implementation LXDSlideManager

static LXDSlideManager * sharedManager = nil;
UIViewController * _mainController = nil;
UIViewController * _menuController = nil;

+ (__nonnull instancetype)sharedManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (void)setupMainController: (UIViewController *)mainController
{
    [_mainController.view removeGestureRecognizer: self.tap];
    [_mainController.view removeFromSuperview];
    _mainController = mainController;
    
    if (_menuController == nil) { return; }
    [_mainController.view addSubview: _menuController.view];
}

- (void)setupMenuController:(UIViewController *)menuController
{
    [_menuController.view removeFromSuperview];
    _menuController = menuController;
    _menuController.view.frame = CGRectOffset([UIScreen mainScreen].bounds, kWidth, 0);
    
    if (_demoType == LXDDemoTypeOnWindow) {
        [[UIApplication sharedApplication].keyWindow addSubview: _menuController.view];
    } else if (_demoType == LXDDemoTypeOnMainView && _mainController != nil) {
        [_mainController.view addSubview: _menuController.view];
    }
}

- (void)dealloc
{
    _mainController = nil;
    _menuController = nil;
}

- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(close)];
    }
    return _tap;
}


- (void)setDemoType:(LXDDemoType)demoType
{
    _demoType = demoType;
    [_menuController.view removeFromSuperview];
    if (_menuController == nil) { return; }
    
    if (demoType == LXDDemoTypeOnWindow) {
        [[UIApplication sharedApplication].keyWindow addSubview: _menuController.view];
    } else if (demoType == LXDDemoTypeOnMainView && _mainController != nil) {
        [_mainController.view addSubview: _menuController.view];
    }
}


- (void)openOrClose
{
    if (_isOpen) {
        [self close];
    } else {
        [self open];
    }
}

- (BOOL)useSnap {
    return _slideType == LXDSlideTypeBothMove && _demoType == LXDDemoTypeOnMainView;
}


- (void)open
{
    _isOpen = YES;
    
    if (_menuController == nil || _mainController == nil) {
        @throw [NSException exceptionWithName: @"LXDNullInstanceException" reason: @"you can not slide view when one or more of menu view and main view is nil" userInfo: nil];
    }
    
    CGRect mainFrame = _mainController.view.frame;
    CGRect menuFrame = _menuController.view.frame;
    
    if (_slideType == LXDSlideTypeMenuMove || _demoType == LXDDemoTypeOnWindow) {
        menuFrame.origin.x = (1 - kMaxOpenRatio) * kWidth;
    }
    if (_slideType == LXDSlideTypeBothMove) {
        mainFrame.origin.x = -kWidth * kMaxOpenRatio;
    }
    if ([self useSnap]) {
        self.snapView = [_mainController.view snapshotViewAfterScreenUpdates: NO];
        _snapView.frame = _mainController.view.frame;
        [_mainController.view addSubview: _snapView];
        menuFrame.origin.x = (1 - kMaxOpenRatio) * kWidth;
    }
    
    [UIView animateWithDuration: 0.2 animations: ^{
        if ([self useSnap]) {
            _snapView.frame = mainFrame;
        } else {
            _mainController.view.frame = mainFrame;
        }
        _menuController.view.frame = menuFrame;
    } completion: ^(BOOL finished) {
        if (finished) {
            [self useSnap] ? [_snapView addGestureRecognizer: self.tap] : [_mainController.view addGestureRecognizer: self.tap];
        }
    }];
}

- (void)close
{
    _isOpen = NO;
    [_menuController.view endEditing: YES];
    [_mainController.view removeGestureRecognizer: self.tap];
    
    CGRect menuFrame = _menuController.view.frame;
    CGRect mainFrame = _mainController.view.frame;
    
    mainFrame.origin.x = 0;
    if (_slideType == LXDSlideTypeMenuMove || _demoType == LXDDemoTypeOnWindow || [self useSnap]) {
        menuFrame.origin.x = kWidth;
    }
    
    [UIView animateWithDuration: 0.2 animations: ^{
        if ([self useSnap]) { _snapView.frame = mainFrame; }
        _mainController.view.frame = mainFrame;
        _menuController.view.frame = menuFrame;
    } completion: ^(BOOL finished) {
        [_snapView removeFromSuperview];
    }];
}




@end

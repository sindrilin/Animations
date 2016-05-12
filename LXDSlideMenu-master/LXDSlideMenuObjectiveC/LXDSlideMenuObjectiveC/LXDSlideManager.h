//
//  LXDSlideManager.h
//  LXDSlideMenuObjectiveC
//
//  Created by linxinda on 15/11/29.
//  Copyright © 2015年 sindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LXDDemoTypeOnMainView,     //在主视图上面添加
    LXDDemoTypeOnWindow,        //在window上添加边栏视图
} LXDDemoType;

typedef enum
{
    LXDSlideTypeBothMove,           //两个视图都移动
    LXDSlideTypeMenuMove,          //只移动边栏视图（加在window上时，可能会导致主视图覆盖导致边栏视图无法显示）
} LXDSlideType;

@interface LXDSlideManager : NSObject

+ (__nonnull instancetype)sharedManager;
- (void)setupMainController: (UIViewController * __nonnull)mainController;
- (void)setupMenuController: (UIViewController * __nonnull)menuController;
- (void)openOrClose;

@property (nonatomic, assign) LXDSlideType slideType;
@property (nonatomic, assign) LXDDemoType demoType;

@end

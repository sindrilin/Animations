//
//  UITextField+LXDRestrict.h
//  LXDTextFieldAdjust
//
//  Created by linxinda on 16/9/23.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import "LXDTextRestrict.h"

@interface UITextField (LXDRestrict)

/// 设置后生效
@property (nonatomic, assign) LXDRestrictType restrictType;

/// 文本最长长度
@property (nonatomic, assign) NSUInteger maxTextLength;

/// 设置自定义的文本限制
@property (nonatomic, strong) LXDTextRestrict * textRestrict;

@end

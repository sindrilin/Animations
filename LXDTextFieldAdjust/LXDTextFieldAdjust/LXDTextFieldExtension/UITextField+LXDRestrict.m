//
//  UITextField+LXDRestrict.m
//  LXDTextFieldAdjust
//
//  Created by linxinda on 16/9/23.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import "UITextField+LXDRestrict.h"
#import <objc/runtime.h>

static void * LXDRestrictTypeKey = &LXDRestrictTypeKey;
static void * LXDTextRestrictKey = &LXDTextRestrictKey;
static void * LXDMaxTextLengthKey = &LXDMaxTextLengthKey;

@implementation UITextField (LXDRestrict)

- (LXDRestrictType)restrictType
{
    return [objc_getAssociatedObject(self, LXDRestrictTypeKey) integerValue];
}

- (void)setRestrictType: (LXDRestrictType)restrictType
{
    objc_setAssociatedObject(self, LXDRestrictTypeKey, @(restrictType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textRestrict = [LXDTextRestrict textRestrictWithRestrictType: restrictType];
}

- (LXDTextRestrict *)textRestrict
{
    return objc_getAssociatedObject(self, LXDTextRestrictKey);
}

- (void)setTextRestrict: (LXDTextRestrict *)textRestrict
{
    if (self.textRestrict) {
        [self removeTarget: self.text action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    }
    textRestrict.maxLength = self.maxTextLength;
    [self addTarget: textRestrict action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    objc_setAssociatedObject(self, LXDTextRestrictKey, textRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)maxTextLength
{
    NSUInteger maxTextLength = [objc_getAssociatedObject(self, LXDMaxTextLengthKey) unsignedIntegerValue];
    if (maxTextLength == 0) {
        self.maxTextLength = NSUIntegerMax;
    }
    return [objc_getAssociatedObject(self, LXDMaxTextLengthKey) unsignedIntegerValue];
}

- (void)setMaxTextLength: (NSUInteger)maxTextLength
{
    if (maxTextLength == 0) {
        maxTextLength = NSUIntegerMax;
    }
    objc_setAssociatedObject(self, LXDMaxTextLengthKey, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

//
//  LXDTextRestrict.h
//  LXDTextFieldAdjust
//
//  Created by linxinda on 16/9/23.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^LXDStringFilter)(NSString * aString);

typedef NS_ENUM(NSInteger, LXDRestrictType)
{
    LXDRestrictTypeOnlyNumber = 1,      ///< 只允许输入数字
    LXDRestrictTypeOnlyDecimal = 2,     ///<  只允许输入实数，包括.
    LXDRestrictTypeOnlyCharacter = 3,  ///<  只允许非中文输入
};

/*!
 *  文本限制
 */
@interface LXDTextRestrict : NSObject

@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, readonly) LXDRestrictType restrictType;

+ (instancetype)textRestrictWithRestrictType: (LXDRestrictType)restrictType;
- (void)textDidChanged: (UITextField *)textField;

@end

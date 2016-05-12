//
//  ViewController.m
//  LXDAutoLayoutAnimationDemo
//
//  Created by linxinda on 16/3/10.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import "ViewController.h"
#import "LXDAnimateButton.h"

@interface ViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

//  约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountHeightConstraint;

@property (weak, nonatomic) NSLayoutConstraint *loginRatioConstraint;
@property (weak, nonatomic) NSLayoutConstraint *loginCenterXConstraint;

//  数据
@property (assign, nonatomic) BOOL isAnimating;
@property (strong, nonatomic) NSArray<NSString *> *records;

//  控件
@property (weak, nonatomic) IBOutlet UIButton *dropdownButton;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet LXDAnimateButton *signInButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _signInButton.layer.cornerRadius = _loginHeightConstraint.constant / 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Event
/// 点击打开或者隐藏列表
- (IBAction)actionToOpenOrCloseList:(UIButton *)sender {
    [self.view endEditing: YES];
    [self animateToRotateArrow: sender.selected];
    sender.isSelected ? [self showRecordList] : [self hideRecordList];
}

/// 点击登录动画
- (IBAction)actionToSignIn:(UIButton *)sender {
    _isAnimating = !_isAnimating;
    if (_isAnimating) {
        [_signInButton start];
        [self animateToMakeButtonSmall];
    } else {
        [_signInButton stop];
        [self animateToMakeButtonBig];
    }
}

/// 按钮转向动画
- (void)animateToRotateArrow: (BOOL)selected
{
    CATransform3D transform = selected ? CATransform3DIdentity : CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [_dropdownButton setSelected: !selected];
    [UIView animateWithDuration: 0.25 animations: ^{
        _dropdownButton.layer.transform = transform;
    }];
}


#pragma mark - Animate
static NSString * centerXIdentifier = @"centerXConstraint";
static NSString * ratioIdentifier = @"ratioIdentifier";
/// 缩小按钮
- (void)animateToMakeButtonSmall {
    _loginLeftConstraint.active = NO;
    _loginRightConstraint.active = NO;
    
    //创建宽高比约束
    NSLayoutConstraint * ratioConstraint = [NSLayoutConstraint constraintWithItem: _signInButton attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: _signInButton attribute: NSLayoutAttributeHeight multiplier: 1. constant: 0];
    ratioConstraint.active = YES;
    ratioConstraint.identifier = ratioIdentifier;
    _loginRatioConstraint = ratioConstraint;
    
    //创建居中约束
    NSLayoutConstraint * centerXConstraint = [NSLayoutConstraint constraintWithItem: _signInButton attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: _signInButton.superview attribute: NSLayoutAttributeCenterX multiplier: 1. constant: 0.];
    centerXConstraint.active = YES;
    centerXConstraint.identifier = centerXIdentifier;
    _loginCenterXConstraint = centerXConstraint;
    
    [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseIn animations: ^{
        [self.view layoutIfNeeded];
    } completion: nil];
}

/// 还原按钮
- (void)animateToMakeButtonBig {

#define CODELAYOUT
#ifdef CODELAYOUT
    
#define LAYOUTUSEID
#ifdef LAYOUTUSEID
    [_signInButton.constraints enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString: centerXIdentifier]) {
            obj.active = NO;
        } else if ([obj.identifier isEqualToString: ratioIdentifier]) {
            obj.active = NO;
        }
    }];
#else
    [_signInButton.constraints enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.firstItem == _signInButton && obj.firstAttribute == NSLayoutAttributeCenterX) {
            obj.active = NO;
        } else if (obj.firstAttribute == NSLayoutAttributeWidth && obj.secondAttribute == NSLayoutAttributeHeight) {
            obj.active = NO;
        }
    }];
#endif
    
#else
    _loginCenterXConstraint.active = NO;
    _loginRatioConstraint.active = NO;
#endif
    
    
    NSLayoutConstraint * leftConstraint = [NSLayoutConstraint constraintWithItem: _signInButton attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _signInButton.superview attribute: NSLayoutAttributeLeading multiplier: 1. constant: 25];
    _loginLeftConstraint = leftConstraint;
    leftConstraint.active = YES;
    
    NSLayoutConstraint * rightConstraint = [NSLayoutConstraint constraintWithItem: _signInButton attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _signInButton.superview attribute: NSLayoutAttributeTrailing multiplier: 1. constant: -25];
    _loginRightConstraint = rightConstraint;
    rightConstraint.active = YES;
    
    [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        [self.view layoutIfNeeded];
    } completion: nil];
}


#pragma mark - 懒加载
- (NSArray<NSString *> *)records
{
    if (!_records) {
        NSMutableArray * records = @[].mutableCopy;
        for (NSInteger idx = 0; idx < 8; idx++) {
            [records addObject: [NSString stringWithFormat: @"record%02lu", idx]];
        }
        _records = records;
    }
    return _records;
}


#pragma mark - Text field delegate
/// 点击键盘return停止编辑
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 动画
/// 显示纪录列表
- (void)showRecordList
{
    _listTopConstraint.constant = _accountHeightConstraint.constant;
    _listHeightConstraint.constant = _accountHeightConstraint.constant * 5;
    [UIView animateWithDuration: 0.25 delay: 0 usingSpringWithDamping: 0.4 initialSpringVelocity: 5 options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations: ^{
        [self.view layoutIfNeeded];
    } completion: nil];
}

/// 隐藏纪录列表
- (void)hideRecordList
{
    _listTopConstraint.constant = 0;
    _listHeightConstraint.constant = 0;
    [UIView animateWithDuration: 0.25 animations: ^{
        [self.view layoutIfNeeded];
    } completion: nil];
}


#pragma mark - Table view data source
/// 返回列表个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.records.count;
}

/// 返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: [NSString stringWithFormat: @"cell"]];
    cell.textLabel.text = self.records[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate
/// 点击单元格隐藏列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _accountTextField.text = _passwordTextField.text = self.records[indexPath.row];
    [self animateToRotateArrow: YES];
    [self hideRecordList];
}


@end

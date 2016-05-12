//
//  ViewController.m
//  LXDBaseAnimation
//
//  Created by linxinda on 16/2/18.
//  Copyright © 2016年 sindriLin. All rights reserved.
//

#import "LXDSegmentControl.h"

#define OBSERVERKEY @"contentOffset"            ///<    监听属性
#define MAXMOVE 64.0                                        ///<    滚动最大值
#define TITLEMAXMOVE 16.0                              ///<    导航文本位移最大值
#define TOPANDBOTTOMCONSTANT 9              ///<    红色背景上下间距约束值

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *alphaContentView;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoCenterX;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.tableView addObserver: self forKeyPath: OBSERVERKEY options: NSKeyValueObservingOptionNew context: nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.tableView removeObserver: self forKeyPath: OBSERVERKEY];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.segmentControl;
}


#pragma mark - Getter
- (LXDSegmentControl *)segmentControl
{
    LXDSegmentControlConfiguration * configuration = [LXDSegmentControlConfiguration configurationWithItems: @[@"理数", @"文数", @"物理", @"化学"]];
    configuration.itemSelectedTextColor = configuration.slideBlockColor = [UIColor colorWithRed: 74/255. green: 200/255. blue: 250/255. alpha: 1.];
    configuration.backgroundColor = [UIColor groupTableViewBackgroundColor];
    LXDSegmentControl * segmentControl = [LXDSegmentControl segmentControlWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45) configuration: configuration delegate: nil];
    return segmentControl;
}


#pragma mark - Observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat yOffset = self.tableView.contentOffset.y / MAXMOVE;
    yOffset = MAX(0, MIN(1, yOffset));
    self.navigationTitle.alpha = 1 - yOffset;
    self.labelBottomConstraint.constant = yOffset * TITLEMAXMOVE;
    self.backgroundTopConstraint.constant = self.contentTopConstraint.constant = TOPANDBOTTOMCONSTANT - yOffset * MAXMOVE;
    self.infoCenterX.constant = TOPANDBOTTOMCONSTANT * yOffset;
}


@end

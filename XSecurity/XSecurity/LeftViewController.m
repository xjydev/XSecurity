//
//  LeftViewController.m
//  player
//
//  Created by XiaoDev on 2018/6/7.
//  Copyright © 2018 Xiaodev. All rights reserved.
//

#import "LeftViewController.h"
#import "DrawerViewController.h"
#import "XTools.h"
#define cellId @"leftcellId"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *mainArray;
@property (nonatomic, strong)UILabel *sizeLabel;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainArray =@[@[@{@"image":@"left_history",@"title":@"人脸解锁",@"tag":@(1)},@{@"image":@"left_setting",@"title":@"手势解锁",@"tag":@(2)},@{@"image":@"left_detail",@"title":@"重置解锁",@"tag":@(3)}],@[@{@"image":@"left_pay",@"title":@"关于应用",@"tag":@(4)},@{@"image":@"left_share",@"title":@"应用好评",@"tag":@(5)},@{@"image":@"left_feedback",@"title":@"意见反馈",@"tag":@(6)},],];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    [headerView addSubview:self.sizeLabel];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = kMainCOLOR;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 230, 80)];
        _sizeLabel.textColor = [UIColor whiteColor];
        _sizeLabel.font = [UIFont systemFontOfSize:15];
        _sizeLabel.numberOfLines = 2;
        _sizeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _sizeLabel;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mainArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.mainArray[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *dict = self.mainArray[indexPath.section][indexPath.row];
    UIImageView *imageView = [cell.contentView viewWithTag:300];
    UILabel *titleLabel = [cell.contentView viewWithTag:301];
    UISegmentedControl *segment = [cell viewWithTag:302];
    titleLabel.text =dict[@"title"];
    [imageView setImage:[UIImage imageNamed:dict[@"image"]]];
    segment.hidden = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.mainArray[indexPath.section][indexPath.row];
    [[DrawerViewController shareDrawer] closeLeftMenu];
    [[DrawerViewController shareDrawer] leftViewDidSelectedtag:[dict[@"tag"]integerValue]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma 转屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (IsPad) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
    
}
- (BOOL)shouldAutorotate {
    return YES;
}

@end

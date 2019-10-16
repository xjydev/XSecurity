//
//  LeftViewController.m
//  player
//
//  Created by XiaoDev on 2018/6/7.
//  Copyright © 2018 Xiaodev. All rights reserved.
//

#import "LeftViewController.h"
#import "DrawerViewController.h"
#import "SafeView.h"
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
    self.view.backgroundColor = kMainCOLOR;
    NSString *images0 = kDevice_Is_iPhoneX?@"left_0":@"left_01";
    NSString *names0 = kDevice_Is_iPhoneX?@"人脸解锁":@"指纹解锁";
    self.mainArray =@[@[@{@"image":images0,@"title":names0,@"tag":@(1),@"vtag":@"400"},@{@"image":@"left_06",@"title":@"手势解锁",@"tag":@(2),@"vtag":@"401"},@{@"image":@"left_02",@"title":@"重置解锁",@"tag":@(3),@"vtag":@"0"}],@[@{@"image":@"left_03",@"title":@"关于应用",@"tag":@(4),@"vtag":@"0"},@{@"image":@"left_04",@"title":@"应用好评",@"tag":@(5),@"vtag":@"0"},@{@"image":@"left_05",@"title":@"意见反馈",@"tag":@(6),@"vtag":@"0"},],];
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
    UISwitch *switchView = [cell viewWithTag:302];
    [switchView addTarget:self action:@selector(switchValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    titleLabel.text =dict[@"title"];
    [imageView setImage:[UIImage imageNamed:dict[@"image"]]];
    NSInteger vtag = [dict[@"vtag"]integerValue];
    if ( vtag >0) {
        switchView.hidden = NO;
        switchView.tag =vtag;
        if (vtag == 400) {//
          switchView.on = [kUSerD boolForKey:kTouchPassWord];
        }
        else if (vtag == 401) {
           switchView.on = ((NSString *)[kUSerD objectForKey:KPassWord]).length>0;
        }
    }
    else {
        switchView.hidden = YES;
    }
    return cell;
}
- (void)switchValueChangeAction:(UISwitch *)switchView {
    if (switchView.tag == 400) {
        if (switchView.on) {
            
            if ([SafeView defaultSafeView].supportTouchID) {
                if (![kUSerD objectForKey:KPassWord]) {
                   [SafeView defaultSafeView].type = PassWordTypeSet;
                }
                else
                {
                    [SafeView defaultSafeView].type = PassWordTypeDefault;
                }
                [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
                    if (num == 3) {
                        switchView.on = NO;
                    }
                    else {
                        [kUSerD setBool:YES forKey:kTouchPassWord];
                        [kUSerD synchronize];
                        [self.tableView reloadData];
                    }
                }];
            }
            else
            {
                [XTOOLS showMessage:kDevice_Is_iPhoneX?@"设备不支持人脸解锁":@"设备不支持指纹解锁"];
                switchView.on = NO;
            }
        }
        else
        {
            [kUSerD removeObjectForKey:kTouchPassWord];
            [kUSerD synchronize];
        }
    }
    else
        if (switchView.tag == 401) {
          if (switchView.on) {
                [SafeView defaultSafeView].type = PassWordTypeSet;
                [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
                    if (num == 3) {
                        switchView.on = NO;
                    }
                    
                }];
            }
            else
            {
                [SafeView defaultSafeView].type = PassWordTypeDefault;
                [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
                    NSLog(@"num == %@",@(num));
                    if (num == 1) {
                        [kUSerD removeObjectForKey:KPassWord];
                        [kUSerD removeObjectForKey:kTouchPassWord];
                        [kUSerD synchronize];
                        [self.tableView reloadData];
                    }
                }];
            }
        }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.mainArray[indexPath.section][indexPath.row];
    NSInteger tag = [dict[@"tag"]integerValue];
    if (tag == 3) {
        if ([kUSerD objectForKey:KPassWord]) {
           [SafeView defaultSafeView].type = PassWordTypeReset;
        }
        else {
           [SafeView defaultSafeView].type = PassWordTypeSet;
        }
        [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
            [self.tableView reloadData];
        }];
    }
    else {
        [[DrawerViewController shareDrawer] closeLeftMenu];
        [[DrawerViewController shareDrawer] leftViewDidSelectedtag:[dict[@"tag"]integerValue]];
    } 
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

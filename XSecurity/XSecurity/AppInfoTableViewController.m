//
//  AppInfoTableViewController.m
//  XSecurity
//
//  Created by XiaoDev on 2019/10/16.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "AppInfoTableViewController.h"
#import "XTools.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#include "sys/stat.h"

@interface AppInfoTableViewController ()
@property (nonatomic, strong)NSArray *mainArray;
@end

@implementation AppInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"应用详情";
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self reloadAppInformationDetail];
}
- (void)reloadAppInformationDetail {
    self.mainArray = @[@[@{@"title":@"应用名称",@"detail":@"密码宝"}],
                       @[@{@"title":@"应用版本",@"detail":APP_CURRENT_VERSION},
                         @{@"title":@"应用作者",@"detail":@"JingYuan Xiao"},
                         @{@"title":@"应用声明",@"detail":@"如果涉及侵权行为，请联系作者"},
                         @{@"title":@"隐私条款",@"detail":@"点击查看详情"},
                         @{@"title":@"联系方式",@"detail":@"xiaodeve@163.com"}],
                       ];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return self.mainArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
NSArray *arr = self.mainArray[section];
return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appinfocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"appinfocell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.mainArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = dict[@"detail"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _mainArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {//隐私条款
        if ([dict[@"title"] isEqualToString:@"隐私条款"]) {
            NSString * urlStr = @"http://xiaodev.com/2018/09/06/privacy/";
            [XTOOLS openURLStr:urlStr];
        }
    }
}

@end

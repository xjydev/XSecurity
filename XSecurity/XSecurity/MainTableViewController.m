//
//  MainTableViewController.m
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "MainTableViewController.h"
#import "DrawerViewController.h"
#import "DetailViewController.h"
#import "XTools.h"
#import "XDataBaseManager.h"

@interface MainTableViewCell ()
@property (nonatomic, strong)SecurityModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end
@implementation MainTableViewCell
- (void)setModel:(SecurityModel *)model {
    _model = model;
    NSString *imagestr = model.icon;
    if (imagestr.length == 0) {
        imagestr = @"ximage_0";
    }
    [self.iconImageView setImage:[UIImage imageNamed:imagestr]];
    self.showButton.selected = NO;
    self.nameLabel.text = model.name;
    if (_model.passWord.length == 0) {
       self.contentLabel.text = [NSString stringWithFormat:@"%@:密码处于加密状态",model.account];
    }
    else {
       self.contentLabel.text = [NSString stringWithFormat:@"%@:%@",model.account,[self showPassword:self.showButton.selected]];
    }
   
}
- (IBAction)showButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.model.passWord.length == 0) {
        self.model.passWord = [XTOOLS decryptAes256WithData:self.model.passwordData Key:kENKEY];
    }
  self.contentLabel.text = [NSString stringWithFormat:@"%@:%@",self.model.account,[self showPassword:self.showButton.selected]];
}

- (NSString *)showPassword:(BOOL)is {
    NSString *password = self.model.passWord;
    NSMutableString *mstr = [NSMutableString stringWithString:password];
    if (!is) {
        mstr = [NSMutableString string];
        while (mstr.length < password.length) {
            [mstr appendFormat:@"*"];
        }
    }
    NSInteger i = 1;
    while ((i*4) < password.length) {
        if ((i*4+(i-1)) < mstr.length) {
         [mstr insertString:@" " atIndex:i*4+(i-1)];
        }
        i++;
    }
    return mstr;
}
@end

@interface MainTableViewController ()
@property (nonatomic, strong)NSArray *mainArray;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStyleDone target:self action:@selector(addSecurityAction)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self refreshTableView];
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshPullUp:) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = refresh;
    } else {
        [self.tableView addSubview:refresh];
    }
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:0.5];
}
- (void)showAlert {
   if (self.mainArray.count == 0) {
        [self performSegueWithIdentifier:@"AlertViewController" sender:nil];
    }
}
- (void)addSecurityAction {
    [self performSegueWithIdentifier:@"DetailViewController" sender:nil];
}
- (void)leftBarButtonItemAction {
    DrawerViewController *drawerVC = (DrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [drawerVC openLeftMenu];
}
- (void)refreshPullUp:(UIRefreshControl *)rc {
    [self refreshTableView];
    [self performSelector:@selector(endRefresh:) withObject:rc afterDelay:0.8];
}
- (void)endRefresh:(UIRefreshControl *)rc {
    [rc endRefreshing];
}
- (void)refreshTableView {
    self.mainArray = [[XDataBaseManager defaultManager]getAllSecurity];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCellId" forIndexPath:indexPath];
    SecurityModel *model = self.mainArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(NSArray *)tableView:(UITableView* )tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecurityModel *model = self.mainArray[indexPath.row];
    @weakify(self)
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        @strongify(self);
        [[XDataBaseManager defaultManager]deleteSecurityModel:model];
        [self refreshTableView];
        }];
//    UITableViewRowAction *detailRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"详情" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
//        @strongify(self);
//
//    }];
//    detailRoWAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];
    return @[deleteRoWAction];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SecurityModel *model = self.mainArray[indexPath.row];
    [self performSegueWithIdentifier:@"DetailViewController" sender:model];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        DetailViewController *detail = segue.destinationViewController;
        @weakify(self);
        detail.completeBack = ^(NSInteger status) {
            @strongify(self);
            [self refreshTableView];
        };
        detail.model = sender;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
@end

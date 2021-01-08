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
#import "SafeView.h"

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
    self.contentLabel.text = [NSString stringWithFormat:@"%@:%@",model.account,[self showPassword:self.showButton.selected]]; 
}
- (IBAction)showButtonAction:(UIButton *)sender {
    if (self.model.level > 0 && !sender.isSelected) {
        if ([kUSerD objectForKey:KPassWord]) {
            [SafeView defaultSafeView].type = PassWordTypeDefault;
            [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
                NSLog(@"num1 == %@",@(num));
                if (num != 3) {//不是取消
                  [self showPassWordWithButton:sender];
                }
            }];
        }
        else {
            [XTOOLS showAlertTitle:@"无法验证，是否显示？" message:@"没有设置应用锁，无法二次验证。可去设置中打开应用锁，使用密码二次验证功能。" buttonTitles:@[@"取消",@"显示"] completionHandler:^(NSInteger num) {
                if (num == 1) {
                    [self showPassWordWithButton:sender];
                }
            }];
        }
    }
    else {
        [self showPassWordWithButton:sender];
    }
}
- (void)showPassWordWithButton:(UIButton *)button {
    button.selected = !button.selected;
       if (self.model.passWord.length == 0) {
           self.model.passWord = [XTOOLS decryptAes256WithData:self.model.passwordData Key:kENKEY];
       }
     self.contentLabel.text = [NSString stringWithFormat:@"%@:%@",self.model.account,[self showPassword:self.showButton.selected]];
}
- (NSString *)showPassword:(BOOL)is {
    NSString *password = self.model.passWord;
    if (password == nil) {
        return  @"密码处于加密状态";
    }
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

@interface MainTableViewController ()<UISearchControllerDelegate,UISearchResultsUpdating>
@property (nonatomic, strong)NSArray *mainArray;
@property (nonatomic, strong)NSMutableArray *searchArray;
@property (strong, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, strong) UILabel *searchFootLabel;
@property (nonatomic, strong)UISearchController *searchController;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStyleDone target:self action:@selector(addSecurityAction)];
    [self refreshTableView];
    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshPullUp:) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = refresh;
    } else {
        [self.tableView addSubview:refresh];
    }
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:0.5];
    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.barTintColor = kCOLOR(0xf1f1f1, 0x222222);
    self.searchController.searchBar.tintColor = kMainCOLOR;
    self.searchController.searchBar.placeholder= @"请输入标题/账号";
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext=YES;
}
- (UILabel *)searchFootLabel {
    if (!_searchFootLabel) {
        _searchFootLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
        _searchFootLabel.textAlignment = NSTextAlignmentCenter;
        _searchFootLabel.text = @"请搜索密码“名称”和“账号”";
        _searchFootLabel.font = [UIFont systemFontOfSize:18];
        _searchFootLabel.textColor = [UIColor lightGrayColor];
    }
    return _searchFootLabel;
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
   NSArray *dataArray  = [[XDataBaseManager defaultManager]getAllSecurity];
    self.mainArray = [dataArray sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(SecurityModel *  _Nonnull obj1, SecurityModel *  _Nonnull obj2) {
        if (obj1.top > obj2.top) {
            return NSOrderedDescending;
        }
        else if(obj1.top == obj2.top){
            return [obj1.modifyDate compare:obj2.modifyDate];
        }
        return NSOrderedSame;
        
    }];
    [self.tableView reloadData];
    if (self.mainArray.count == 0) {
        self.tableView.tableFooterView = self.noDataView;
    }
    else {
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
}
- (IBAction)createSecurityButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"DetailViewController" sender:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchArray.count;
    }
    else {
       return self.mainArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCellId" forIndexPath:indexPath];
    if (self.searchController.active) {
        SecurityModel *model = self.searchArray[indexPath.row];
        cell.model = model;
    }
    else {
        SecurityModel *model = self.mainArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(NSArray *)tableView:(UITableView* )tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecurityModel *model = nil;
    if (self.searchController.active) {
        model = self.searchArray[indexPath.row];
    }
    else {
        model =self.mainArray[indexPath.row];
    }
    @weakify(self)
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        NSString *message = [NSString stringWithFormat:@"确认删除‘%@’？删除将无法恢复。",model.name];
        [XTOOLS showAlertTitle:@"确认删除" message:message buttonTitles:@[@"取消",@"删除"] completionHandler:^(NSInteger num) {
            @strongify(self);
            if (num == 1) {
                [self deleteModel:model];
            }
        }];
    }];
    NSString *topTitle = model.top == 1? @"取消置顶":@"置顶";
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:topTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        [self makeTopModel:model];
    }];
    topAction.backgroundColor = [UIColor blueColor];
    return @[deleteRoWAction,topAction];
}
- (void)makeTopModel:(SecurityModel *)model {
    NSString *msg = nil;
    if (model.top == 1) {
        model.top = 0;
        msg = @"取消置顶失败";
    }
    else {
        model.top = 1;
        msg = @"置顶失败";
    }
    BOOL ret = [[XDataBaseManager defaultManager]updateSecurityModel:model];
    if (ret) {
        [self refreshTableView];
    }
    else {
        [XTOOLS showMessage:msg];
    }
}
- (void)deleteModel:(SecurityModel *)model {
    
    [[XDataBaseManager defaultManager]deleteSecurityModel:model];
    if (self.searchController.active) {
        if ([self.searchArray containsObject:model]) {
            [self.searchArray removeObject:model];
            [self.tableView reloadData];
        }
    }
    else {
       [self refreshTableView];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   SecurityModel *model = nil;
    if (self.searchController.active) {
        model = self.searchArray[indexPath.row];
    }
    else {
        model =self.mainArray[indexPath.row];
    }
    MainTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (model.level > 0 && !cell.showButton.selected ) {
       if ([kUSerD objectForKey:KPassWord]) {
            [SafeView defaultSafeView].type = PassWordTypeDefault;
            [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
                NSLog(@"num1 == %@",@(num));
                if (num != 3) {//不是取消
                  [self performSegueWithIdentifier:@"DetailViewController" sender:model];
                }
            }];
        }
        else {
            [XTOOLS showAlertTitle:@"无法验证，是否打开？" message:@"没有设置应用锁，无法二次验证。可去设置中打开应用锁，使用密码二次验证功能。" buttonTitles:@[@"取消",@"打开"] completionHandler:^(NSInteger num) {
                if (num == 1) {
                    [self performSegueWithIdentifier:@"DetailViewController" sender:model];
                }
            }];
        }
    }
    else {
       [self performSegueWithIdentifier:@"DetailViewController" sender:model];
    }
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
#pragma mark -- search
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    [self.searchArray removeAllObjects];
    for (SecurityModel *mo in self.mainArray) {
        if ([preicate evaluateWithObject:mo.name] || [preicate evaluateWithObject:mo.account]) {
            [self.searchArray addObject:mo];
        }
    }
    if (self.searchArray.count == 0) {
        self.tableView.tableFooterView = self.searchFootLabel;
    }
    else {
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
    [self.tableView reloadData];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    [self refreshTableView];
}
- (void)didDismissSearchController:(UISearchController *)searchController {
   if (self.mainArray.count == 0) {
        self.tableView.tableFooterView = self.noDataView;
    }
    else {
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
}
@end

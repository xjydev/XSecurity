//
//  DetailViewController.m
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "DetailViewController.h"
#import "XTools.h"
#import "SecurityModel.h"
#import "XDataBaseManager.h"
#import "SelectImageViewController.h"
#import "SafeView.h"
@interface DetailViewController ()<UITextFieldDelegate,UIPopoverPresentationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *complexLabel;
@property (weak, nonatomic) IBOutlet UIView *complexView1;
@property (weak, nonatomic) IBOutlet UIView *complexView2;
@property (weak, nonatomic) IBOutlet UIView *complexView3;
@property (nonatomic,copy) NSString * iconStr;
@property (weak, nonatomic) IBOutlet UISwitch *verifySwitch;
@property (weak, nonatomic) IBOutlet UILabel *editTimeLabel;

@property (nonatomic, copy)NSString *passWorkStr;//密码的明码
@property (nonatomic, assign)BOOL canEdit;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
}
- (void)setUpViews {
    self.nameTextField.leftView = [self createLeftLabellWithText:@"  名称:  "];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.backgroundColor = kGray1Color;
    self.accountTextField.leftView = [self createLeftLabellWithText:@"  账号:  "];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.backgroundColor = kGray1Color;
    
    self.passwordTextField.leftView = [self createLeftLabellWithText:@"  密码:  "];
    self.passwordTextField.backgroundColor = kGray1Color;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.rightView = self.showButton;
    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.remarkTextView.backgroundColor = kGray1Color;
    self.iconButton.backgroundColor = kGray1Color;
    [self.backScrollView addSubview:self.remarkTextView];
    
    if (self.model) {//编辑
        self.title = @"密码详情";
        self.canEdit = NO;
        self.saveButton.hidden = YES;
        [self.saveButton setTitle:@"更新" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editBarButtonAction:)];
        self.nameTextField.text = self.model.name;
        self.accountTextField.text = self.model.account;
        self.passwordTextField.text = [self showPassword:self.showButton.selected];
        self.remarkTextView.text = self.model.remark;
        self.iconStr = self.model.icon;
        self.verifySwitch.on = self.model.level;
        if (self.model.passWord.length > 0) {
            self.passWorkStr = self.model.passWord;
        }
        if (self.model.modifyDate) {
            self.editTimeLabel.text = [NSString stringWithFormat:@"上次修改：%@",[XTOOLS timeStrFromDate:self.model.modifyDate]];
        }
        else {
            self.editTimeLabel.text = @"";
        }
    }
    else {
        self.title = @"添加密码";
        [self.saveButton setTitle:@"添加" forState:UIControlStateNormal];
        self.saveButton.hidden = NO;
        self.showButton.selected = YES;
        self.canEdit = YES;
        self.editTimeLabel.text = @"";
    }
    if (self.iconStr.length == 0) {
        self.iconStr = @"ximage_0";
    }
    [self.iconButton setImage:[UIImage imageNamed:self.iconStr] forState:UIControlStateNormal];
    [self judgePassWord:self.passwordTextField.text];
}
- (UITextView *)remarkTextView {
    if (!_remarkTextView) {
        _remarkTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 415, kScreen_Width - 40, 100)];
        _remarkTextView.backgroundColor = kCOLOR(0x7676801e, 0x7676803d);
        _remarkTextView.font = [UIFont systemFontOfSize:17];
        _remarkTextView.textColor = kDarkCOLOR(0x000000);
        _remarkTextView.delegate = self;
    }
    return _remarkTextView;
}
- (void)editBarButtonAction:(UIBarButtonItem *)bar {
    if (self.canEdit) {
        [self saveButtonAction:nil];
    }
    else {
        self.canEdit = YES;
        [bar setTitle:@"完成"];
        self.title = @"编辑详情";
        self.saveButton.hidden = NO;
    }
}
- (UILabel *)createLeftLabellWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = kDarkCOLOR(0x000000);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.canEdit) {
        [XTOOLS showMessage:@"点击右上角开始编辑"];
    }
    return self.canEdit;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.passwordTextField) {
        NSMutableString *mstr = [[NSMutableString alloc]initWithString:textField.text];
        [mstr replaceCharactersInRange:range withString:string];
        [self judgePassWord:mstr];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!self.canEdit) {
           [XTOOLS showMessage:@"点击右上角开始编辑"];
       }
    return self.canEdit;
}

- (IBAction)selectImageButtonAction:(UIButton *)sender {
    if (!self.canEdit) {
        [XTOOLS showMessage:@"点击右上角开始编辑"];
    }
    SelectImageViewController *selectVC = [[SelectImageViewController alloc]init]; 
    selectVC.modalPresentationStyle = UIModalPresentationPopover;
    selectVC.popoverPresentationController.sourceView = sender;
    selectVC.popoverPresentationController.sourceRect = sender.bounds;
    selectVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    selectVC.popoverPresentationController.delegate = self;
    selectVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    selectVC.preferredContentSize = CGSizeMake(250, 250);
    @weakify(self);
    selectVC.selectedBack = ^(NSInteger index) {
        @strongify(self);
        
        self.iconStr = [NSString stringWithFormat:@"ximage_%d",(int)index];
        [self.iconButton setImage:[UIImage imageNamed:self.iconStr] forState:UIControlStateNormal];
    };
    [self presentViewController:selectVC animated:YES completion:nil];

}
- (IBAction)verifySwitchAction:(UISwitch *)sender {
    if (!self.canEdit) {
        [XTOOLS showMessage:@"点击右上角开始编辑"];
        sender.on = self.model.level;
    }
    else if (sender.on == 1 && ![kUSerD objectForKey:KPassWord]) {//没有设置应用锁
        [XTOOLS showAlertTitle:@"是否设置应用锁？" message:@"设置应用锁，才能使用二次验证。" buttonTitles:@[@"取消",@"设置"] completionHandler:^(NSInteger num) {
            if (num == 1) {
                [self setPasswordWithSwitch:sender];
            }
            else {
                sender.on = NO;
            }
        }];
    }
    
}
- (void)setPasswordWithSwitch:(UISwitch *)switchView {
    [SafeView defaultSafeView].type = PassWordTypeSet;
    [[SafeView defaultSafeView] showSafeViewHandle:^(NSInteger num) {
        if (num == 3) {
            switchView.on = NO;
            [XTOOLS showMessage:@"设置失败"];
        }
        else {
            [XTOOLS showAlertTitle:@"请牢记密码" message:@"应用不包括用户注册，不存储用户信息,请牢记解锁密码，遗忘将无法找回！" buttonTitles:@[@"知道了"] completionHandler:^(NSInteger num) {
                [kNOtificationC postNotificationName:@"leftvcRefresh" object:nil];
            }];
        }
    }];
}
- (IBAction)showButtonAction:(UIButton *)sender {
    if (self.passwordTextField.text.length == 0) {
        [XTOOLS showMessage:@"请输入密码"];
        return;
    }
    if (sender.selected) {
        self.passWorkStr = self.passwordTextField.text;
    }
    [self showPassWordWithButton:sender];
       
}
- (void)showPassWordWithButton:(UIButton *)button {
    button.selected = !button.selected;
       if (self.model.passWord.length == 0 && self.model.passwordData) {
           self.passWorkStr = [XTOOLS decryptAes256WithData:self.model.passwordData Key:kENKEY];
           self.model.passWord = self.passWorkStr;
       }
     self.passwordTextField.text =[self showPassword:self.showButton.selected];
    [self judgePassWord:self.passwordTextField.text];
}
- (NSString *)showPassword:(BOOL)is {
    NSString *password = self.passWorkStr;
    if (password == nil) {
        return @"密码处于加密状态";
    }
    NSMutableString *mstr = [NSMutableString stringWithString:password];
    if (!is) {
        mstr = [NSMutableString string];
        while (mstr.length < password.length) {
            [mstr appendFormat:@"*"];
        }
        NSInteger i = 1;
        while ((i*4) < password.length) {
            if ((i*4+(i-1)) < mstr.length) {
             [mstr insertString:@" " atIndex:i*4+(i-1)];
            }
            i++;
        }
    }
    
    return mstr;
}
- (IBAction)saveButtonAction:(id)sender {
    if (self.nameTextField.text.length == 0) {
        [XTOOLS showMessage:@"请输入名称"];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
           [XTOOLS showMessage:@"请输入密码"];
           return;
       }
    if (self.model) {
        [XTOOLS showAlertTitle:@"确认更新？" message:nil buttonTitles:@[@"取消",@"确认"] completionHandler:^(NSInteger num) {
            if (num == 1) {
                self.model.name = self.nameTextField.text;
                self.model.icon = self.iconStr;
                if (self.showButton.selected) {//如果是可视的，就直接输入框。
                  self.model.passWord = self.passwordTextField.text;
                }
                else {
                    self.model.passWord = self.passWorkStr;
                }
                
                self.model.account = self.accountTextField.text;
                self.model.remark = self.remarkTextView.text;
                self.model.modifyDate = [NSDate date];
                self.model.level = self.verifySwitch.on;
             BOOL result = [[XDataBaseManager defaultManager]updateSecurityModel:self.model];
                if (result) {
                    [XTOOLS showMessage:@"更新成功"];
                    if (self.completeBack) {
                        self.completeBack(1);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [XTOOLS showMessage:@"更新失败"];
                }
            }
        }];
    }
    else {
        SecurityModel *mo = [[SecurityModel alloc]init];
        mo.name = self.nameTextField.text;
        mo.icon = self.iconStr;
        
        if (self.showButton.selected) {//如果是可视的，就直接输入框。
            mo.passWord = self.passwordTextField.text;
        }
        else {
            mo.passWord = self.passWorkStr;
        }
        
        mo.account = self.accountTextField.text;
        mo.remark = self.remarkTextView.text;
        mo.level = self.verifySwitch.on;
        mo.createDate = [NSDate date];
        mo.modifyDate = [NSDate date];
        BOOL result = [[XDataBaseManager defaultManager]saveSecurityModel:mo];
        if (result) {
            if (self.completeBack) {
                self.completeBack(1);
            }
            [XTOOLS showMessage:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [XTOOLS showMessage:@"保存失败"];
        } 
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
}
#pragma mark -- 判断密码复杂度
- (void)judgePassWord:(NSString *)password {
   NSInteger level = [self judgePasswordStrength:password];
    switch (level) {
        case 0:
            {
                self.complexLabel.text = @"";
                self.complexLabel.textColor = [UIColor grayColor];
                self.complexLabel.hidden = YES;
                self.complexView1.backgroundColor = [UIColor clearColor];
                self.complexView2.backgroundColor = [UIColor clearColor];
                self.complexView3.backgroundColor = [UIColor clearColor];
            }
            break;
            case 1:
            {
                self.complexLabel.text = @"简单";
                self.complexLabel.textColor = [UIColor redColor];
                self.complexLabel.hidden = NO;
                self.complexView1.backgroundColor = [UIColor redColor];
                self.complexView2.backgroundColor = [UIColor clearColor];
                self.complexView3.backgroundColor = [UIColor clearColor];
            }
            break;
            case 2:
            {
               self.complexLabel.text = @"一般";
                self.complexLabel.textColor = kMainCOLOR;
                self.complexLabel.hidden = NO;
                self.complexView1.backgroundColor = kMainCOLOR;
                self.complexView2.backgroundColor = kMainCOLOR;
                self.complexView3.backgroundColor = [UIColor clearColor];
            }
            break;
            case 3:
            {
                self.complexLabel.text = @"复杂";
                self.complexLabel.textColor = [UIColor greenColor];
                self.complexLabel.hidden = NO;
                self.complexView1.backgroundColor = [UIColor greenColor];
                self.complexView2.backgroundColor = [UIColor greenColor];
                self.complexView3.backgroundColor = [UIColor greenColor];
            }
            break;
            
        default:
            break;
    }
}
- (BOOL) judgeRange:(NSArray*) termArray Password:(NSString*) password {
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[termArray count]; i++) {
        range = [password rangeOfString:[termArray objectAtIndex:i]];
         if (range.location != NSNotFound) {
            result =YES;
        }
    }
    return result;
}
- (NSInteger) judgePasswordStrength:(NSString*)password {
    if (password.length == 0) {
        return 0;
    }
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];

    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];

    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];

    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];



    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:password]];

    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:password]];

    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:password]];

    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:password]];

    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];

    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];

    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];

    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    int intResult=0;

    for (int j=0; j<[resultArray count]; j++)

    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])

        {
            intResult++;
        }
    }

    if (intResult <2)
    {
        return 1;
    }

    else if (intResult == 2&&[password length]>=6)
    {
        return 2;
    }

    if (intResult > 2&&[password length]>=6)
    {
        return 3;
    }
    return 0;
}
#pragma mark -- UIPopoverPresentationControllerDelegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

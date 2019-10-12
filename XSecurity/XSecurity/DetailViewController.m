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
@interface DetailViewController ()<UITextFieldDelegate,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@property (weak, nonatomic) IBOutlet UILabel *complexLabel;
@property (weak, nonatomic) IBOutlet UIView *complexView1;
@property (weak, nonatomic) IBOutlet UIView *complexView2;
@property (weak, nonatomic) IBOutlet UIView *complexView3;
@property (nonatomic,copy) NSString * iconStr;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
}
- (void)setUpViews {
    self.nameTextField.leftView = [self createLeftLabellWithText:@"名称:"];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.backgroundColor = kGray1Color;
    self.accountTextField.leftView = [self createLeftLabellWithText:@"账号:"];
    self.accountTextField.leftViewMode = UITextFieldViewModeAlways;
    self.accountTextField.backgroundColor = kGray1Color;
    
    self.passwordTextField.leftView = [self createLeftLabellWithText:@"密码:"];
    self.passwordTextField.backgroundColor = kGray1Color;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.remarkTextView.backgroundColor = kGray1Color;
    self.iconButton.backgroundColor = kGray1Color;
//    self.passwordTextField.rightView = self.showButton;
//    self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    if (self.model) {
        self.nameTextField.text = self.model.name;
        self.accountTextField.text = self.model.account;
        self.passwordTextField.text = self.model.passWord;
        self.remarkTextView.text = self.model.remark;
        self.iconStr = self.model.icon;
    }
    if (self.iconStr.length == 0) {
        self.iconStr = @"ximage_0";
    }
    [self.iconButton setImage:[UIImage imageNamed:self.iconStr] forState:UIControlStateNormal];
    [self judgePassWord:self.passwordTextField.text];
}
- (UILabel *)createLeftLabellWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = kBACKCOLOR;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *mstr = [[NSMutableString alloc]initWithString:textField.text];
    [mstr replaceCharactersInRange:range withString:string];
    [self judgePassWord:mstr];
    return YES;
}
- (IBAction)selectImageButtonAction:(UIButton *)sender {
    SelectImageViewController *selectVC = [[SelectImageViewController alloc]init]; 
    selectVC.modalPresentationStyle = UIModalPresentationPopover;
    selectVC.popoverPresentationController.sourceView = sender;
    selectVC.popoverPresentationController.sourceRect = sender.bounds;
    selectVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    selectVC.popoverPresentationController.delegate = self;
    selectVC.popoverPresentationController.backgroundColor = [UIColor whiteColor];
    selectVC.preferredContentSize = CGSizeMake(225, 225);
    @weakify(self);
    selectVC.selectedBack = ^(NSInteger index) {
        @strongify(self);
        
        self.iconStr = [NSString stringWithFormat:@"ximage_%d",(int)index];
        [self.iconButton setImage:[UIImage imageNamed:self.iconStr] forState:UIControlStateNormal];
    };
    [self presentViewController:selectVC animated:YES completion:nil];

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
                self.model.passWord = self.passwordTextField.text;
                self.model.account = self.accountTextField.text;
                self.model.remark = self.remarkTextView.text;
                self.model.modifyDate = [NSDate date];
             BOOL result = [[XDataBaseManager defaultManager]updateSecurityModel:self.model];
                if (result) {
                    [XTOOLS showMessage:@"更新成功"];
                }
                else {
                    [XTOOLS showMessage:@"更新失败"];
                }
            }
        }];
    }
    else {
        [XTOOLS showAlertTitle:@"确认保存？" message:nil buttonTitles:@[@"取消",@"确认"] completionHandler:^(NSInteger num) {
            if (num == 1) {
                SecurityModel *mo = [[SecurityModel alloc]init];
                mo.name = self.nameTextField.text;
                mo.icon = self.iconStr;
                mo.passWord = self.passwordTextField.text;
                mo.account = self.accountTextField.text;
                mo.remark = self.remarkTextView.text;
                mo.createDate = [NSDate date];
                mo.modifyDate = [NSDate date];
                NSLog(@"mo == %@",mo);
                BOOL result = [[XDataBaseManager defaultManager]saveSecurityModel:mo];
                if (result) {
                    [XTOOLS showMessage:@"保存成功"];
                }
                else {
                    [XTOOLS showMessage:@"保存失败"];
                }
            }
        }];
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

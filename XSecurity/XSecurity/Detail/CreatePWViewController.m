//
//  CreatePWViewController.m
//  XSecurity
//
//  Created by XiaoDev on 2021/5/5.
//  Copyright © 2021 XiaoDev. All rights reserved.
//

#import "CreatePWViewController.h"
#import "XTools.h"
@interface CreatePWViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *lowerButton;
@property (weak, nonatomic) IBOutlet UIButton *upperButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UIButton *specialButton;
@property (weak, nonatomic) IBOutlet UITextField *lengthTextField;
@property (weak, nonatomic) IBOutlet UITextView *pwTextView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *CompleteButton;

@end

@implementation CreatePWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.createComplete) {
        self.CompleteButton.hidden = NO;
    }
    else {
        self.CompleteButton.hidden = YES;
    }
}
- (IBAction)CompleteButtonAction:(UIButton *)sender {
    if (self.pwTextView.text.length > 0) {
        if (self.createComplete) {
            self.createComplete(self.pwTextView.text);
            self.createComplete = nil;
        }
        [self dismissViewControllerAnimated:YES completion:^{
                    
        }];
    }
    else {
        [XTOOLS showMessage:@"请生成密码"];
    }
}
- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}
- (IBAction)topButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)createButtonAction:(id)sender {
    self.pwTextView.text = [self createPassWord];
}
- (IBAction)copyButtonAction:(id)sender {
    if (self.pwTextView.text.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.pwTextView.text;
        [XTOOLS showMessage:@"复制成功"];
    }
    else {
        [XTOOLS showMessage:@"没有密码"];
    }
}
- (NSString *)createPassWord {
    if ([self.lengthTextField.text intValue] == 0) {
        [XTOOLS showMessage:@"请输入密码长度"];
        return nil;
    }
    if (!self.lowerButton.selected &&!self.upperButton.selected &&!self.numberButton.selected &&!self.specialButton.selected ) {
        [XTOOLS showMessage:@"请选择字符类型"];
        return nil;
    }
    NSString *lowercaseChars = @"abcdefghijklmnopqrstuvwxyz";
    NSString *uppercaseChars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *numberChars = @"0123456789";
    NSString *puntuationChars = @"@~!?#%^&*()";
    NSMutableString *allStr = [NSMutableString string];
    if (self.lowerButton.selected) {
        [allStr appendString:lowercaseChars];
    }
    if (self.upperButton.selected) {
        [allStr appendString:uppercaseChars];
    }
    if (self.numberButton.selected) {
        [allStr appendString:numberChars];
    }
    if (self.specialButton.selected) {
        [allStr appendString:puntuationChars];
    }
    NSMutableString *pwStr = [NSMutableString string];
    int pwLength = self.lengthTextField.text.intValue;
//    NSMutableArray *locationArr = [NSMutableArray arrayWithCapacity:pwLength];
    for (int i = 0; i< pwLength; i++) {
        NSInteger loc = arc4random()%allStr.length;
        [pwStr appendString:[allStr substringWithRange:NSMakeRange(loc, 1)]];
        
    }
    return pwStr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.lengthTextField resignFirstResponder];
    [self.pwTextView resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.intValue > 128) {
        textField.text = @"128";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
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

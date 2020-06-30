//
//  AlertViewController.m
//  XSecurity
//
//  Created by XiaoDev on 2019/10/16.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "AlertViewController.h"
#import "UIColor+Hex.h"
@interface AlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setParagraphSpacing:8];  //调整段间距
    [paragraphStyle setHeadIndent:15.0];
    self.contentLabel.attributedText =[[NSAttributedString alloc]initWithString:@"1. 本应用不收集任何用户信息，你可以在手机的设置中关闭本应用的网络，不会影响本应用的使用。\n2.本应用采用双层数据加密，使对数据的获取和破解变的十分困难的。但不保证可以抵抗所有专业团队的暴利破解。\n3. 你可以在左上角的“设置”中打开应用锁，使应用更安全。点击右上角的“加号”，可以添加需要管理的密码。\n4.添加密码后，点击眼睛可以显示隐藏密码，左滑可以删除密码。\n5.使用中如遇到问题，或者有好的建议，请联系邮箱：xiaodeve@163.com。" attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:kCOLOR(0x222222, 0xeeeeee),NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}
- (IBAction)bottomButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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

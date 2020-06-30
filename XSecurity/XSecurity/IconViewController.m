//
//  IconViewController.m
//  XSecurity
//
//  Created by XiaoDev on 2020/6/30.
//  Copyright © 2020 XiaoDev. All rights reserved.
//

#import "IconViewController.h"
#import "XTools.h"
@interface IconViewController ()

@end

@implementation IconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)iconButtonAction:(UIButton *)sender {
    NSString *iconstr = [NSString stringWithFormat:@"icon%d",(int)sender.tag - 300];
    if (@available(iOS 10.3, *)) {
        if ([[UIApplication sharedApplication]supportsAlternateIcons]) {
            [[UIApplication sharedApplication]setAlternateIconName:iconstr completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    [XTOOLS showMessage:@"设置失败"];
                }
                else {
//                   [XTOOLS showMessage:@"设置成功"];
                }
            }];
        } else {
            [XTOOLS showMessage:@"设置失败"];
        }
    } else {
       [XTOOLS showMessage:@"设置失败"];
    }
    [self performSelector:@selector(dismissVC) withObject:nil afterDelay:0.5];
}
- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)restoreButtonAction:(id)sender {
    if (@available(iOS 10.3, *)) {
        if ([[UIApplication sharedApplication]supportsAlternateIcons]) {
            [[UIApplication sharedApplication]setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                if (!error) {
//                  [XTOOLS showMessage:@"图标已还原"];
                }
                else {
                    [XTOOLS showMessage:@"还原失败"];
                }
            }];
        } else {
            [XTOOLS showMessage:@"还原失败"];
        }
    } else {
        [XTOOLS showMessage:@"还原失败"];
    }
    
    [self performSelector:@selector(dismissVC) withObject:nil afterDelay:0.5];
}
- (void)dismissVC {
//   [self dismissViewControllerAnimated:YES completion:nil];
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

//
//  CreatePWViewController.h
//  XSecurity
//
//  Created by XiaoDev on 2021/5/5.
//  Copyright © 2021 XiaoDev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreatePWViewController : UIViewController
@property (nonatomic, copy,nullable)void (^ createComplete)(NSString *pwStr);
@end

NS_ASSUME_NONNULL_END

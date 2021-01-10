//
//  DetailViewController.h
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecurityModel;
NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, copy)void (^completeBack)(NSInteger status);
@property (nonatomic, strong)SecurityModel *model;
@end

NS_ASSUME_NONNULL_END

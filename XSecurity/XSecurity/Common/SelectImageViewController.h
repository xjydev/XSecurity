//
//  SelectImageViewController.h
//  XSecurity
//
//  Created by XiaoDev on 2019/10/12.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectImageViewController : UIViewController
@property (nonatomic, copy)void (^selectedBack)(NSInteger index);
@end

NS_ASSUME_NONNULL_END

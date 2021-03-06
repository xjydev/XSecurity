//
//  SecurityModel.h
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityModel : NSObject
@property (nonatomic, copy) NSString     *name;//密码名称
@property (nonatomic, copy) NSString     *icon;//密码图标
@property (nonatomic, copy) NSString     *account;//账号名称
@property (nonatomic, copy) NSString     *passWord;//密码
@property (nonatomic, strong)NSData      *passwordData;//密码加密
@property (nonatomic, copy) NSString     *remark;//备注
@property (nonatomic, strong) NSDate     *createDate;//创建时间
@property (nonatomic, strong) NSDate     *modifyDate;//修改时间
@property (nonatomic, assign) NSInteger   level;//安全等级
@property  (nonatomic, assign)NSInteger   securityId;//密码id
@property (nonatomic, assign)NSInteger type;//密码分类。
@property (nonatomic, assign)NSInteger top;//置顶。
@end


//
//  XDataBaseManager.h
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecurityModel.h"
#define KTableName @"securitymodel"

NS_ASSUME_NONNULL_BEGIN

@interface XDataBaseManager : NSObject
+ (instancetype)defaultManager;
- (NSArray *)getAllSecurity;
- (BOOL)deleteSecurityModel:(SecurityModel *)model;
- (BOOL)saveSecurityModel:(SecurityModel *)model;
- (BOOL)updateSecurityModel:(SecurityModel *)model;
@end

NS_ASSUME_NONNULL_END

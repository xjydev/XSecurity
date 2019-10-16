//
//  SecurityModel.m
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "SecurityModel.h"
#import <WCDB/WCDB.h>
@implementation SecurityModel

WCDB_IMPLEMENTATION(SecurityModel)

WCDB_SYNTHESIZE(SecurityModel, name)
WCDB_SYNTHESIZE(SecurityModel, icon)
WCDB_SYNTHESIZE(SecurityModel, account)
WCDB_SYNTHESIZE(SecurityModel, passWord)
WCDB_SYNTHESIZE(SecurityModel, passwordData)
WCDB_SYNTHESIZE(SecurityModel, remark)
WCDB_SYNTHESIZE(SecurityModel, createDate)
WCDB_SYNTHESIZE(SecurityModel, modifyDate)
WCDB_SYNTHESIZE(SecurityModel, level)
WCDB_SYNTHESIZE(SecurityModel, securityId)

WCDB_PRIMARY(SecurityModel, securityId)

WCDB_INDEX(SecurityModel, "_index", securityId)
@end

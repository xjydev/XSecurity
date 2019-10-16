//
//  SecurityModel+WCTTableCoding.h
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//

#import "SecurityModel.h"
#import <WCDB/WCDB.h>
@interface SecurityModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(name)
WCDB_PROPERTY(icon)
WCDB_PROPERTY(account)
WCDB_PROPERTY(passWord)
WCDB_PROPERTY(passwordData)
WCDB_PROPERTY(remark)
WCDB_PROPERTY(createDate)
WCDB_PROPERTY(modifyDate)
WCDB_PROPERTY(level)
WCDB_PROPERTY(securityId)

@end

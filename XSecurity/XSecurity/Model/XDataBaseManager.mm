//
//  XDataBaseManager.m
//  XSecurity
//
//  Created by XiaoDev on 2019/10/11.
//  Copyright © 2019 XiaoDev. All rights reserved.
//
#define KDocumentP [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#import "XDataBaseManager.h"
#import "SecurityModel+WCTTableCoding.h"
#import "XTools.h"

static XDataBaseManager *_xManager = nil;

@interface XDataBaseManager ()
@property (nonatomic,strong)WCTDatabase *dataBase;
@property (nonatomic,strong)WCTTable    *recordTable;
@end

@implementation XDataBaseManager
+ (instancetype)defaultManager {
  static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _xManager = [[XDataBaseManager alloc]init];
    });
    return _xManager;
}
- (WCTDatabase *)dataBase {
    if (!_dataBase) {
        NSString *path = [KDocumentP stringByAppendingPathComponent:[NSString stringWithFormat:@".wcd/%@",KTableName]];
        _dataBase = [[WCTDatabase alloc]initWithPath:path];
        NSData *keyData = [@"xiao@dev" dataUsingEncoding:NSUTF8StringEncoding];
        [_dataBase setCipherKey:keyData];
        BOOL result = [_dataBase createTableAndIndexesOfName:KTableName withClass:SecurityModel.class];
        self.recordTable = [_dataBase getTableOfName:KTableName withClass:SecurityModel.class];
        if (result) {
            return  _dataBase;
        }
        _dataBase = nil;
        return nil;
    }
    return _dataBase;
    
}
- (NSArray *)getAllSecurity {
    if (self.dataBase) {
        return [self.dataBase getObjectsOfClass:SecurityModel.class fromTable:KTableName where:SecurityModel.securityId>0];
    }
    return nil;
}
- (BOOL)deleteSecurityModel:(SecurityModel *)model {
    if (self.dataBase) {
        BOOL result = [self.dataBase deleteObjectsFromTable:KTableName where:SecurityModel.securityId == model.securityId];
        return result;
    }
    return NO;
}
- (BOOL)saveSecurityModel:(SecurityModel *)model {
    if (self.dataBase) {
        if (model.securityId == 0) {//id自增
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            model.securityId = [user integerForKey:@"ksecurityid"]+1;
            [user setInteger:model.securityId forKey:@"ksecurityid"];
            [user synchronize];
        }
        model.passwordData = [XTOOLS encryptAes256WithStr:model.passWord Key:kENKEY];
        model.passWord = nil;
        BOOL result = [self.dataBase insertOrReplaceObject:model into:KTableName];
        return result;
       }
       return NO;
}
- (BOOL)updateSecurityModel:(SecurityModel *)model {
    if (self.dataBase) {
        model.passwordData = [XTOOLS encryptAes256WithStr:model.passWord Key:kENKEY];
        model.passWord = nil;
        BOOL result = [self.dataBase updateRowsInTable:KTableName onProperties:SecurityModel.AllProperties withObject:model where:SecurityModel.securityId == model.securityId];
        return result;
       }
       return NO;
}
@end

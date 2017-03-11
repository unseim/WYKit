//
//  WYDBHelper.h
//  WYKit
//
//  Created by 汪年成 on 16/12/26.
//  Copyright © 2016年 之静之初. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface WYDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (WYDBHelper *)shareInstance;

+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;



@end

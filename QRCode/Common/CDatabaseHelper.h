//
//  CDatabaseHelper.h
//  
//
//  Created by Carl Liu on 15/7/27.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface CDatabaseHelper : NSObject

@property (strong, nonatomic, readonly) NSString *dbPath;

- (instancetype)initDatabaseWithPath:(NSString *)aPath;

- (void)doInDatabaseBlock:(BOOL (^)(FMDatabase *db))block withCompletion:(void (^)(BOOL result))completion;
- (void)doInDatabaseBlock:(void (^)(FMDatabase *db))block;
- (void)doInDatabaseBlock:(void (^)(FMDatabase *))block withQueue:(dispatch_queue_t)queue;

- (void)doInTransactionBlock:(BOOL (^)(FMDatabase *db, BOOL *rollback))block withCompletion:(void (^)(BOOL result))completion;
- (void)doInTransactionBlock:(void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)doInTransactionBlock:(void (^)(FMDatabase *db, BOOL *rollback))block withQueue:(dispatch_queue_t)queue;

@end

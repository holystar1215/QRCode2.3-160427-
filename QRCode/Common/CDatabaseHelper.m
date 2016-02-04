//
//  CDatabaseHelper.m
//  
//
//  Created by Carl Liu on 15/7/27.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import "CDatabaseHelper.h"
#import "NSString+AppPath.h"
#import <FMDB.h>

@interface CDatabaseHelper ()
@property (strong, nonatomic) FMDatabaseQueue *dbQueue;

@end

@implementation CDatabaseHelper

- (instancetype)initDatabaseWithPath:(NSString *)aPath {
    self = [super init];
    if (self) {
        
        if (aPath) {
            _dbPath = aPath;
            self.dbQueue  = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
        } else {
            self.dbQueue  = [FMDatabaseQueue databaseQueueWithPath:nil];
        }
    }
    
    return self;
}

- (void)dealloc {
    [self.dbQueue close];
    self.dbQueue = nil;
}

- (void)doInDatabaseBlock:(BOOL (^)(FMDatabase *db))block withCompletion:(void (^)(BOOL result))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            BOOL result = block(db);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }];
    });
}

- (void)doInDatabaseBlock:(void (^)(FMDatabase *db))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            block(db);
        }];
    });
}

- (void)doInDatabaseBlock:(void (^)(FMDatabase *))block withQueue:(dispatch_queue_t)queue {
    dispatch_async(queue, ^{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            block(db);
        }];
    });
}

- (void)doInTransactionBlock:(BOOL (^)(FMDatabase *db, BOOL *rollback))block withCompletion:(void (^)(BOOL result))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            BOOL result = block(db, rollback);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }];
    });
}

- (void)doInTransactionBlock:(void (^)(FMDatabase *db, BOOL *rollback))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            block(db, rollback);
        }];
    });
}

- (void)doInTransactionBlock:(void (^)(FMDatabase *db, BOOL *rollback))block withQueue:(dispatch_queue_t)queue {
    dispatch_async(queue, ^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            block(db, rollback);
        }];
    });
}

@end

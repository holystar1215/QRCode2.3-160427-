//
//  CDataSource.m
//  
//
//  Created by CarlLiu on 16/1/10.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import "CDataSource.h"
#import "CDatabaseHelper.h"

@interface CDataSource ()
@property (nonatomic, strong) CDatabaseHelper *dbHelper;

@end

@implementation CDataSource

DEFINE_SINGLETON_FOR_CLASS(CDataSource);

- (instancetype)init {
	self = [super init];
	if (self) {
        // Init code here
        NSString *dbPath = [NSFileManager getDocumentsDirectoryForFile:[[Configuration sharedInstance] dbFileName]];
        self.dbHelper = [[CDatabaseHelper alloc] initDatabaseWithPath:dbPath];
	}
	return self;
}

- (void)dealloc {
    self.dbHelper = nil;
}

//Initialize the local storage environment
#pragma mark - Setup/Update App Datasource
- (void)createLocalDatabase {
    [self.dbHelper doInDatabaseBlock:^(FMDatabase *db) {
        if (db.userVersion == 0) {
            [db setUserVersion:(UInt32)[[[Configuration sharedInstance] dbVersion] intValue]];
        }
        
        
    }];
}

- (void)updateLocalDatabase {
    [self.dbHelper doInDatabaseBlock:^(FMDatabase *db) {
        [db setUserVersion:(UInt32)[[[Configuration sharedInstance] dbVersion] intValue]];
        
        
    }];
}

@end

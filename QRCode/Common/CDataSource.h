//
//  CDataSource.h
//  
//
//  Created by CarlLiu on 16/1/10.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLoginModel.h"
#import "CSchoolModel.h"
#import "CRecordModel.h"

@interface CDataSource : NSObject
@property (nonatomic, strong) CLoginModel *loginDict;

DEFINE_SINGLETON_FOR_HEADER(CDataSource);

- (void)createLocalDatabase;
- (void)updateLocalDatabase;

@end

//
//  CDataSource.h
//  
//
//  Created by CarlLiu on 16/1/10.
//  Copyright © 2016年 Carl. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CDataSource : NSObject

DEFINE_SINGLETON_FOR_HEADER(CDataSource);

- (void)createLocalDatabase;
- (void)updateLocalDatabase;

@end

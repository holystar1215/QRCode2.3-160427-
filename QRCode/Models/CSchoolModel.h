//
//  
//  CSchoolModel.h
//
//  Created by Carl
//  Copyright (c) 2016年 Carl. All rights reserved.
//


#import <Mantle/Mantle.h>

@interface CSchoolModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *customizeNo;
@property (nonatomic, strong) NSString *schoolCode;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *serverAddr;
@property (nonatomic, strong) NSString *unifiedCode;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *isDelete;

@end

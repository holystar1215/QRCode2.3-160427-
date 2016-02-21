//
//  CWebService.h
//  
//
//  Created by CarlLiu on 16/1/4.
//  Copyright © 2016年 CarlLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPIClient.h"

typedef NS_ENUM(NSInteger, WebServiceError) {
    eWebServiceErrorUnknow = 0,
    eWebServiceErrorSuccess = 1, //成功
    eWebServiceErrorFailed = -1, //失败
    eWebServiceErrorTimeout = -2, //响应超时
    eWebServiceErrorConnectFailed = -3,
    eWebServiceErrorAuthentication = -4 //Token鉴权失败
};

@interface CWebServiceError : NSError
@property (nonatomic, assign) WebServiceError errorType;

@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSString *errorMessage;

- (instancetype)initWithCode:(NSInteger)code andMessage:(NSString *)message;

+ (instancetype)checkRespondDict:(NSDictionary *)dict;
+ (instancetype)checkRespondWithError:(NSError *)error;

@end

typedef void(^WebServiceErrorRespondBlock)(CWebServiceError *error);

@interface CWebService : NSObject
@property (nonatomic, assign) BOOL isLogin;

DEFINE_SINGLETON_FOR_HEADER(CWebService);

- (void)setToken:(NSString *)token;
- (NSString *)getToken;

- (AFHTTPRequestOperation *)school_list_success:(void (^)(NSArray *models))success
                                        failure:(WebServiceErrorRespondBlock)failure
                                       animated:(BOOL)animated
                                        message:(NSString *)message;

- (AFHTTPRequestOperation *)login_username:(NSString *)username
                                  password:(NSString *)password
                                   success:(void (^)(NSArray *models))success
                                   failure:(WebServiceErrorRespondBlock)failure
                                  animated:(BOOL)animated
                                   message:(NSString *)message;

//- (AFHTTPRequestOperation *)check_update:(NSString *)update
//                                 success:(void (^)(NSArray *models))success
//                                 failure:(WebServiceErrorRespondBlock)failure
//                                animated:(BOOL)animated
//                                 message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)record_log_schoolno:(NSString *)code
//                                        logname:(NSString *)logname
//                                        success:(void (^)(NSArray *models))success
//                                        failure:(WebServiceErrorRespondBlock)failure
//                                       animated:(BOOL)animated
//                                        message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)search_log_currentpage:(NSInteger)page
//                                            company:(NSString *)company
//                                               type:(NSInteger)type
//                                            success:(void (^)(NSArray *models))success
//                                            failure:(WebServiceErrorRespondBlock)failure
//                                           animated:(BOOL)animated
//                                            message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)asset_info_number:(NSString *)number
//                                      company:(NSString *)company
//                                      success:(void (^)(NSArray *models))success
//                                      failure:(WebServiceErrorRespondBlock)failure
//                                     animated:(BOOL)animated
//                                      message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)manual_info_number:(NSString *)number
//                                       company:(NSString *)company
//                                       success:(void (^)(NSArray *models))success
//                                       failure:(WebServiceErrorRespondBlock)failure
//                                      animated:(BOOL)animated
//                                       message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)modify_data
//
//- (AFHTTPRequestOperation *)latest_modify_data
//
//- (AFHTTPRequestOperation *)
//
//- (AFHTTPRequestOperation *)add_room_list
//
//- (AFHTTPRequestOperation *)confirm_asset_number:(NSString *)number
//                                           user:(NSString *)user
//                                        company:(NSString *)company
//                              has_dimension_code:(BOOL)has_dimension_code
//                                        success:(void (^)(NSArray *models))success
//                                        failure:(WebServiceErrorRespondBlock)failure
//                                       animated:(BOOL)animated
//                                        message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)confirm_asset_number:(NSString *)number
//                                           user:(NSString *)user
//                                        company:(NSString *)company
//                                          manual:(NSString *)manual
//                                        success:(void (^)(NSArray *models))success
//                                        failure:(WebServiceErrorRespondBlock)failure
//                                       animated:(BOOL)animated
//                                        message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)update_asset_number:(NSString *)number
//                                           user:(NSString *)user
//                                        company:(NSString *)company
//                             has_dimension_code:(BOOL)has_dimension_code
//                                        success:(void (^)(NSArray *models))success
//                                        failure:(WebServiceErrorRespondBlock)failure
//                                       animated:(BOOL)animated
//                                        message:(NSString *)message;
//
//- (AFHTTPRequestOperation *)update_asset_number:(NSString *)number
//                                           user:(NSString *)user
//                                        company:(NSString *)company
//                                         manual:(NSString *)manual
//                                        success:(void (^)(NSArray *models))success
//                                        failure:(WebServiceErrorRespondBlock)failure
//                                       animated:(BOOL)animated
//                                        message:(NSString *)message;


@end

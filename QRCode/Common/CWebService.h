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

@end

//
//  CWebService.h
//  
//
//  Created by CarlLiu on 16/1/4.
//  Copyright © 2016年 CarlLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPIClient.h"

typedef NS_ENUM(NSUInteger, ppWebServiceError) {
    eWebServiceErrorSuccess = 0, //成功
    eWebServiceErrorFailed = -1, //未知原因错误
    eWebServiceErrorTimeout = -1001, //响应超时
    eWebServiceErrorConnectFailed = -1004,
    eWebServiceErrorAuthentication_Failure = 1 //Token鉴权失败
};

@interface CWebServiceError : NSError
@property (nonatomic, assign) ppWebServiceError errorType;
@property (nonatomic, strong) NSString *errorMessage;

+ (instancetype)type:(ppWebServiceError)type message:(NSString *)message;
+ (instancetype)error:(NSError *)error;

@end

typedef void(^WebServiceErrorRespondBlock)(CWebServiceError *error);

@interface CWebService : NSObject
@property (nonatomic, assign) BOOL isLogin;

DEFINE_SINGLETON_FOR_HEADER(CWebService);

- (void)setToken:(NSString *)token;
- (NSString *)getToken;


@end

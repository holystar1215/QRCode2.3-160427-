//
//  CWebService.m
//  
//
//  Created by CarlLiu on 16/1/4.
//  Copyright © 2016年 CarlLiu. All rights reserved.
//

#import "CWebService.h"

#import <AFNetworking.h>

@implementation CWebServiceError

- (instancetype)initWithCode:(NSInteger)code andMessage:(NSString *)message {
    if (self = [super init]) {
        self.errorCode = code;
        self.errorMessage = message;
        [self checkErrorType];
    }
    return self;
}

+ (instancetype)checkRespondDict:(NSDictionary *)dict {
    NSInteger codeValue = [[dict objectForKey:@"code"] integerValue];
    NSString *msgValue = [dict objectForKey:@"msg"];
    
    return [[CWebServiceError alloc] initWithCode:codeValue andMessage:msgValue];
}

+ (instancetype)checkRespondWithError:(NSError *)error {
    return [[CWebServiceError alloc] initWithCode:error.code andMessage:error.localizedDescription];
}

- (void)checkErrorType {
    switch (self.errorCode) {
        case 2000: {
            self.errorType = eWebServiceErrorSuccess;
            break;
        }
        case -10001: {
            self.errorType = eWebServiceErrorTimeout;
            break;
        }
        case -1004: {
            self.errorType = eWebServiceErrorConnectFailed;
            break;
        }
        default: {
            self.errorType = eWebServiceErrorFailed;
            break;
        }
    }
}

@end

@interface CWebService ()
@property (nonatomic, strong) CAPIClient *client;

@property (nonatomic, strong, setter=setToken:) NSString *token;

@end

@implementation CWebService

DEFINE_SINGLETON_FOR_CLASS(CWebService);

- (instancetype)init {
    if (self = [super init]) {
        self.client = [[CAPIClient alloc] init];
    }
    return self;
}

- (void)dealloc {
    self.client = nil;
}

- (void)setToken:(NSString *)token {
    _token = token;
    if ([token length] > 0) {
        [self.client.manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    } else {
        [self.client.manager.requestSerializer clearAuthorizationHeader];
    }
    
}

- (NSString *)getToken {
    return _token;
}

- (NSString *)responseMessage:(NSDictionary *)dictionary {
    NSString *msg = dictionary[@"cause"];
    if (msg.length <= 0) {
        msg = nil;
    }
    return msg;
}

#pragma mark - API
- (AFHTTPRequestOperation *)school_list_success:(void (^)(NSArray *models))success
                                        failure:(WebServiceErrorRespondBlock)failure
                                       animated:(BOOL)animated
                                        message:(NSString *)message {
    NSString *uri = @"netcx-config/api/configController/securi_config";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] totalUrl]];
    return [self.client postHttpRequestWithURI:uri
                                    parameters:nil
                                       success:^(NSData *responseObject) {
                                           NSError *jsonError = nil;
                                           NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
                                           if (!jsonError) {
                                               CWebServiceError *webError = [CWebServiceError checkRespondDict:resultDic];
                                               if (webError.errorType == eWebServiceErrorSuccess) {
                                                   success(resultDic[@"obj"]);
                                               } else {
                                                   failure(webError);
                                               }
                                           } else {
                                               failure([CWebServiceError checkRespondWithError:jsonError]);
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           CWebServiceError *serviceError = [CWebServiceError checkRespondWithError:error];
                                           serviceError.errorMessage = [operation responseObject];
                                           failure(serviceError);
                                       }
                                      animated:animated
                                       message:message];
}

- (AFHTTPRequestOperation *)login_username:(NSString *)username
                                  password:(NSString *)password
                                   success:(void (^)(NSArray *models))success
                                   failure:(WebServiceErrorRespondBlock)failure
                                  animated:(BOOL)animated
                                   message:(NSString *)message {
    NSString *uri = @"liquidation/api/liquidata/securi_login?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                     @"Username" : username,//12000001
                     @"Password" : [password encodeToBase64]//wuwen929
                     };
    return [self.client postHttpRequestWithURI:uri
                                    parameters:dict
                                       success:^(NSData *responseObject) {
                                           NSError *jsonError = nil;
                                           NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
                                           if (!jsonError) {
                                               CWebServiceError *webError = [CWebServiceError checkRespondDict:resultDic];
                                               if (webError.errorType == eWebServiceErrorSuccess) {
                                                   success(resultDic[@"obj"]);
                                               } else {
                                                   failure(webError);
                                               }
                                           } else {
                                               failure([CWebServiceError checkRespondWithError:jsonError]);
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           CWebServiceError *serviceError = [CWebServiceError checkRespondWithError:error];
                                           serviceError.errorMessage = [operation responseObject];
                                           failure(serviceError);
                                       }
                                      animated:animated
                                       message:message];
}

@end

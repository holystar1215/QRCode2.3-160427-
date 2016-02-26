//
//  CWebService.m
//  
//
//  Created by CarlLiu on 16/1/4.
//  Copyright © 2016年 CarlLiu. All rights reserved.
//

#import "CWebService.h"
#import "CModifyRecord.h"

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
    NSString *uri = @"/netcx-config/api/configController/securi_config";
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
                                   success:(void (^)(NSDictionary *models))success
                                   failure:(WebServiceErrorRespondBlock)failure
                                  animated:(BOOL)animated
                                   message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidata/securi_login?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                     @"username" : username,//12000001
                     @"passwd" : password//wuwen929
                     };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)record_currentpage:(NSString *)page
                                       company:(NSString *)company
                                          type:(NSString *)type
                                       success:(void (^)(NSArray *models))success
                                       failure:(WebServiceErrorRespondBlock)failure
                                      animated:(BOOL)animated
                                       message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidata/securi_searchzc?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"curpage" : page,
                           @"pddw" : company,
                           @"type" : type
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)update_record:(CModifyRecord *)model
                                  success:(void (^)(NSArray *models))success
                                  failure:(WebServiceErrorRespondBlock)failure
                                 animated:(BOOL)animated
                                  message:(NSString *)message {
    NSString *uri = @"/liquidation/api/uplyr/securi_updateZjhspy?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    
    NSString *param = [[model dictionaryValue] dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)asset_info_code:(NSString *)code
                                       pddw:(NSString *)pddw
                                    success:(void (^)(NSArray *models))success
                                    failure:(WebServiceErrorRespondBlock)failure
                                   animated:(BOOL)animated
                                    message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidata/securi_findByAssetnumber?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"assetnumber" : code,
                           @"pddw" : pddw
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)profit_code:(NSString *)code
                                   dlmc:(NSString *)dlmc
                                   pddw:(NSString *)pddw
                                     mc:(NSString *)mc
                                success:(void (^)(NSArray *models))success
                                failure:(WebServiceErrorRespondBlock)failure
                               animated:(BOOL)animated
                                message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidata/securi_updateassepy?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"assetnumber" : code,
                           @"dlmc" : dlmc,
                           @"pddw" : pddw,
                           @"mc" : mc
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)confirm_code:(NSString *)code
                                    dlmc:(NSString *)dlmc
                                    pddw:(NSString *)pddw
                                      mc:(NSString *)mc
                                 success:(void (^)(NSArray *models))success
                                 failure:(WebServiceErrorRespondBlock)failure
                                animated:(BOOL)animated
                                 message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidata/securi_updateassetnumber?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"assetnumber" : code,
                           @"dlmc" : dlmc,
                           @"pddw" : pddw,
                           @"mc" : mc
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)search_dw:(NSString *)dw
                              success:(void (^)(NSArray *models))success
                              failure:(WebServiceErrorRespondBlock)failure
                             animated:(BOOL)animated
                              message:(NSString *)message {
    NSString *uri = @"/liquidation/api/uplyr/securi_addDanweiList?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"dw" : dw
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)manual_code:(NSString *)code
                                   pddw:(NSString *)pddw
                                success:(void (^)(NSArray *models))success
                                failure:(WebServiceErrorRespondBlock)failure
                               animated:(BOOL)animated
                                message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidatarg/securi_findByAssetnumber?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"assetnumber" : code,
                           @"pddw" : pddw
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)manual_profit_code:(NSString *)code
                                          dlmc:(NSString *)dlmc
                                          pddw:(NSString *)pddw
                                            mc:(NSString *)mc
                                       success:(void (^)(NSArray *models))success
                                       failure:(WebServiceErrorRespondBlock)failure
                                      animated:(BOOL)animated
                                       message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidatarg/securi_updateassetnumber?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"assetnumber" : code,
                           @"dlmc" : dlmc,
                           @"pddw" : pddw,
                           @"mc" : mc
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

- (AFHTTPRequestOperation *)manual_confirm_code:(NSString *)code
                                           dlmc:(NSString *)dlmc
                                           pddw:(NSString *)pddw
                                             mc:(NSString *)mc
                                        success:(void (^)(NSArray *models))success
                                        failure:(WebServiceErrorRespondBlock)failure
                                       animated:(BOOL)animated
                                        message:(NSString *)message {
    NSString *uri = @"/liquidation/api/liquidatarg/securi_updateassepy?sign=";
    self.client.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
    NSDictionary *dict = @{
                           @"assetnumber" : code,
                           @"dlmc" : dlmc,
                           @"pddw" : pddw,
                           @"mc" : mc
                           };
    NSString *param = [dict dictionaryToJSON];
    param = [param encodeToBase64];
    uri = [NSString stringWithFormat:@"%@%@", uri, param];
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

@end

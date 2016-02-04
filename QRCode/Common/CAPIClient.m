//
//  CAPIClient.m
//  
//
//  Created by LiuCarl on 15/1/8.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import "CAPIClient.h"
#import <AFNetworking/AFNetworking.h>
#import "MBProgressHUD+UIView.h"

@interface CAPIClient ()

@end

@implementation CAPIClient

- (instancetype)init {
    if (self = [super init]) {
        self.baseURL = [NSURL URLWithString:[[Configuration sharedInstance] serverUrl]];
        self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:self.baseURL];
        
        // setup your service interface here
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        
        //申明返回的结果是json类型
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        //如果报接受类型不一致请替换一致text/html或别的
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
       
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
}

#pragma mark - 
#pragma mark Http Reques
/**
 *  发送GET请求
 *
 *  @param url        请求API地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param animated   是否显示HUD
 *  @param message    HUD显示的信息
 *
 *  @return 请求对象
 */
- (AFHTTPRequestOperation *)getHttpRequestWithURI:(NSString *)uri
                                       parameters:(id)parameters
                                          success:(void (^) (NSData *responseObject))success
                                          failure:(ErrorRespondBlock)failure
                                         animated:(BOOL)animated
                                          message:(NSString *)message {
    NSLog(@"\r\n%@/%@\nparam:%@", self.baseURL, uri, parameters);
    NSString *url = [NSString stringWithFormat:@"%@/%@", self.baseURL, uri];
    if (animated) {
        [MBProgressHUD showMessage:message];
    }
    
    return [self.manager GET:url
                  parameters:parameters
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if (animated) {
                             [MBProgressHUD hideHUD];
                         }
                         
                         success(operation.responseData);
                         
                         NSLog(@"\r\n%@", operation.responseString);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (animated) {
                             [MBProgressHUD hideHUD];
                         }
                         
                         failure(operation, error);
                         
                         NSLog(@"\r\n%@", operation.responseString);
                     }];
}

/**
 *  发送POST请求
 *
 *  @param url        请求API地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param animated   是否显示HUD
 *  @param message    HUD显示的信息
 *
 *  @return 请求对象
 */
- (AFHTTPRequestOperation *)postHttpRequestWithURI:(NSString *)uri
                                        parameters:(id)parameters
                                           success:(void (^)(NSData *responseObject))success
                                           failure:(ErrorRespondBlock)failure
                                          animated:(BOOL)animated
                                           message:(NSString *)message {
    NSLog(@"\r\n%@/%@\nparam:%@", self.baseURL, uri, parameters);
    NSString *url = [NSString stringWithFormat:@"%@/%@", self.baseURL, uri];
    if (animated) {
        [MBProgressHUD showMessage:message];
    }
    
    return [self.manager POST:url
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          if (animated) {
                              [MBProgressHUD hideHUD];
                          }
                          
                          success(operation.responseData);
                          
                          NSLog(@"\r\n%@", operation.responseString);
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (animated) {
                              [MBProgressHUD hideHUD];
                          }
                          
                          failure(operation, error);
                          
                          NSLog(@"\r\n%@", operation.responseString);
                      }];
}

/**
 *  发送POST请求
 *
 *  @param url        请求API地址
 *  @param parameters 请求参数
 *  @param data       数据
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param animated   是否显示HUD
 *  @param message    HUD显示的信息
 *
 *  @return 请求对象
 */
- (AFHTTPRequestOperation *)postHttpRequestWithURI:(NSString *)uri
                                        parameters:(id)parameters
                                              data:(NSData *)data
                                           success:(void (^) (NSData *responseObject)) success
                                           failure:(ErrorRespondBlock) failure
                                          animated:(BOOL)animated
                                           message:(NSString *)message {
    NSLog(@"\r\n%@/%@\nparam:%@", self.baseURL, uri, parameters);
    NSString *url = [NSString stringWithFormat:@"%@/%@", self.baseURL, uri];
    if (animated) {
        [MBProgressHUD showMessage:message];
    }
    
    return [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (data) {
            [formData appendPartWithHeaders:parameters body:data];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseData);
        
        if (animated) {
            [MBProgressHUD hideHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
        
        if (animated) {
            [MBProgressHUD hideHUD];
        }
    }];
    
}

/**
 *  发送PUT请求
 *
 *  @param url        请求API地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param animated   是否显示HUD
 *  @param message    HUD显示的信息
 *
 *  @return 请求对象
 */
- (AFHTTPRequestOperation *)putHttpRequestWithURI:(NSString *)uri
                                       parameters:(id)parameters
                                          success:(void (^) (NSData *responseObject))success
                                          failure:(ErrorRespondBlock)failure
                                         animated:(BOOL)animated
                                          message:(NSString *)message {
    NSLog(@"\r\n%@/%@\nparam:%@", self.baseURL, uri, parameters);
    NSString *url = [NSString stringWithFormat:@"%@/%@", self.baseURL, uri];
    if (animated) {
        [MBProgressHUD showMessage:message];
    }
    
    return [self.manager PUT:url
                  parameters:parameters
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         if (animated) {
                             [MBProgressHUD hideHUD];
                         }
                         
                         success(operation.responseData);
                         
                         NSLog(@"\r\n%@", operation.responseString);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         if (animated) {
                             [MBProgressHUD hideHUD];
                         }
                         
                         failure(operation, error);
                         
                         NSLog(@"\r\n%@", operation.responseString);
                     }];
}

/**
 *  发送DELETE请求
 *
 *  @param url        请求API地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param animated   是否显示HUD
 *  @param message    HUD显示的信息
 *
 *  @return 请求对象
 */
- (AFHTTPRequestOperation *)deleteHttpRequestWithURI:(NSString *)uri
                                          parameters:(id)parameters
                                             success:(void (^) (NSData *responseObject))success
                                             failure:(ErrorRespondBlock)failure
                                            animated:(BOOL)animated
                                             message:(NSString *)message {
    NSLog(@"\r\n%@/%@\nparam:%@", self.baseURL, uri, parameters);
    NSString *url = [NSString stringWithFormat:@"%@/%@", self.baseURL, uri];
    if (animated) {
        [MBProgressHUD showMessage:message];
    }
    
    return [self.manager DELETE:url
                     parameters:parameters
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if (animated) {
                                [MBProgressHUD hideHUD];
                            }
                            
                            success(operation.responseData);
                            
                            NSLog(@"\r\n%@", operation.responseString);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if (animated) {
                                [MBProgressHUD hideHUD];
                            }
                            
                            failure(operation, error);
                            
                            NSLog(@"\r\n%@", operation.responseString);
                        }];
}

/**
 *  取消所有请求
 */
- (void)cancelAllRequests {
    [[self.manager operationQueue] cancelAllOperations];
}

@end

//
//
//  CAPIClient.h
//  
//
//  Created by LiuCarl on 15/1/8.
//  Copyright (c) 2015年 Carl Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;
@class AFHTTPRequestOperationManager;
typedef void(^ErrorRespondBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface CAPIClient : NSObject
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSURL *baseURL;

- (AFHTTPRequestOperation *)getHttpRequestWithURI:(NSString *)uri
                                       parameters:(id)parameters
                                          success:(void (^) (NSData *responseObject))success
                                          failure:(ErrorRespondBlock)failure
                                         animated:(BOOL)animated
                                          message:(NSString *)message;

- (AFHTTPRequestOperation *)postHttpRequestWithURI:(NSString *)uri
                                        parameters:(id)parameters
                                           success:(void (^)(NSData *responseObject))success
                                           failure:(ErrorRespondBlock)failure
                                          animated:(BOOL)animated
                                           message:(NSString *)message;

- (AFHTTPRequestOperation *)postHttpRequestWithURI:(NSString *)uri
                                        parameters:(id)parameters
                                              data:(NSData *)data
                                           success:(void (^) (NSData *responseObject)) success
                                           failure:(ErrorRespondBlock) failure
                                          animated:(BOOL)animated
                                           message:(NSString *)message;

- (AFHTTPRequestOperation *)putHttpRequestWithURI:(NSString *)uri
                                       parameters:(id)parameters
                                          success:(void (^) (NSData *responseObject))success
                                          failure:(ErrorRespondBlock)failure
                                         animated:(BOOL)animated
                                          message:(NSString *)message;

- (AFHTTPRequestOperation *)deleteHttpRequestWithURI:(NSString *)uri
                                          parameters:(id)parameters
                                             success:(void (^) (NSData *responseObject))success
                                             failure:(ErrorRespondBlock)failure
                                            animated:(BOOL)animated
                                             message:(NSString *)message;

- (void)cancelAllRequests;

@end

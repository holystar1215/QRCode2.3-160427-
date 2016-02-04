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

- (instancetype)initWithType:(ppWebServiceError)type andMessage:(NSString *)message {
    if (self = [super init]) {
        self.errorType = type;
        self.errorMessage = message;
        return self;
    }
    return nil;
}

+ (instancetype)type:(ppWebServiceError)type message:(NSString *)message {
    return [[self alloc] initWithType:type andMessage:message];
}

+ (instancetype)error:(NSError *)error {
    switch (error.code) {
        case -1001:
            return [[self alloc] initWithType:eWebServiceErrorTimeout andMessage:error.description];
        case -1004:
            return [[self alloc] initWithType:eWebServiceErrorConnectFailed andMessage:error.description];
        default:
            return [[self alloc] initWithType:eWebServiceErrorFailed andMessage:error.description];
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

- (CWebServiceError *)checkForResponseStatus:(NSDictionary *)dictionary {
    NSDictionary *statusDict = dictionary[@"status"];
    NSString *msg = [self responseMessage:statusDict];
    ppWebServiceError status = [statusDict[@"code"] integerValue];
    
    switch (status) {
        case eWebServiceErrorSuccess: {
            
            break;
        }
        case eWebServiceErrorFailed: {
            
            break;
        }
        case eWebServiceErrorTimeout: {
            
            break;
        }
        case eWebServiceErrorAuthentication_Failure: {
            
            break;
        }
        default: {
            status = eWebServiceErrorFailed;
            break;
        }
    }
    CWebServiceError *error = [CWebServiceError type:status message:msg];
    return error;
}

#pragma mark - API


@end

//
//  TweakHttpsManager.m
//  iosReToolProject
//
//  Created by 陈蕃坊 on 2019/7/13.
//  Copyright © 2019 陈蕃坊. All rights reserved.
//

#import "TweakHttpsManager.h"

@implementation TweakHttpsManager

static TwAFHTTPSessionManager *sessionManager = nil;
static NSArray *Methods = nil;



+ (TwAFHTTPSessionManager *)sessionManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        if (Methods == nil) {
            Methods = @[@"GET",@"POST",@"DELETE",@"PUT",@"PATCH"];
        }
        
        if (sessionManager == nil) {
            
            sessionManager.requestSerializer.timeoutInterval = 15;
            //response serializer
            TwAFJSONResponseSerializer *jsonResponseSerializer = [TwAFJSONResponseSerializer serializer];
            NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
            [jsonAcceptableContentTypes addObject:@"text/plain"];
            [jsonAcceptableContentTypes addObject:@"text/html"];
            jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
            sessionManager.responseSerializer = jsonResponseSerializer;
            
            sessionManager.securityPolicy = [TwAFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        }
    });
    return sessionManager;
}


static NSDictionary *publicParams = nil;


+ (NSURLSessionDataTask *)httpsWithFullUrl:(NSString *)fullUrl httpType:(CCHttpsType)httpType linkParam:(NSDictionary *)linkParam bodyParam:(id)bodyParam headerParams:(NSDictionary *)headerParams success:(void(^)(NSURLSessionDataTask *task, NSDictionary *dict))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    
    NSURLSessionDataTask *task = [self httpsRequestWithFullUrl:fullUrl httpType:httpType linkParam:linkParam bodyParam:bodyParam headerParams:headerParams success:success failure:failure];
    return task;
    
}




+ (NSURLSessionDataTask *)httpsRequestWithFullUrl:(NSString *)url httpType:(CCHttpsType)type linkParam:(NSDictionary *)linkParam bodyParam:(NSDictionary *)bodyParam headerParams:(NSDictionary *)headerParams success:(void(^)(NSURLSessionDataTask * _Nonnull task, id response))success failure:(void(^)(NSURLSessionDataTask * _Nonnull task, id response))failure {
    
    
    //拼接url字符串处理
    NSMutableString *fullStr = url.mutableCopy;
    
    
    NSMutableDictionary *linkDicM = linkParam.mutableCopy;
    
    NSArray *keys = [linkDicM allKeys];
    for (int i = 0; i < keys.count; i++) {
        if (i == 0 && [fullStr containsString:@"?"] == NO) {
            [fullStr appendString:@"?"];
        }
        
        NSString *key = keys[i];
        NSObject *value = linkDicM[key];
        
        [fullStr appendFormat:@"%@=%@",key, value];
        
        if (i != keys.count - 1) {
            [fullStr appendString:@"&"];
        }
    }
    
    NSString *urlStr = [fullStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURLSessionDataTask *task;
    
    switch (type) {
        case CCHttpsType_GET:
            task = [self getWithUrl:urlStr bodyParam:bodyParam success:success failure:failure];
            
            break;
            
        case CCHttpsType_POST:
            task = [self postWithUrl:urlStr bodyParam:bodyParam success:success failure:failure];
            
            break;
            
        case CCHttpsType_DELETE:
            
            break;
            
        case CCHttpsType_PUT:
            
            break;
            
        case CCHttpsType_PATCH:
            
            break;
            
        default:
            break;
    }
    return task;
}


//=================================================================
//                           GET
//=================================================================
#pragma mark - GET

+ (NSURLSessionDataTask *)getWithUrl:(NSString *)url bodyParam:(id)bodyParam success:(void(^)(NSURLSessionDataTask * _Nonnull task, NSDictionary *response))success failure:(void(^)(NSURLSessionDataTask * _Nonnull task, NSError *error))failure {
    
    TwAFHTTPSessionManager *mgr = [self sessionManager];
    
    NSURLSessionDataTask *returnTask = [mgr GET:url parameters:bodyParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
        
    }];
    
    return returnTask;
}


//=================================================================
//                           POST
//=================================================================
#pragma mark - POST

+ (NSURLSessionDataTask *)postWithUrl:(NSString *)url bodyParam:(id)bodyParam success:(void(^)(NSURLSessionDataTask * _Nonnull task, NSDictionary *response))success failure:(void(^)(NSURLSessionDataTask * _Nonnull task, NSError *error))failure {
    
    TwAFHTTPSessionManager *mgr = [self sessionManager];
    
    NSURLSessionDataTask *returnTask = [mgr POST:url parameters:bodyParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
    
    return returnTask;
}


@end

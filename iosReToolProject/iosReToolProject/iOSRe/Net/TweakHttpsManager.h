//
//  TweakHttpsManager.h
//  iosReToolProject
//
//  Created by 陈蕃坊 on 2019/7/13.
//  Copyright © 2019 陈蕃坊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TwAFNetworking.h"


typedef NS_ENUM(NSInteger, CCHttpsType) {
    CCHttpsType_GET = 0,
    CCHttpsType_POST,
    CCHttpsType_DELETE,
    CCHttpsType_PUT,
    CCHttpsType_PATCH
};

@interface TweakHttpsManager : NSObject

+ (NSURLSessionDataTask *)httpsWithFullUrl:(NSString *)fullUrl httpType:(CCHttpsType)httpType linkParam:(NSDictionary *)linkParam bodyParam:(id)bodyParam headerParams:(NSDictionary *)headerParams success:(void(^)(NSURLSessionDataTask *task, NSDictionary *response))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end



//
//  SMARequestManager.h
//  iAcronyms
//
//  Created by Shamith Mukundan on 2/11/17.
//  Copyright © 2017 Shamith. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "SMAShortForm.h"

typedef void (^SMASuccessBlock)(NSURLSessionDataTask *task, SMAShortForm *response);
typedef void (^SMAFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface SMARequestManager : AFHTTPSessionManager

//Shared instance of SMARequestManager
+ (SMARequestManager *) sharedManager;

//fetch definitions method
- (void) fetchDefinitionsFor:(NSString *)acornym success:(SMASuccessBlock)success failure:(SMAFailureBlock)failure;

@end

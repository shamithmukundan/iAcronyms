//
//  SMARequestManager.m
//  iAcronyms
//
//  Created by Shamith Mukundan on 2/11/17.
//  Copyright © 2017 Shamith. All rights reserved.
//

#import "SMARequestManager.h"
#import "SMALongForm.h"

@interface SMARequestManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation SMARequestManager

+(SMARequestManager *) sharedManager {
    
    static SMARequestManager *sharedManager = nil;
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        sharedManager = [[SMARequestManager alloc] init];
    });
    return sharedManager;
}

- (id) init {
    
    if ( self = [super init]) {
        
        NSString *urlAsString = @"http://www.nactem.ac.uk/software/acromine/";
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: urlAsString]];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain"]];
        
        // Enable the spinner in the status bar - to indicate network activity
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
}

- (void) fetchDefinitionsFor:(NSString *)acornym success:(SMASuccessBlock)success failure:(SMAFailureBlock)failure {
    [self.sessionManager GET:@"dictionary.py" parameters:@{@"sf": acornym} progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        if (success) {
            if ([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
                NSDictionary *dataDictionary = responseObject[0];
                SMAShortForm *info = [[SMAShortForm alloc] init];
                info.shortForm = [dataDictionary objectForKey:@"sf"];
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in [dataDictionary objectForKey:@"lfs"]) {
                    SMALongForm *item = [[SMALongForm alloc] init];
                    item.longForm = [dict valueForKey:@"lf"];
                    item.frequency = [NSString stringWithFormat:@"%zd" ,[[dict valueForKey:@"freq"] integerValue]];
                    item.since = [NSString stringWithFormat:@"%zd" ,[[dict valueForKey:@"since"] integerValue]];
                    item.variations = [dict valueForKey:@"vars"];
                    [array addObject:item];
                }
                info.longForms = [array copy];
                success(task, info);
            } else {
                success(task, nil);
            }
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end

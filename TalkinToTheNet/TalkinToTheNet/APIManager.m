//
//  APIManager.m
//  LearnAPIs2
//
//  Created by Daniel Distant on 9/20/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+ (void)GETRequestWithURL:(NSURL *)URL completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            completionHandler(data, response,error);
        });
        
    }];
    
    [task resume];
    
}

@end

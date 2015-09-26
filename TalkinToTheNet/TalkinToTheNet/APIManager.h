//
//  APIManager.h
//  LearnAPIs2
//
//  Created by Daniel Distant on 9/20/15.
//  Copyright © 2015 ddistant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+(void)GETRequestWithURL:(NSURL *)URL completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))completionHandler;

@end

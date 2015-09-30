//
//  InstagramPost.h
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPost : NSObject

@property (nonatomic) NSString *imageURLString;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *caption;

-(instancetype) initWithJSON:(NSDictionary *)json;

@end

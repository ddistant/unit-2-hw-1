//
//  InstagramPost.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "InstagramPost.h"

@implementation InstagramPost

-(instancetype) initWithJSON:(NSDictionary *)json {
    
    if (self = [super init]) {

        self.caption = json[@"caption"][@"text"];
        self.username = json[@"user"][@"username"];
        self.imageURLString = json[@"images"][@"standard_resolution"][@"url"];

        return self;
    }
    return nil;
}

@end
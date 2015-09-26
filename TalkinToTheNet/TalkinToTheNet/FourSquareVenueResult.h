//
//  FourSquareVenueResult.h
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/25/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquareVenueResult : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSString *address;
@property (nonatomic) NSNumber *distance;
@property (nonatomic) NSURL *mobileURL;

-(instancetype)initWithJSON:(NSDictionary *)json;

@end

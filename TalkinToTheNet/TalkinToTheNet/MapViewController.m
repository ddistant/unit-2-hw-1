//
//  MapViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

-(void) setup {
    
    //mapview and locationManager
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locatorMapView.delegate = self;
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locatorMapView.layer.borderWidth = 3.0;
    self.locatorMapView.layer.borderColor = [UIColor colorWithRed:40/255.0 green:80/255.0 blue:131/255.0 alpha:1].CGColor;
    self.locatorMapView.layer.cornerRadius = 10.0;


}

@end

//
//  MapViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "MapViewController.h"
#import "DetailsTableViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setLabels];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsTableViewController *viewController = [segue destinationViewController];
    if (self.venueResultInfo[@"name"] != nil) {
        viewController.searchTerm = self.venueResultInfo[@"name"];
    }
}

-(void) setup {
    
    self.navigationItem.title = @"Location";
    
    //mapview and locationManager
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locatorMapView.delegate = self;
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
//    MKUserLocation *userLocation = self.locatorMapView.userLocation;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(40.7,-74);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    
    [self.locatorMapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    
    self.locatorMapView.layer.borderWidth = 2.0;
    self.locatorMapView.layer.borderColor = [UIColor colorWithRed:40/255.0 green:80/255.0 blue:131/255.0 alpha:1].CGColor;
    self.locatorMapView.layer.cornerRadius = 10.0;
    
}

-(void) setLabels {
    
    if (self.venueResultInfo[@"name"] == nil) {
        self.nameLabel.text = @"n/a";
    } else {
        
        self.nameLabel.text = [self.venueResultInfo objectForKey:@"name"];
    }
    
    if (self.venueResultInfo[@"mobileURL"] == nil) {
        self.mobileLabel.text = @"n/a";
    } else {
        
        self.mobileLabel.text = [self.venueResultInfo objectForKey: @"mobileURL"];
    }
    
    if (self.venueResultInfo[@"address"] == nil) {
        self.addressLabel.text = @"n/a";
    } else {
        
        self.addressLabel.text = [[self.venueResultInfo objectForKey: @"address"] componentsJoinedByString:@" "];
    }
    
    if (self.venueResultInfo[@"phoneNumber"] == nil) {
        self.phoneNumberLabel.text = @"n/a";
    } else {
        
        self.phoneNumberLabel.text = [self.venueResultInfo objectForKey: @"phoneNumber"];
    }
}

@end

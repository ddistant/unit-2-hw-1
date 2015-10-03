//
//  MapViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "MapViewController.h"
#import "DetailsTableViewController.h"
#import "WebViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setLabels];
    [self updateMap];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
        
        DetailsTableViewController *viewController = [segue destinationViewController];
        if (self.venueResultInfo[@"name"] != nil) {
            viewController.searchTerm = self.venueResultInfo[@"name"];
        }
    }
    
    if ([segue.identifier isEqualToString:@"webSegue"]) {
       
        WebViewController *viewController = [segue destinationViewController];
        viewController.url = [NSURL URLWithString:[self.venueResultInfo objectForKey: @"mobileURL"]];
        
    }
}
-(void) setup {
    
    self.navigationItem.title = @"Location";
    
    //mapview
    
    self.locatorMapView.delegate = self;

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.userLatitude,self.userLongitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    
    [self.locatorMapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    
    self.locatorMapView.layer.borderWidth = 2.0;
    self.locatorMapView.layer.borderColor = [UIColor colorWithRed:40/255.0 green:80/255.0 blue:131/255.0 alpha:1].CGColor;
    self.locatorMapView.layer.cornerRadius = 10.0;
    
    //mobileButton
    
    self.mobileButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
}

-(void) setLabels {
    
    if (self.venueResultInfo[@"name"] == nil) {
        self.nameLabel.text = @"n/a";
    } else {
        
        self.nameLabel.text = [self.venueResultInfo objectForKey:@"name"];
    }
    
    if (self.venueResultInfo[@"mobileURL"] == nil) {
        self.mobileButton.hidden = YES;
    } else {
        
        [self.mobileButton setTitle:@"Website" forState:UIControlStateNormal];
        
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

-(void) addAnnotationForVenue {
    
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    double lat = [self.venueResultInfo[@"latitude"] doubleValue];
    double lng = [self.venueResultInfo[@"longitude"] doubleValue];
    
    CLLocationCoordinate2D venueLocation = CLLocationCoordinate2DMake(lat, lng);
    
    mapPin.coordinate = venueLocation;
    mapPin.title = self.venueResultInfo[@"name"];
    
    [self.locatorMapView addAnnotation:mapPin];
}

-(void) updateMap {
    [self.locatorMapView removeAnnotations:self.locatorMapView.annotations];

    [self addAnnotationForVenue];
    
}

@end

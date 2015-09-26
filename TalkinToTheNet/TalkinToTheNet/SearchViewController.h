//
//  SearchViewController.h
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "APIManager.h"

@interface SearchViewController : UIViewController
<
MKMapViewDelegate,
UITextFieldDelegate,
CLLocationManagerDelegate
>

@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) CLLocationManager *locationManager;

@end

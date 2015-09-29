//
//  MapViewController.h
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

<
MKMapViewDelegate,
CLLocationManagerDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *locatorMapView;
@property (nonatomic) CLLocationManager *locationManager;



@end

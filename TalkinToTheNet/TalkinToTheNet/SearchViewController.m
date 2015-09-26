//
//  SearchViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "SearchViewController.h"
#import "FourSquareVenueResult.h"



@interface SearchViewController () 

@property (nonatomic) IBOutlet MKMapView *searchMapView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel1;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel2;


@end
@implementation SearchViewController

- (void)viewDidLoad {
    
//    self.searchMapView.delegate = self;
//    self.locationManager.delegate = self;
//    
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager startUpdatingLocation];
//        [self.locationManager requestWhenInUseAuthorization];
//        self.searchMapView.showsUserLocation = YES;
//    }
//
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startUpdatingLocation];
    
    self.navigationItem.title = @"NearMe";
    
    self.searchMapView.layer.borderWidth = 3.0;
    self.searchMapView.layer.borderColor = [UIColor colorWithRed:40/255.0 green:80/255.0 blue:131/255.0 alpha:1].CGColor;
    self.searchMapView.layer.cornerRadius = 10.0;
    
    self.searchTextField.layer.borderWidth = 3.0;
    self.searchTextField.layer.borderColor = [UIColor colorWithRed:40/255.0 green:80/255.0 blue:131/255.0 alpha:1].CGColor;
    self.searchTextField.layer.cornerRadius = 10.0;
    
    self.searchLabel1.textColor = [UIColor colorWithRed:249/255.0 green:72/255.0 blue:119/255.0 alpha:1];
    self.searchLabel2.textColor = [UIColor colorWithRed:249/255.0 green:72/255.0 blue:119/255.0 alpha:1];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSString *longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }

}

-(void) makeNewFourSquareRequestWithSearchTerm:(NSString *)searchTerm callBackBlock:(void(^)())block {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?client_id=4BVIIF5WI4YYPWT0O1MANDN4QJ1GLCHDCESZZZP1RHJIR0DQ&client_secret=QHR4C1IDZSWUFTD3DOO2TOJ05IXO1D1SMK4IGEOC3AKRB1FN&v=20140806&ll=40.7577,-73.9857&query=%@", self.searchTextField.text];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *results = [[json objectForKey:@"response"] objectForKey:@"groups"];
        
        self.searchResults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in results) {
            
            FourSquareVenueResult *venueResult = [[FourSquareVenueResult alloc] initWithJSON:result];
            
            venueResult.name = [[[[[results objectAtIndex:0] objectForKey:@"items"] objectAtIndex:self.searchResults.count] objectForKey:@"venue"] objectForKey:@"name"];
            
            venueResult.phoneNumber = [[[[[[results objectAtIndex:0] objectForKey:@"items"] objectAtIndex:self.searchResults.count] objectForKey:@"venue"] objectForKey:@"contact"] objectForKey:@"formattedPhone"];
            venueResult.address = [[[[[[results objectAtIndex:0] objectForKey:@"items"] objectAtIndex:self.searchResults.count] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"formattedAddress"];
            venueResult.distance = [[[[[[results objectAtIndex:0] objectForKey:@"items"] objectAtIndex:self.searchResults.count] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"distance"];
            venueResult.mobileURL = [[[[[[results objectAtIndex:0] objectForKey:@"items"] objectAtIndex:self.searchResults.count] objectForKey:@"venue"] objectForKey:@"menu"] objectForKey:@"mobileUrl"];
            venueResult.latitude = [[[[[[results objectAtIndex:0] objectForKey:@"items"] objectAtIndex:self.searchResults.count] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"];
            venueResult.longitude = [[[[[[results objectAtIndex:0] objectForKey:@"items"] objectAtIndex:self.searchResults.count] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"];
            
            [self.searchResults addObject:venueResult];
            
//            NSLog(@"%@\n %@\n %@\n %@\n %@\n %@\n %@\n", venueResult.name, venueResult.phoneNumber, venueResult.address, venueResult.distance, venueResult.mobileURL, venueResult.latitude, venueResult.longitude);
        }
        
    }];
    
}

//#pragma mark - map view

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.searchMapView setRegion:[self.searchMapView regionThatFits:region] animated:YES];
//    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = userLocation.coordinate;
//    point.title = @"You are here";
//    
//    [self.searchMapView addAnnotation:point];
//    [self.locationManager stopUpdatingLocation];
//    
//}
//
//#pragma mark - location manager
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    NSLog(@"%@", [locations lastObject]);
//}


#pragma mark - text field

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //dismiss keyboard
    [self.view endEditing:YES];
    
    //make API request
    [self makeNewFourSquareRequestWithSearchTerm:textField.text callBackBlock:^{
        
    }];
    
    return YES;
}



@end

//
//  SearchViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/21/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "SearchViewController.h"
#import "FourSquareVenueResult.h"
#import "DetailsTableViewController.h"
#import "MapViewController.h"



@interface SearchViewController () 

//@property (nonatomic) IBOutlet MKMapView *searchMapView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel1;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel2;
@property (nonatomic) CLLocationManager *locationManager;


@end
@implementation SearchViewController

- (void)viewDidLoad {
    
    [self setup];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MapSegue"]) {
        
        MapViewController *viewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FourSquareVenueResult *currentResult = [self.searchResults objectAtIndex:indexPath.row];
        NSMutableDictionary *currentDictionary = [[NSMutableDictionary alloc] init];
        [currentDictionary setObject:currentResult.name forKey:@"name"];
        [currentDictionary setObject:currentResult.address forKey:@"address"];
        [currentDictionary setObject:currentResult.latitude forKey:@"latitude"];
        [currentDictionary setObject:currentResult.longitude forKey:@"longitude"];
        
        if (currentResult.phoneNumber == nil) {
            [currentDictionary setObject:@"n/a" forKey:@"phoneNumber"];
        } else {
            [currentDictionary setObject:currentResult.phoneNumber forKey:@"phoneNumber"];
        }
        
        [currentDictionary setObject: [NSString stringWithFormat:@"%@", currentResult.mobileURL]  forKey:@"mobileURL"];
        viewController.venueResultInfo = [[NSMutableDictionary alloc] init];
        [viewController.venueResultInfo addEntriesFromDictionary:currentDictionary];
        
        //user location
        
        viewController.userLatitude = self.locationManager.location.coordinate.latitude;
        viewController.userLongitude = self.locationManager.location.coordinate.longitude;
        
    }
}

-(void) setup {
    
    //array
    
    self.searchResults = [[NSMutableArray alloc] init];
    
    //textfield
    
    self.searchTextField.delegate = self;
    
    //tableview
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //UI
    
    self.navigationItem.title = @"Search";
    
    
    self.searchTextField.layer.borderWidth = 3.0;
    self.searchTextField.layer.borderColor = [UIColor colorWithRed:40/255.0 green:80/255.0 blue:131/255.0 alpha:1].CGColor;
    self.searchTextField.layer.cornerRadius = 10.0;
    
    self.tableView.layer.borderWidth = 2.0;
    self.tableView.layer.borderColor = [UIColor colorWithRed:40/255.0 green:80/255.0 blue:131/255.0 alpha:1].CGColor;
    self.tableView.layer.cornerRadius = 10.0;
    
    self.searchLabel1.textColor = [UIColor colorWithRed:249/255.0 green:72/255.0 blue:119/255.0 alpha:1];
    self.searchLabel2.textColor = [UIColor colorWithRed:249/255.0 green:72/255.0 blue:119/255.0 alpha:1];
    
    //locationManager
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}


-(void) makeNewFourSquareRequestWithSearchTerm:(NSString *)searchTerm
                                 callBackBlock:(void(^)())block {
    
    if (self.searchResults.count > 0) {
        [self.searchResults removeAllObjects];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?client_id=4BVIIF5WI4YYPWT0O1MANDN4QJ1GLCHDCESZZZP1RHJIR0DQ&client_secret=QHR4C1IDZSWUFTD3DOO2TOJ05IXO1D1SMK4IGEOC3AKRB1FN&v=20140806&ll=%f,%f&query=%@", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, self.searchTextField.text];
    
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:encodedString];
    
    [APIManager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data != nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *results = json[@"response"][@"groups"][0][@"items"];
            
            for (NSDictionary *result in results) {
                
                FourSquareVenueResult *venueResult = [[FourSquareVenueResult alloc] initWithJSON:result];
                
                venueResult.name = result[@"venue"][@"name"];
                venueResult.phoneNumber = result[@"venue"][@"contact"][@"formattedPhone"];
                venueResult.address = result[@"venue"][@"location"][@"formattedAddress"];
                venueResult.distance = result[@"venue"][@"location"][@"distance"];
                venueResult.mobileURL = result[@"venue"][@"menu"][@"mobileUrl"];
                venueResult.latitude = result[@"venue"][@"location"][@"lat"];
                venueResult.longitude = result[@"venue"][@"location"][@"lng"];
                
                [self.searchResults addObject:venueResult];
                
            }
        }
        
        if (self.searchResults.count == 0) {
            [self createAlertWithTitle:@"Search Error" andMessage:@"No results found!"];
        }
        
        block();
    }];
    
}


#pragma mark - text field

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //dismiss keyboard
    [self.view endEditing:YES];
    
    if ([textField.text isEqualToString:@""]) {
        [self createAlertWithTitle:@"Search term required" andMessage:@"What are you looking for?"];
    }
    
    //make API request
    [self makeNewFourSquareRequestWithSearchTerm:textField.text callBackBlock:^{
        [self.tableView reloadData];
    }];
    
    return YES;
}

#pragma mark -table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    FourSquareVenueResult *venueResult = self.searchResults[indexPath.row];
    
    cell.textLabel.text = venueResult.name;
    cell.detailTextLabel.text = venueResult.phoneNumber;
    
    return cell;
    
}

- (void) createAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}



@end

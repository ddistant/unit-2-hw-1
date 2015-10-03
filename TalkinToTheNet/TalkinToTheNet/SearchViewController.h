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
UITextFieldDelegate,
UITableViewDataSource,
UITableViewDelegate,
CLLocationManagerDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *searchResults;

@end

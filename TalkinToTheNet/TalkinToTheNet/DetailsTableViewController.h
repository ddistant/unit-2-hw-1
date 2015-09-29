//
//  DetailsTableViewController.h
//  TalkinToTheNet
//
//  Created by Daniel Distant on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewController : UITableViewController

@property (nonatomic) NSMutableArray *searchResultsTV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *InstagramImageView;

@end

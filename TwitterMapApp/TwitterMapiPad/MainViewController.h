//
//  MainViewController.h
//  TwitterMap
//
//  Created by Akshay Narayan on 4/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TweetModel.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITableView *tweetTable;
@property (strong, nonatomic) IBOutlet UIView *wrappingView;

@property (retain, nonatomic) NSString *key;
@property (retain, nonatomic) TweetModel *tweetModel;
@property (assign, nonatomic) unsigned int tweetWindow;

- (void) gotSwipeRight;
- (void) gotSwipeLeft;

- (void) searchBarTextDidEndEditing:(UISearchBar *)searchBar;
- (void) update;

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (MKOverlayRenderer*) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;
@end

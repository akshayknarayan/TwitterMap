//
//  MainViewController.m
//  TwitterMap
//
//  Created by Akshay Narayan on 4/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize key;
@synthesize tweetModel;
@synthesize tweetWindow;

@synthesize wrappingView;
@synthesize search;
@synthesize map;
@synthesize tweetTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetModel = [[TweetModel alloc] initWithAuthToken:key andController:self];
    self.tweetWindow = 0;
    tweetTable.dataSource = self;
    tweetTable.delegate = self;
    search.delegate = self;
    
    UISwipeGestureRecognizer *recog_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotSwipeRight)];
    [recog_right setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.tweetTable addGestureRecognizer:recog_right];
    
    UIScreenEdgePanGestureRecognizer *recog_left = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(gotSwipeLeft)];
    recog_left.edges = UIRectEdgeRight;
    [self.wrappingView addGestureRecognizer: recog_left];
    
    MKCoordinateRegion worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
    map.region = worldRegion;
    [self.map setDelegate:self];
}

- (void) gotSwipeRight {
    if (self.tweetTable.center.x < self.wrappingView.bounds.origin.x + self.wrappingView.bounds.size.width) {
        NSLog(@"Right swipe: closing panel");
        [UIView animateWithDuration:0.5 animations:^{
            //hide table view
            CGPoint center = self.tweetTable.center;
            center.x += 320;
            self.tweetTable.center = center;
            
            CGRect bounds = self.map.bounds;
            center = self.map.center;
            bounds.size.width += 330;
            center.x += 160;
            self.map.bounds = bounds;
            self.map.center = center;
        }];
    }
}

- (void) gotSwipeLeft {
    if (!(self.tweetTable.center.x < self.wrappingView.bounds.origin.x + self.wrappingView.bounds.size.width)) {
        NSLog(@"Left swipe: opening panel");
        [UIView animateWithDuration:0.5 animations:^{
            //hide table view
            CGPoint center = self.tweetTable.center;
            center.x -= 320;
            self.tweetTable.center = center;
            
            CGRect bounds = self.map.bounds;
            center = self.map.center;
            bounds.size.width -= 330;
            center.x -= 160;
            self.map.bounds = bounds;
            self.map.center = center;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searched for: %@", searchBar.text);
    [map removeOverlays:map.overlays];
    [tweetModel performNewSearch:searchBar.text];
}

- (void) update {
    if ([self.tweetModel.tweets count] > 10) {
        self.tweetWindow ++;
    }
    [self.tweetTable reloadData];
    Tweet *latest = [self.tweetModel.tweets lastObject];
    if (latest.location) {
        NSNumber *lat = (NSNumber*) latest.location[0];
        NSNumber *lon = (NSNumber*) latest.location[1];
        NSLog(@"making overlay at: %@, %@", lat, lon);
        MKCircle *tweetOverlay = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]) radius:160000];
        tweetOverlay.title = [NSString stringWithFormat:@"%@", [latest sentiment]];
        [map addOverlay:tweetOverlay];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    unsigned long numRows = [self.tweetModel.tweets count];
    if (numRows >= 10) {
        return 10;
    }
    else {
        return numRows;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get an existing cell with the MyView identifier if it exists
    NSString *identifier = @"MyCell";
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // There is no existing cell to reuse so create a new one
    if (result == nil) {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    
    // result is now guaranteed to be valid, either as a reused cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    Tweet *toDisplay = [self.tweetModel.tweets objectAtIndex:self.tweetWindow + [indexPath row]];
    
    result.textLabel.numberOfLines = 3;
    result.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    result.textLabel.text = [toDisplay text];

    result.detailTextLabel.text = [NSString stringWithFormat:@"%@::%@", [toDisplay author], [toDisplay sentiment], nil];
    
    // Return the result
    return result;
}

- (MKOverlayRenderer*) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygonRenderer* aRenderer = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        
        aRenderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        aRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        aRenderer.lineWidth = 3;
        
        return aRenderer;
    }
    else if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:(MKCircle*) overlay];

        float sentiment = [overlay.title floatValue];
        if (sentiment < 0) {
            renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
            renderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
            renderer.lineWidth = 3;
        }
        else if (sentiment > 0) {
            renderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
            renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
            renderer.lineWidth = 3;
        }
        
        return renderer;
    }
    
    return nil;
}

@end

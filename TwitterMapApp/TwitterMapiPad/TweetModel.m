//
//  TweetModel.m
//  TwitterMap
//
//  Created by Akshay Narayan on 3/26/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import "TweetModel.h"
#import "MainViewController.h"

@implementation TweetModel

@synthesize tweets;
@synthesize authToken;
@synthesize currentSearch;
@synthesize connection;
@synthesize controller;

NSString *const SERVERURL = @"http://127.0.0.1:8000";

- (id) initWithAuthToken:(NSString *)token andController: (MainViewController*) mycontroller {
    self = [super init];
    if (self) {
        self.authToken = token;
        self.tweets = [[NSMutableArray alloc] init];
        currentSearch = nil;
        connection = nil;
        self.controller = mycontroller;
    }
    return self;
}

- (void) performNewSearch:(NSString *)searchTerm {
    if (self.connection) {
        [self.connection cancel];
    }
    self.currentSearch = searchTerm;
    [self fetchNewTweetsWithSearchTerm:searchTerm];
}

- (void) fetchNewTweetsWithSearchTerm:(NSString *)term {
    [self.tweets removeAllObjects];
    NSString *URL = [NSString stringWithFormat:@"%@%@%@%@%@", SERVERURL, @"/tweets?filter=", self.currentSearch, @"&auth=", self.authToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setHTTPMethod:@"GET"];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self.connection start];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSArray *objects = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByString:@"\n"];
    for (NSString *object in objects) {
        if ([object isEqualToString:@""]) {
            continue;
        }
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:[object dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (error) {
            NSLog(@"Error parsing JSON: %@\n%@\n", [error localizedDescription], object);
        }
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result;
            NSDictionary *loc = nil;
            if ([dict objectForKey:@"location"] != [NSNull null]) {
                loc = [dict objectForKey:@"location"];
            }
            NSNumber *sentiment = @([[dict objectForKey:@"sentiment"] floatValue]);
            Tweet *tweet = [[Tweet alloc] initWithAuthor:[dict objectForKey:@"username"] Time:[dict objectForKey:@"time"] Location:loc andText:[dict objectForKey:@"text"] andSentiment:sentiment];
//            if (tweet.location) {
//                NSLog(@"tweet: %@", tweet);
//            }
            [self.tweets addObject: tweet];
            [self.controller update];
        }
    }
}

@end

//
//  TweetModel.h
//  TwitterMap
//
//  Created by Akshay Narayan on 3/26/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@class MainViewController;

@interface TweetModel : NSObject <NSURLConnectionDataDelegate>

@property NSMutableArray *tweets;
@property NSString *authToken;
@property NSString *currentSearch;
@property NSURLConnection *connection;

@property MainViewController *controller;

- (id) initWithAuthToken:(NSString*) token andController:(MainViewController*) controller;

- (void) performNewSearch: (NSString*) searchTerm;
- (void) fetchNewTweetsWithSearchTerm: (NSString*) term;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
@end

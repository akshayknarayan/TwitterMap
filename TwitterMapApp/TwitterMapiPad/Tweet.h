//
//  Tweet.h
//  TwitterMap
//
//  Created by Akshay Narayan on 3/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (retain) NSString *author;
@property (retain) NSString *text;
@property (retain) NSString *time;
@property (retain) NSArray *location;
@property (retain) NSNumber *sentiment;

- (id) initWithAuthor: (NSString*) author Time:(NSString*) time Location: (NSDictionary*) loc andText: (NSString*) text andSentiment: (NSNumber*) sent;
- (NSString*) description;

@end

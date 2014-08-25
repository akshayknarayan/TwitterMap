//
//  Tweet.m
//  TwitterMap
//
//  Created by Akshay Narayan on 3/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

@synthesize author;
@synthesize time;
@synthesize location;
@synthesize text;

- (id) initWithAuthor:(NSString *)a Time:(NSString *)t Location:(NSDictionary*)loc andText:(NSString *)txt andSentiment: (NSNumber*) sent {
    self = [super init];
    if (self) {
        self.author = a;
        self.time = t;
        self.text = txt;
        self.sentiment = sent;
        if (loc && [[loc objectForKey:@"type"] isEqualToString:@"Point"]) {
            self.location = [[[loc valueForKey:@"coordinates"] reverseObjectEnumerator] allObjects];
        }
        else {
            self.location = nil;
        }
    }
    return self;
}

- (NSString*) description {
    NSString *str = [NSString stringWithFormat:@"%@%@\n%@",self.author,self.time,self.text];
    if (self.location) {
        str = [str stringByAppendingString:[self.location description]];
    }
    return str;
}

@end

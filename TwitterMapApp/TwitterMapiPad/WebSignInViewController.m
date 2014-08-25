//
//  WebSignInViewController.m
//  TwitterMap
//
//  Created by Akshay Narayan on 4/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import "WebSignInViewController.h"

@implementation WebSignInViewController

@synthesize webView;
NSString *const SERVER_URL = @"url-to-app-server";

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
    [self.webView setDelegate:self];
    [webView setScalesPageToFit:YES];
    NSString *URL = [SERVER_URL stringByAppendingString:@"/auth"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidFinishLoad: (UIWebView*) webview {
    NSLog(@"finished load!");
    NSString *callbackURL = [SERVER_URL stringByAppendingString:@"/auth/callback"];
    if ([webView.request.URL.absoluteString hasPrefix:callbackURL]) {

        //get the access token, save it
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
        
        BOOL worked = [self addToKeyChain: html];
        if (worked) {
            [self performSegueWithIdentifier:@"justLoggedInSegue" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"loginFailedSegue" sender:self];
        }
    }
    else {
        NSLog(@"%@, %@, %@", @"not callback page", webView.request.URL.absoluteString, callbackURL);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error loading page: %@", error);
}

- (BOOL) addToKeyChain:(NSString*) key {
    NSString *serviceName = @"TwitterMap";
    NSString *userName = @"twitterUser";
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];

    [attrs setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id<NSCopying>)(kSecClass)];
    [attrs setObject:[serviceName dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id<NSCopying>)(kSecAttrService)];
    [attrs setObject:[userName dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
    [attrs setObject:[key dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id<NSCopying>)(kSecValueData)];
    [attrs setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    
    CFTypeRef check = NULL;
    OSStatus result = SecItemAdd((__bridge CFDictionaryRef) attrs, &check);
    if (result == errSecSuccess) {
        //we are now authenticated.
        return YES;
    }
    else {
        NSLog(@"auth not successful: %d", result);
        return NO;
    }
}

@end

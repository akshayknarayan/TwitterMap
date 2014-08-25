//
//  WebSignInViewController.h
//  TwitterMap
//
//  Created by Akshay Narayan on 4/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>

@interface WebSignInViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void) webViewDidFinishLoad: (UIWebView*) webview;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL) addToKeyChain: (NSString*) key;
@end

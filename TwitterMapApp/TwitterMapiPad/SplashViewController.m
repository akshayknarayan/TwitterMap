//
//  AuthViewController.m
//  TwitterMap
//
//  Created by Akshay Narayan on 4/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import "SplashViewController.h"

@implementation SplashViewController

@synthesize signInButton;

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

    signInButton.layer.cornerRadius = 20;
    signInButton.layer.borderWidth = 1;
    signInButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void) viewDidAppear:(BOOL)animated {
    if ([self checkLogin]) {
        [self performSegueWithIdentifier:@"alreadyLoggedInSegue" sender:self];
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClick:(id)sender {
    [self performSegueWithIdentifier:@"needsToLogInSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] class] == [MainViewController class]) {
        [(MainViewController*)[segue destinationViewController] setKey:[self key]];
    }
}


- (BOOL) checkLogin {
    NSString *serviceName = @"TwitterMap";
    NSString *userName = @"twitterUser";
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc] init];
    
    [attrs setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id<NSCopying>)(kSecClass)];
    [attrs setObject:[serviceName dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id<NSCopying>)(kSecAttrService)];
    [attrs setObject:[userName dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
    [attrs setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    
    CFTypeRef res = nil;
    
    OSStatus result = SecItemCopyMatching((__bridge CFDictionaryRef)(attrs), &res);
    
    NSString *key = [[NSString alloc] initWithData:(__bridge NSData*) res encoding:NSUTF8StringEncoding];
    
    if (result == errSecSuccess) {
        [self setKey:key];
        return YES;
    }
    else if (result == errSecItemNotFound) {
        NSLog(@"key is missing");
        return NO;
    }
    else {
        NSLog(@"failed");
        return NO;
    }
}

@end

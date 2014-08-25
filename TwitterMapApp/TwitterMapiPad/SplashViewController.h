//
//  AuthViewController.h
//  TwitterMap
//
//  Created by Akshay Narayan on 4/30/14.
//  Copyright (c) 2014 Akshay Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface SplashViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) NSString *key;

- (BOOL) checkLogin;

@end

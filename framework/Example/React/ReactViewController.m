//
//  ReactViewController.m
//  React
//
//  Created by redye.hu on 2017/9/29.
//  Copyright © 2017年 redye.hu. All rights reserved.
//

#import "ReactViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@implementation ReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"App"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;

}

@end

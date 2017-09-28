//
//  ViewController.m
//  React
//
//  Created by redye.hu on 2017/9/27.
//  Copyright © 2017年 redye.hu. All rights reserved.
//

#import "RootViewController.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"App"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    rootView.frame = self.view.bounds;
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

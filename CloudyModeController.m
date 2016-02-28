//
//  CloudyModeController.m
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "CloudyModeController.h"

@interface CloudyModeController ()

@end

@implementation CloudyModeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"Cloudy";
    [[RoverGlobal sharedInstance] hideTabBar:self];
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

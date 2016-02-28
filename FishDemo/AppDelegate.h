//
//  AppDelegate.h
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoverGlobal.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    MBProgressHUD *hud;
    UILabel       *msgLabel;
}
@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) UILabel       *msgLabel;

@property (strong, nonatomic) UIWindow *window;


@end


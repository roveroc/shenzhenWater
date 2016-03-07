//
//  AppDelegate.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "SettingController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize hud;
@synthesize msgLabel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"light_precent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    
    NSDictionary *defaultValues1 = [NSDictionary dictionaryWithObjectsAndKeys:@"00:00", @"light_sTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues1];
    
    NSDictionary *defaultValues2 = [NSDictionary dictionaryWithObjectsAndKeys:@"12:00", @"light_eTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues2];
    
    NSDictionary *defaultValues3 = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"light_switch",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues3];
    
    NSDictionary *defaultValues_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"cloudy_precent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues_1];
    
    NSDictionary *defaultValues1_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"00:00", @"cloudy_sTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues1_1];
    
    NSDictionary *defaultValues2_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"12:00", @"cloudy_eTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues2_1];
    
    NSDictionary *defaultValues3_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"cloudy_switch",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues3_1];
    
    [RoverGlobal sharedInstance].enterBackgroundFlag = NO;
    
    UITabBarController *tabCon = [[UITabBarController alloc] init];
    
    MainController *mainCon = [[MainController alloc] init];
    mainCon.tabBarItem.image = [UIImage imageNamed:@"single.png"];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainCon];
    
    SettingController *setCon = [[SettingController alloc] init];
    setCon.tabBarItem.image = [UIImage imageNamed:@"more.png"];
    setCon.title= @"System";
    setCon.navigationItem.title = @"System";
    UINavigationController *setNav = [[UINavigationController alloc] initWithRootViewController:setCon];
    
    NSLog(@"[Global platform] = %f",[[UIScreen mainScreen] bounds].size.height);
    if([[Global platform] rangeOfString:@"iPhone 4"].location != NSNotFound){
        Global.screenWidth = 320;
        Global.screenHeigth = 480;
        Global.iPhoneType = iPhone4;
    }
    else if([[Global platform] rangeOfString:@"iPhone 5"].location != NSNotFound){
        Global.screenWidth = 320;
        Global.screenHeigth = 568;
        Global.iPhoneType = iPhone5;
    }
    else if([[Global platform] rangeOfString:@"iPhone 6"].location != NSNotFound &&
            [[Global platform] rangeOfString:@"Plus"].location == NSNotFound){
        Global.screenWidth = 320;//375
        Global.screenHeigth = 480;
        Global.iPhoneType = iPhone6;
    }
    else if([[Global platform] rangeOfString:@"iPhone 6"].location != NSNotFound &&
            [[Global platform] rangeOfString:@"Plus"].location != NSNotFound){
        Global.screenWidth = 414;
        Global.screenHeigth = 736;
        Global.iPhoneType = iPhone6;
    }
             

    
    NSArray *navArray = [[NSArray alloc] initWithObjects:mainNav,setNav, nil];
    tabCon.viewControllers = navArray;
    self.window.rootViewController = tabCon;
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [RoverGlobal sharedInstance].enterBackgroundFlag = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [RoverGlobal sharedInstance].enterBackgroundFlag = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([RoverGlobal sharedInstance].enterBackgroundFlag == YES){
        [RoverGlobal sharedInstance].enterBackgroundFlag = NO;
        [RoverGlobal sharedInstance].selfIP = [[RoverGlobal sharedInstance] getSelfIPAddress];
        NSLog(@"selfip = %@",[RoverGlobal sharedInstance].selfIP);
        if([RoverGlobal sharedInstance].selfIP == nil ||
           [[RoverGlobal sharedInstance].selfIP rangeOfString:@"LightFish-"].location == NSNotFound){
            [self addMessageLabel];
        }
        else{
            [self.msgLabel removeFromSuperview];
        }
    }
}

- (void)addMessageLabel{
    UIView *lab = (UIView *)[self.window viewWithTag:100];
    if(lab)
        [lab removeFromSuperview];
    if(self.msgLabel != nil)
        [self.msgLabel removeFromSuperview];
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    self.msgLabel.center = CGPointMake(self.window.frame.size.width/2, 74);
    self.msgLabel.text = @"Device OffLine";
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    self.msgLabel.textColor = [UIColor redColor];
    self.msgLabel.font = [UIFont fontWithName:@"Arial" size:12];
    [self.window addSubview:self.msgLabel];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

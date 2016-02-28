//
//  UserDefault.m
//  KukuWatch
//
//  Created by Rover on 2/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "UserDefault.h"

@implementation UserDefault

+ (UserDefault *)sharedInstance
{
    static UserDefault *gInstance = NULL;
    
    @synchronized(self)
    {
        if (!gInstance)
            gInstance = [self new];
    }
    
    return(gInstance);
}

- (void)setLight_precent:(NSString *)light_precent{
    [[NSUserDefaults standardUserDefaults] setObject:light_precent forKey:@"light_precent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)light_precent{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"light_precent"];
}

- (void)setLight_sTime:(NSString *)light_sTime{
    [[NSUserDefaults standardUserDefaults] setObject:light_sTime forKey:@"light_sTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)light_sTime{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"light_sTime"];
}

- (void)setLight_eTime:(NSString *)light_eTime{
    [[NSUserDefaults standardUserDefaults] setObject:light_eTime forKey:@"light_eTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)light_eTime{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"light_eTime"];
}

- (void)setLight_switch:(NSString *)light_switch{
    [[NSUserDefaults standardUserDefaults] setObject:light_switch forKey:@"light_switch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)light_switch{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"light_switch"];
}




- (void)setCloudy_precent:(NSString *)cloudy_precent{
    [[NSUserDefaults standardUserDefaults] setObject:cloudy_precent forKey:@"cloudy_precent"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)cloudy_precent{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"cloudy_precent"];
}

- (void)setCloudy_sTime:(NSString *)light_sTime{
    [[NSUserDefaults standardUserDefaults] setObject:light_sTime forKey:@"cloudy_sTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)cloudy_sTime{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"cloudy_sTime"];
}

- (void)setCloudy_eTime:(NSString *)cloudy_eTime{
    [[NSUserDefaults standardUserDefaults] setObject:cloudy_eTime forKey:@"cloudy_eTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)cloudy_eTime{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"cloudy_eTime"];
}

- (void)setCloudy_switch:(NSString *)cloudy_switch{
    [[NSUserDefaults standardUserDefaults] setObject:cloudy_switch forKey:@"cloudy_switch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)cloudy_switch{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"cloudy_switch"];
}

@end

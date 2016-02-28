//
//  UserDefault.h
//  KukuWatch
//
//  Created by Rover on 2/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject

+ (UserDefault *)sharedInstance;


@property (nonatomic, retain) NSString *light_precent;
@property (nonatomic, retain) NSString *light_sTime;
@property (nonatomic, retain) NSString *light_eTime;
@property (nonatomic, retain) NSString *light_switch;

@property (nonatomic, retain) NSString *cloudy_precent;
@property (nonatomic, retain) NSString *cloudy_sTime;
@property (nonatomic, retain) NSString *cloudy_eTime;
@property (nonatomic, retain) NSString *cloudy_switch;



@end

//
//  RoverGlobal.h
//  FishDemo
//
//  Created by rover on 15/9/6.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "AsyncUdpSocket.h"
#import "UserDefault.h"


//******************* ******************* *******************
//判断iPhone4/iPhone4S
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone5/iPhone5S
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6Plus
#define iPhone6__ ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1472), [[UIScreen mainScreen] currentMode].size) : NO)
//******************* ******************* *******************

#define SENDPORT    5000                 //发送数据端口
#define BroadCast   @"10.10.100.254"     //广播地址

#define WAITTIME    1.0

#define WIFISSID    @"LightFish-"

@interface RoverGlobal : NSObject{
    NSString       *selfIP;
    NSMutableArray *lineArray;
    BOOL           freshFlag;   //当保存返回后，需要刷新界面
    AsyncUdpSocket *udpSocket;
    int            timerNumer;  //记录第几个定时器
    
    //设备状态值
    BOOL           isSuccess;       //判断读取状态是否成功
    
    BOOL           switchStatus;
    int            hourStatus;
    int            minuteStatus;
    int            modelStatus;     //0x01 手动  0x02 闪电 0x03 多云 0x04 定时器1  0x05 定时器2 0x06 定时器3
    
    int            pipeValue1;      //三个通道值
    int            pipeValue2;
    int            pipeValue3;
    
    BOOL           enterBackgroundFlag;    //进入后台标示
    BOOL           isManualModel;
    BOOL           isLightingModel;
    BOOL           isCloudy;
    
    BOOL           isClosed;        //设备是否关闭
}

@property (nonatomic, retain) NSString       *selfIP;
@property (nonatomic, retain) NSMutableArray *lineArray;
@property (nonatomic, retain) AsyncUdpSocket *udpSocket;
@property (assign)            BOOL           freshFlag;
@property (assign)            int            timerNumber;

@property (assign)            BOOL           isSuccess;
@property (assign)            BOOL           switchStatus;
@property (assign)            int            hourStatus;
@property (assign)            int            minuteStatus;
@property (assign)            int            modelStatus;

@property (assign)            int            pipeValue1;
@property (assign)            int            pipeValue2;
@property (assign)            int            pipeValue3;

@property (assign)            BOOL           enterBackgroundFlag;
@property (assign)            BOOL           isManualModel;
@property (assign)            BOOL           isLightingModel;
@property (assign)            BOOL           isCloudy;
@property (assign)            BOOL           isClosed;

+ (RoverGlobal *)sharedInstance;

-(NSString *)getSelfIPAddress;

-(Byte)getChecksum:(Byte *)byte;
-(void)sendDataToDevice:(NSString *)desIP order:(NSData *)order tag:(int)tag;

- (void)hideTabBar:(UIViewController *)con;


@end

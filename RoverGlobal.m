//
//  RoverGlobal.m
//  FishDemo
//
//  Created by rover on 15/9/6.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "RoverGlobal.h"
#include "getSelfIPAddr.h"
#import "sys/utsname.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation RoverGlobal
@synthesize selfIP;
@synthesize lineArray;
@synthesize freshFlag;
@synthesize udpSocket;
@synthesize timerNumber;
@synthesize pipeValue1,pipeValue2,pipeValue3;
@synthesize switchStatus,hourStatus,minuteStatus,modelStatus;
@synthesize isSuccess;
@synthesize enterBackgroundFlag;
@synthesize isManualModel,isLightingModel,isCloudy;
@synthesize isClosed;
@synthesize screenHeigth,screenWidth;
@synthesize iPhoneType;
@synthesize deviceNameArray;
@synthesize deviceMACArray;

+ (RoverGlobal *)sharedInstance{
    static RoverGlobal *gInstance = NULL;
    @synchronized(self){
        if (!gInstance){
            gInstance = [self new];
        }
    }
    return(gInstance);
}

- (NSString *)platform {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

- (void)hideTabBar:(UIViewController *)con {
    if (con.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[con.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [con.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [con.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + con.tabBarController.tabBar.frame.size.height);
    con.tabBarController.tabBar.hidden = YES;
}

- (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}


-(id)fetchSSIDInfo
{
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (  id)CFBridgingRelease(CNCopySupportedInterfaces());
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
            
        }
    }
    return ssid;
}

#pragma mark - 获取本机的ip的地址
-(NSString *)getSelfIPAddress{
//    FreeAddresses();
//    GetIPAddresses();
//    GetHWAddresses();
//    if(ip_names[1] != NULL)
//        return [[NSString alloc]initWithCString:ip_names[1] encoding:NSUTF8StringEncoding];
//    return nil;
    NSString *ssid = [self currentWifiSSID];
    return ssid;
}

#pragma mark - 计算校验和
-(Byte)getChecksum:(Byte *)byte{
    Byte bb = 0x00;
    for(int i = 0;i<64;i++)
        bb+=byte[i];
    return bb;
}


#pragma mark - 发送数据
-(void)sendDataToDevice:(NSString *)desIP order:(NSData *)order tag:(int)tag{
    if(self.udpSocket == nil){
        [self.udpSocket close];
        self.udpSocket = nil;
    }
    AsyncUdpSocket * tmpSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    self.udpSocket = tmpSocket;
    NSError * error = nil;
    [self.udpSocket bindToPort:5000 error:&error];
    [self.udpSocket enableBroadcast:YES error:&error];
    [self.udpSocket receiveWithTimeout:-1 tag:0];
    
    NSLog(@" mode fast mode = %@",order);
    [self.udpSocket sendData:order toHost:desIP port:5000 withTimeout:-1 tag:0];
}

#pragma mark - 抓获从socket返回的数据
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSString * receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"receiveStr = %@ , host = %@",receiveStr,host);
    
    if(self.selfIP == nil)
        return NO;
    NSLog(@"从设备%@返回的数据为%@",host,data);
    if([host rangeOfString:self.selfIP].location == NSNotFound){
        self.isSuccess = YES;
        Byte *bb = (Byte *)[data bytes];
        NSLog(@"从设备%@返回的数据为%s",host,bb);
        if(bb[3] == 0x01){
            self.switchStatus = bb[5];
            self.hourStatus   = bb[6];
            self.minuteStatus = bb[7];
            self.modelStatus  = bb[8];
        }
        else if (bb[3] == 0x02){
            self.pipeValue1   = bb[6];
            self.pipeValue2   = bb[5];
            self.pipeValue3   = bb[7];
        }
        else if (bb[2] == 0x04 && bb[3] == 0x01 && bb[5] == 0x01){
            self.isClosed = NO;
        }
        else if (bb[2] == 0x04 && bb[3] == 0x01 && bb[5] == 0x01){
            self.isClosed = YES;
        }
    }
    return YES;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceiveDataWithTag----");
}


-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"onUdpSocketDidClose----");
}


@end

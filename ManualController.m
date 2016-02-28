//
//  ManualController.m
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "ManualController.h"

@interface ManualController ()

@end

@implementation ManualController
@synthesize dataArray;
@synthesize sendTimer;
@synthesize hud;

#pragma mark - 读取通道亮度值
- (void)getDeviceStatus{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x06;
    b3[3] = 0x02;
    b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"Manual";
    [[RoverGlobal sharedInstance] hideTabBar:self];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(fuckFun) userInfo:nil repeats:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.slider1 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider1 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    [self.slider2 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider2 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    [self.slider3 setMinimumTrackImage:[UIImage imageNamed:@"slider_gray.png"] forState:UIControlStateNormal];
    [self.slider3 setMinimumTrackImage:[UIImage imageNamed:@"slider_blue.png"] forState:UIControlStateNormal];
    
    
//    [self setMinimumTrackImage:@"slider_blue.png" withCapInsets:UIEdgeInsetsMake(0, 16, 0, 16) forState:UIControlStateNormal];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:self.hud.dimBackground];
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self getDeviceStatus];
    [self performSelector:@selector(getDeviceStatusFinished) withObject:nil afterDelay:1.0];
}


- (void)getDeviceStatusFinished{
    if([RoverGlobal sharedInstance].isSuccess == YES){
        self.slider1.value = [RoverGlobal sharedInstance].pipeValue1;
        self.slider2.value = [RoverGlobal sharedInstance].pipeValue2;
        self.slider3.value = [RoverGlobal sharedInstance].pipeValue3;
        
        self.label1.text = [NSString stringWithFormat:@"%d%%",[RoverGlobal sharedInstance].pipeValue1];
        self.label2.text = [NSString stringWithFormat:@"%d%%",[RoverGlobal sharedInstance].pipeValue2];
        self.label3.text = [NSString stringWithFormat:@"%d%%",[RoverGlobal sharedInstance].pipeValue3];
    }
    else{
        NSLog(@"读取通道值失败");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Get device status failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Get device status failed";
        [self.hud hide:YES afterDelay:0.8];
    }
    if([RoverGlobal sharedInstance].isClosed == YES){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Device Has been shut down";
        [self.hud hide:YES afterDelay:1.0];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (IBAction)sliderValueChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    if(slider.tag == 1)
        self.label1.text = [NSString stringWithFormat:@"%d%%",value];
    else if(slider.tag == 2)
        self.label2.text = [NSString stringWithFormat:@"%d%%",value];
    else
        self.label3.text = [NSString stringWithFormat:@"%d%%",value];
    [RoverGlobal sharedInstance].isManualModel = YES;
    [self buildDataToSend];
}

#pragma mark - 构造数据，准备发送
- (void)buildDataToSend{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x05;
    b3[3] = 0x02;
    b3[4] = 0x00;
    
    b3[5] = (int)self.slider1.value;
    b3[6] = (int)self.slider2.value;
    b3[7] = (int)self.slider3.value;
    
    b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
//    [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
    [self.dataArray addObject:data];
    NSLog(@"here");
}

- (void)fuckFun{
    if(self.dataArray.count > 0){
        NSData *data = [self.dataArray objectAtIndex:0];
        [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
        [self.dataArray removeObjectAtIndex:0];
        NSLog(@"123");
    }
}


@end

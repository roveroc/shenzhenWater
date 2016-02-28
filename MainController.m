//
//  MainController.m
//  FishDemo
//
//  Created by Rover on 26/8/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "MainController.h"
#import "UIWindow+YUBottomPoper.h"
#import "EditTimerController.h"
#import "ManualController.h"
#import "LightingModeController.h"
#import "CloudyModeController.h"

@interface MainController ()

@end

@implementation MainController
@synthesize onoffFlag;
@synthesize hud;
@synthesize btn1,btn2,btn3,btn4,btn5,btn6;
@synthesize runImg;
@synthesize hud1;
@synthesize windowLabel;

- (void)addRunningImageview:(CGRect)rect{
    if(self.runImg)
        [self.runImg removeFromSuperview];
    if(iPhone4){
        CGRect rr = CGRectMake(rect.origin.x, rect.origin.y - 25, rect.size.width, rect.size.height);
        self.runImg = [[UIImageView alloc] initWithFrame:rr];
    }
    else{
        CGRect rr = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        self.runImg = [[UIImageView alloc] initWithFrame:rr];
    }
    self.runImg.image = [UIImage imageNamed:@"running"];
    [self.view addSubview:self.runImg];
}

- (void)addRuningImgview{
    if(self.runImg)
        [self.runImg removeFromSuperview];
    if([RoverGlobal sharedInstance].isManualModel == YES){
        [self addRunningImageview:CGRectMake(87, 357, 15, 27)];
    }else if ([RoverGlobal sharedInstance].isLightingModel == YES){
        [self addRunningImageview:CGRectMake(193, 357, 15, 27)];
    }else if ([RoverGlobal sharedInstance].isCloudy == YES){
        [self addRunningImageview:CGRectMake(303, 357, 15, 27)];
    }
    [RoverGlobal sharedInstance].isManualModel = NO;
    [RoverGlobal sharedInstance].isLightingModel = NO;
    [RoverGlobal sharedInstance].isCloudy = NO;
}

- (void)showTabBar{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewWillAppear:(BOOL)animated{
    [self showTabBar];
    [self addRuningImgview];
}


#pragma mark - 读取设备状态
- (void)getDeviceStatus{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x06;
    b3[3] = 0x01;
    b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title= @"Home";
    self.navigationItem.title = @"Home";
    self.onoffFlag = NO;
    
    [RoverGlobal sharedInstance].selfIP = [[RoverGlobal sharedInstance] getSelfIPAddress];
    NSLog(@"本机IP --> %@",[RoverGlobal sharedInstance].selfIP);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Syn Time" style:UIBarButtonItemStyleDone target:self action:@selector(synchTime)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStyleDone target:self action:@selector(refreshStatus)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [RoverGlobal sharedInstance].lineArray = [[NSMutableArray alloc] init];
    [RoverGlobal sharedInstance].isManualModel = NO;
    [RoverGlobal sharedInstance].isLightingModel = NO;
    [RoverGlobal sharedInstance].isCloudy = NO;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:self.hud.dimBackground];
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self getDeviceStatus];
    [self performSelector:@selector(getDeviceStatusFinished) withObject:nil afterDelay:1.0];
    [self layOutView];
    
    [RoverGlobal sharedInstance].selfIP = [[RoverGlobal sharedInstance] getSelfIPAddress];
    [self addMessageLabel];
}

- (void)addMessageLabel{
    if([RoverGlobal sharedInstance].selfIP == nil ||
       ![[RoverGlobal sharedInstance].selfIP isEqualToString:WIFISSID]){
        if(self.windowLabel != nil)
            [self.windowLabel removeFromSuperview];
        self.windowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
        self.windowLabel.tag = 100;
        self.windowLabel.center = CGPointMake(self.view.frame.size.width/2, 74);
        self.windowLabel.text = @"Device OffLine";
        self.windowLabel.textAlignment = NSTextAlignmentCenter;
        self.windowLabel.textColor = [UIColor redColor];
        self.windowLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [[UIApplication sharedApplication].windows[0] addSubview:self.windowLabel];
    }
}


- (UIButton *)customButton:(UIButton *)btn rect:(CGRect)ret title:(NSString *)str{
    btn = [[UIButton alloc] initWithFrame:ret];
    btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackimg.png"] forState:UIControlStateNormal];
    return btn;
}

- (void)layOutView{
    if(iPhone4){
        self.btn1 = [self customButton:self.btn1 rect:CGRectMake(17, 353-25, 80, 35) title:@"Manual"];
        self.btn2 = [self customButton:self.btn2 rect:CGRectMake(122, 353-25, 80, 35) title:@"Lighting"];
        self.btn3 = [self customButton:self.btn3 rect:CGRectMake(233, 353-25, 80, 35) title:@"Cloudy"];
        self.btn4 = [self customButton:self.btn4 rect:CGRectMake(17, 408-25, 80, 35) title:@"Timer1"];
        self.btn5 = [self customButton:self.btn5 rect:CGRectMake(122, 408-25, 80, 35) title:@"Timer2"];
        self.btn6 = [self customButton:self.btn6 rect:CGRectMake(233, 408-25, 80, 35) title:@"Timer3"];
    }
    else{
        self.btn1 = [self customButton:self.btn1 rect:CGRectMake(17, 353, 80, 35) title:@"Manual"];
        self.btn2 = [self customButton:self.btn2 rect:CGRectMake(122, 353, 80, 35) title:@"Lighting"];
        self.btn3 = [self customButton:self.btn3 rect:CGRectMake(233, 353, 80, 35) title:@"Cloudy"];
        self.btn4 = [self customButton:self.btn4 rect:CGRectMake(17, 408, 80, 35) title:@"Timer1"];
        self.btn5 = [self customButton:self.btn5 rect:CGRectMake(122, 408, 80, 35) title:@"Timer2"];
        self.btn6 = [self customButton:self.btn6 rect:CGRectMake(233, 408, 80, 35) title:@"Timer3"];
    }
    
    [self.btn1 addTarget:self action:@selector(btn1Clciked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(btn2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn3 addTarget:self action:@selector(btn3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn4 addTarget:self action:@selector(btn4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn5 addTarget:self action:@selector(btn5Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn6 addTarget:self action:@selector(btn6Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
    [self.view addSubview:btn6];
}

- (void)refreshStatus{
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:WAITTIME];
    [self getDeviceStatus];
    [self performSelector:@selector(getDeviceStatusFinished) withObject:nil afterDelay:1.0];
}


#pragma mark - 一秒后默认设备状态读取完毕
- (void)getDeviceStatusFinished{
    if([RoverGlobal sharedInstance].isSuccess == YES){
        if([RoverGlobal sharedInstance].switchStatus == 0x00){
            self.onoffFlag = NO;
            [RoverGlobal sharedInstance].isClosed = YES;
            [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_close@3x.png"] forState:UIControlStateNormal];
        }
        else{
            [RoverGlobal sharedInstance].isClosed = NO;
            self.onoffFlag = YES;
            [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_open@3x.png"] forState:UIControlStateNormal];
        }
        NSString *hStr;
        if([RoverGlobal sharedInstance].hourStatus < 10){
            hStr = [NSString stringWithFormat:@"0%d",[RoverGlobal sharedInstance].hourStatus];
        }else{
            hStr = [NSString stringWithFormat:@"%d",[RoverGlobal sharedInstance].hourStatus];
        }
        NSString *mStr;
        if([RoverGlobal sharedInstance].minuteStatus < 10){
            mStr = [NSString stringWithFormat:@"0%d",[RoverGlobal sharedInstance].minuteStatus];
        }else{
            mStr = [NSString stringWithFormat:@"%d",[RoverGlobal sharedInstance].minuteStatus];
        }
        NSString *timeStr = [NSString stringWithFormat:@"%@:%@",hStr,mStr];
        self.timeLabel.text = timeStr;
        
        if([RoverGlobal sharedInstance].modelStatus == 0x01){
            [self addRunningImageview:CGRectMake(87, 357, 15, 27)];
        }
        else if ([RoverGlobal sharedInstance].modelStatus == 0x02){
            [self addRunningImageview:CGRectMake(193, 357, 15, 27)];
        }
        else if ([RoverGlobal sharedInstance].modelStatus == 0x03){
            [self addRunningImageview:CGRectMake(303, 357, 15, 27)];
        }
        else if ([RoverGlobal sharedInstance].modelStatus == 0x04){
            [self addRunningImageview:CGRectMake(87, 412, 15, 27)];
        }
        else if ([RoverGlobal sharedInstance].modelStatus == 0x05){
            [self addRunningImageview:CGRectMake(193, 412, 15, 27)];
        }
        else if ([RoverGlobal sharedInstance].modelStatus == 0x06){
            [self addRunningImageview:CGRectMake(293, 412, 15, 27)];
        }
    }
    else{
        NSLog(@"状态读取失败");
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Failed";
        [self.hud hide:YES afterDelay:0.8];
    }
}


#pragma mark - 同步时间
- (void)synchTime{
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:WAITTIME];
    NSLog(@"同步时间");
    NSDateFormatter *dateFormatter1 =[[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY"];
    int yearstr = [[dateFormatter1 stringFromDate:[NSDate date]] intValue];
    Byte bb[3] = {0,0,0};
    int i = 0;
    while (yearstr>15) {
        bb[i] = yearstr%16;
        yearstr = yearstr/16;
        i++;
    }
//    bb[i] = yearstr;
//    Byte yearbb2 = bb[2];
//    Byte yearbb1 = bb[1]*16+bb[0];
//    
//    NSDateFormatter *dateFormatter2 =[[NSDateFormatter alloc] init];
//    [dateFormatter2 setDateFormat:@"MM"];
//    int monstr = [[dateFormatter2 stringFromDate:[NSDate date]] intValue];
//    Byte monbb = monstr;
//    
//    NSDateFormatter *dateFormatter3 =[[NSDateFormatter alloc] init];
//    [dateFormatter3 setDateFormat:@"dd"];
//    int ddstr = [[dateFormatter3 stringFromDate:[NSDate date]] intValue];
//    Byte ddbb = ddstr;
    
    NSDateFormatter *dateFormatter4 =[[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"HH"];
    int hhstr = [[dateFormatter4 stringFromDate:[NSDate date]] intValue];
    Byte hhbb = hhstr;
    
    NSDateFormatter *dateFormatter5 =[[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"mm"];
    int mmstr = [[dateFormatter5 stringFromDate:[NSDate date]] intValue];
    Byte mmbb = mmstr;
    
    NSDateFormatter *dateFormatter6 =[[NSDateFormatter alloc] init];
    [dateFormatter6 setDateFormat:@"ss"];
    int ssstr = [[dateFormatter6 stringFromDate:[NSDate date]] intValue];
    Byte ssbb = ssstr;
    
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x02;
    b3[3] = 0x01;
    b3[4] = 0x00;
    
    b3[5] = hhbb;
    b3[6] = mmbb;
    b3[7] = ssbb;
    
    b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
    
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btn1Clciked:(id)sender {
    ManualController *manual = [[ManualController alloc] init];
    [self.navigationController pushViewController:manual animated:YES];
}

- (void)btn2Clicked:(id)sender {
    LightingModeController *light = [[LightingModeController alloc] init];
    light.modeFlag = 1;
    [self.navigationController pushViewController:light animated:YES];
}

- (void)btn3Clicked:(id)sender {
    LightingModeController *light = [[LightingModeController alloc] init];
    light.modeFlag = 2;
    [self.navigationController pushViewController:light animated:YES];
}

- (void)btn4Clicked:(id)sender {
    [self.view.window  showPopWithButtonTitles:@[@"Change to Timer1",@"Edit Timer1"] styles:@[YUDangerStyle,YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        if(index == 0){
            [RoverGlobal sharedInstance].isSuccess = NO;
            [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.dimBackground = YES;
            [self.hud hide:YES afterDelay:self.hud.dimBackground];
            Byte b3[64];
            for(int k=0;k<64;k++){
                b3[k] = 0x00;
            }
            b3[0] = 0x55;
            b3[1] = 0xAA;
            b3[2] = 0x08;
            b3[3] = 0x01;
            b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
            NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
            [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
            
            [self addRunningImageview:CGRectMake(87, 357, 15, 27)];
            
        }
        else if(index == 1){
            EditTimerController *editCon = [[EditTimerController alloc] init];
            editCon.fileName = @"timerData1";
            editCon.navTitle = @"Edit Timer1";
            [RoverGlobal sharedInstance].timerNumber = 1;
            [self.navigationController pushViewController:editCon animated:YES];
        }
    }];
}

- (void)btn5Clicked:(id)sender {
    [self.view.window  showPopWithButtonTitles:@[@"Change to Timer2",@"Edit Timer2"] styles:@[YUDangerStyle,YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        if(index == 0){
            [RoverGlobal sharedInstance].isSuccess = NO;
            [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.dimBackground = YES;
            [self.hud hide:YES afterDelay:self.hud.dimBackground];
            Byte b3[64];
            for(int k=0;k<64;k++){
                b3[k] = 0x00;
            }
            b3[0] = 0x55;
            b3[1] = 0xAA;
            b3[2] = 0x08;
            b3[3] = 0x02;
            b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
            NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
            [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
            
            [self addRunningImageview:CGRectMake(193, 357, 15, 27)];
        }
        else if(index == 1){
            EditTimerController *editCon = [[EditTimerController alloc] init];
            editCon.navTitle = @"Edit Timer2";
            editCon.fileName = @"timerData2";
            [RoverGlobal sharedInstance].timerNumber = 2;
            [self.navigationController pushViewController:editCon animated:YES];
        }
    }];
}

- (void)btn6Clicked:(id)sender {
    [self.view.window  showPopWithButtonTitles:@[@"Change to Timer3",@"Edit Timer3"] styles:@[YUDangerStyle,YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        if(index == 0){
            [RoverGlobal sharedInstance].isSuccess = NO;
            [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.dimBackground = YES;
            [self.hud hide:YES afterDelay:self.hud.dimBackground];
            Byte b3[64];
            for(int k=0;k<64;k++){
                b3[k] = 0x00;
            }
            b3[0] = 0x55;
            b3[1] = 0xAA;
            b3[2] = 0x08;
            b3[3] = 0x03;
            b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
            NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
            [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
            
            [self addRunningImageview:CGRectMake(303, 357, 15, 27)];
        }
        else if(index == 1){
            EditTimerController *editCon = [[EditTimerController alloc] init];
            editCon.navTitle = @"Edit Timer3";
            editCon.fileName = @"timerData3";
            [RoverGlobal sharedInstance].timerNumber = 3;
            [self.navigationController pushViewController:editCon animated:YES];
        }
    }];
}

- (IBAction)switchBtnClicked:(id)sender {
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:WAITTIME];
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x04;
    b3[3] = 0x01;
    
    b3[4] = 0x00;
    
    if(self.onoffFlag == NO){
        [self performSelector:@selector(roverTurnOn) withObject:nil afterDelay:1.1];
        b3[5] = 0x01;
    }else{
        [self performSelector:@selector(roverTurnOff) withObject:nil afterDelay:1.1];
        b3[5] = 0x00;
    }
    b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}

- (void)roverTurnOn{
    if([RoverGlobal sharedInstance].isSuccess == YES){
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_open@3x.png"] forState:UIControlStateNormal];
        self.onoffFlag = YES;
    }
}

- (void)roverTurnOff{
    if([RoverGlobal sharedInstance].isSuccess == YES){
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"air_purifier_light_close@3x.png"] forState:UIControlStateNormal];
        self.onoffFlag = NO;

    }
}


- (void)confirmSuccess{
    if([RoverGlobal sharedInstance].isSuccess == NO){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Failed";
        [self.hud hide:YES afterDelay:0.8];
    }
}


@end

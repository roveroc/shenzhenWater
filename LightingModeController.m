//
//  LightingModeController.m
//  FishDemo
//
//  Created by Rover on 14/9/15.
//  Copyright (c) 2015年 Rover. All rights reserved.
//

#import "LightingModeController.h"

@interface LightingModeController ()

@end

@implementation LightingModeController
@synthesize modeFlag;
@synthesize percent,sTime,eTime,sswitch;
@synthesize editFlag;
@synthesize runingValue;
@synthesize hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveDataAndBack)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[RoverGlobal sharedInstance] hideTabBar:self];
    self.editFlag = YES; //YES:编辑开始时间   NO:编辑结束时间
    
    [self.endBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
    [self.datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    
    [self.switch1 setOn:NO animated:NO];
    self.runingValue = 0;
    
    if(self.modeFlag == 1){  //闪电
        self.navigationItem.title = @"Lighting";
        self.weakLabel.text = @"weak";
        self.strongLabel.text = @"strong";
        
        self.slider.value =  (int)([[UserDefault sharedInstance].light_precent intValue]);
        self.valueLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.slider.value];
        [self.startBtn setTitle:[NSString stringWithFormat:@"Edit start point>%@",[UserDefault sharedInstance].light_sTime] forState:UIControlStateNormal];
        [self.endBtn   setTitle:[NSString stringWithFormat:@"Edit end point>%@",[UserDefault sharedInstance].light_eTime] forState:UIControlStateNormal];
        self.sTime = [UserDefault sharedInstance].light_sTime;
        self.eTime = [UserDefault sharedInstance].light_eTime;
        int v = [[UserDefault sharedInstance].light_switch intValue];
        if(v == 0){
            [self.switch2 setOn:NO animated:NO];
        }else{
            [self.switch2 setOn:YES animated:NO];
        }
        self.sswitch = v;
        int tv = [[[UserDefault sharedInstance].light_sTime componentsSeparatedByString:@":"][0] intValue]*60*60 +
                 [[[UserDefault sharedInstance].light_sTime componentsSeparatedByString:@":"][1] intValue]*60;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.datePicker setCountDownDuration:tv];
        });
    }else if(self.modeFlag == 2){  //多云
        self.navigationItem.title = @"Cloudy";
        self.weakLabel.text = @"slow";
        self.strongLabel.text = @"fast";
        
        self.slider.value =  (int)([[UserDefault sharedInstance].cloudy_precent intValue]);
        self.valueLabel.text = [NSString stringWithFormat:@"%d%%",(int)self.slider.value];
        [self.startBtn setTitle:[NSString stringWithFormat:@"Edit start point>%@",[UserDefault sharedInstance].cloudy_sTime] forState:UIControlStateNormal];
        [self.endBtn   setTitle:[NSString stringWithFormat:@"Edit end point>%@",[UserDefault sharedInstance].cloudy_eTime] forState:UIControlStateNormal];
        self.sTime = [UserDefault sharedInstance].cloudy_sTime;
        self.eTime = [UserDefault sharedInstance].cloudy_eTime;
        int v = [[UserDefault sharedInstance].cloudy_switch intValue];
        if(v == 0){
            [self.switch2 setOn:NO animated:NO];
        }else{
            [self.switch2 setOn:YES animated:NO];
        }
        self.sswitch = v;
        int tv = [[[UserDefault sharedInstance].cloudy_sTime componentsSeparatedByString:@":"][0] intValue]*60*60 +
                 [[[UserDefault sharedInstance].cloudy_sTime componentsSeparatedByString:@":"][1] intValue]*60;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.datePicker setCountDownDuration:tv];
        });
    }
    self.percent = (int)self.slider.value;
}

- (void)SaveDataAndBack{
    [self SaveData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 保存数据
- (void)SaveData{
    if(self.modeFlag == 1){         //保存闪电模式
        [UserDefault sharedInstance].light_precent = [NSString stringWithFormat:@"%d",self.percent];
        [UserDefault sharedInstance].light_sTime = self.sTime;
        [UserDefault sharedInstance].light_eTime = self.eTime;
        [UserDefault sharedInstance].light_switch = [NSString stringWithFormat:@"%d",self.sswitch];
    }else if(self.modeFlag == 2){   //保存多云模式
        [UserDefault sharedInstance].cloudy_precent = [NSString stringWithFormat:@"%d",self.percent];
        [UserDefault sharedInstance].cloudy_sTime = self.sTime;
        [UserDefault sharedInstance].cloudy_eTime = self.eTime;
        [UserDefault sharedInstance].cloudy_switch = [NSString stringWithFormat:@"%d",self.sswitch];
    }
    [self buildDataStruct];
}


#pragma 改变时间
- (void)dateChange:(UIDatePicker *)sender{
    NSString *time = [[self dateToString:sender.date] componentsSeparatedByString:@" "][1];
    if(self.editFlag == YES){
        int sValue = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        int eValue = [[self.eTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.eTime componentsSeparatedByString:@":"][1] intValue]*60;
        if(sValue > eValue){
            int vv = [[self.sTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.sTime componentsSeparatedByString:@":"][1] intValue]*60;
            [self.datePicker setCountDownDuration:vv];
        }
        else{
            [self.startBtn setTitle:[NSString stringWithFormat:@"点击编辑开始点>%@",time] forState:UIControlStateNormal];
            self.sTime = time;
        }
    }
    else{
        int sValue = [[time componentsSeparatedByString:@":"][0] intValue]*60*60 + [[time componentsSeparatedByString:@":"][1] intValue]*60;
        int eValue = [[self.sTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.sTime componentsSeparatedByString:@":"][1] intValue]*60;
        if(sValue < eValue){
            int vv = [[self.eTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.eTime componentsSeparatedByString:@":"][1] intValue]*60;
            [self.datePicker setCountDownDuration:vv];
        }
        else{
            [self.endBtn setTitle:[NSString stringWithFormat:@"点击编辑开始点>%@",time] forState:UIControlStateNormal];
            self.eTime = time;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 将NSDate转化成字符串
- (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}

#pragma mark - 讲String转换为NSDate
- (NSDate *)stringToDate:(NSString *)string{
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate *date =[dateFormat1 dateFromString:string];
    return date;
}


- (IBAction)startBtnClicked:(id)sender {
    [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.endBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.editFlag = YES;
    int tv = [[self.sTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.sTime componentsSeparatedByString:@":"][1] intValue]*60;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.datePicker setCountDownDuration:tv];
    });
}

- (IBAction)endBtnClicked:(id)sender {
    [self.startBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editFlag = NO;
    int tv = [[self.eTime componentsSeparatedByString:@":"][0] intValue]*60*60 + [[self.eTime componentsSeparatedByString:@":"][1] intValue]*60;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.datePicker setCountDownDuration:tv];
    });
}

- (IBAction)sliderValueChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.valueLabel.text = [NSString stringWithFormat:@"%d%%",(int)slider.value];
    self.percent = (int)slider.value;
}

- (IBAction)switch1StatusChange:(id)sender {
    UISwitch *swi = (UISwitch *)sender;
    if(swi.isOn == NO){
        self.runingValue = 0;
    }else{
        self.runingValue = 1;
    }
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:WAITTIME];
    [self SaveData];
    [self buildDataStruct];
}

- (IBAction)switch2StatusChange:(id)sender {
    UISwitch *swi = (UISwitch *)sender;
    if(swi.isOn == NO){
        self.sswitch = 0;
    }else{
        self.sswitch = 1;
    }
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self performSelector:@selector(confirmSuccess) withObject:nil afterDelay:1.0];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    [self.hud hide:YES afterDelay:WAITTIME];
    [self SaveData];
    [self buildDataStruct];
}

- (void)confirmSuccess{
    if([RoverGlobal sharedInstance].isSuccess == NO){
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        [self.view addSubview:self.hud];
        self.hud.labelText = @"Failed";
        [self.hud hide:YES afterDelay:0.8];
    }
}

#pragma mark - 组织将要发送的数据
- (void)buildDataStruct{
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x05;
    b3[4] = 0x00;
    if(self.modeFlag == 1){
        b3[3] = 0x00;         //闪电
        NSArray *sArr = [[UserDefault sharedInstance].light_sTime componentsSeparatedByString:@":"];  //开始时间
        int shhstr = [sArr[0] intValue];
        Byte shhbb = shhstr;
        b3[5] = shhbb;
        int smmstr = [sArr[1] intValue];
        Byte smmbb = smmstr;
        b3[6] = smmbb;
        
        NSArray *eArr = [[UserDefault sharedInstance].light_eTime componentsSeparatedByString:@":"];  //结束时间
        int ehhstr = [eArr[0] intValue];
        Byte ehhbb = ehhstr;
        b3[7] = ehhbb;
        int emmstr = [eArr[1] intValue];
        Byte emmbb = emmstr;
        b3[8] = emmbb;
        
        int pValue = [[UserDefault sharedInstance].light_precent intValue];   //百分比
        Byte pbb = pValue;
        b3[9] = pbb;
        
        Byte runbb = self.runingValue;            //立即运行，看效果
        b3[10] = runbb;
        
        Byte openbb = self.sswitch;     //打开(关闭)
        b3[11] = openbb;
        
        [RoverGlobal sharedInstance].isLightingModel = YES;
        
    }else if(self.modeFlag == 2){
        b3[3] = 0x01;           //多云
        NSArray *sArr = [[UserDefault sharedInstance].cloudy_sTime componentsSeparatedByString:@":"];  //开始时间
        int shhstr = [sArr[0] intValue];
        Byte shhbb = shhstr;
        b3[5] = shhbb;
        int smmstr = [sArr[1] intValue];
        Byte smmbb = smmstr;
        b3[6] = smmbb;
        
        NSArray *eArr = [[UserDefault sharedInstance].cloudy_eTime componentsSeparatedByString:@":"];  //结束时间
        int ehhstr = [eArr[0] intValue];
        Byte ehhbb = ehhstr;
        b3[7] = ehhbb;
        int emmstr = [eArr[1] intValue];
        Byte emmbb = emmstr;
        b3[8] = emmbb;
        
        int pValue = [[UserDefault sharedInstance].cloudy_precent intValue];   //百分比
        Byte pbb = pValue;
        b3[9] = pbb;
        
        Byte runbb = self.runingValue;            //立即运行，看效果
        b3[10] = runbb;
        
        Byte openbb = self.sswitch;     //打开(关闭)
        b3[11] = openbb;
        
        [RoverGlobal sharedInstance].isCloudy = YES;
    }
    b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
}


@end

//
//  DeviceMannagerController.m
//  FishDemo
//
//  Created by rover on 16/3/5.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import "DeviceMannagerController.h"

@interface DeviceMannagerController ()

@end

@implementation DeviceMannagerController
@synthesize nameStr;
@synthesize ssidStr;
@synthesize pwdStr;
@synthesize selectIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Search";
    //假数据
    Global.deviceNameArray = [[NSMutableArray alloc] initWithObjects:@"D1",@"D2",@"D3",@"D1",@"D2",@"D3", nil];
    Global.deviceMACArray = [[NSMutableArray alloc] initWithObjects:@"a",@"b",@"c",@"d",@"e",@"f", nil];
    //点击继续搜索
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(searchDevice)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.deviceTable.delegate = self;
    self.deviceTable.dataSource = self;
    
    self.deviceNameFeild.delegate = self;
    self.ssidFeild.delegate = self;
    self.pwdFeild.delegate = self;
//    self.deviceNameFeild.returnKeyType =
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.selectIndex = -1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)keyboardHide{
    [self.backGroundView setCenter:CGPointMake(160, 240)];
    [self.deviceNameFeild resignFirstResponder];
    [self.ssidFeild resignFirstResponder];
    [self.pwdFeild resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Global.deviceMACArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * showUserInfoCellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:showUserInfoCellIdentifier];
    }
    
    cell.textLabel.text = [Global.deviceNameArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [Global.deviceMACArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = (int)indexPath.row;
    self.deviceNameFeild.placeholder = [Global.deviceNameArray objectAtIndex:indexPath.row];
    
}


#pragma mark -------------------------- 搜索设备 --> 发送账号
- (void)searchDevice{
    [RoverGlobal sharedInstance].isSuccess = NO;
    [self performSelector:@selector(confirmSSIDSuccess) withObject:nil afterDelay:1.0];
    Byte b3[64];
    for(int k=0;k<64;k++){
        b3[k] = 0x00;
    }
    b3[0] = 0x55;
    b3[1] = 0xAA;
    b3[2] = 0x18;
    b3[3] = 0x01;
    b3[4] = 0x00;
    
    NSString * ssid = @"AwiseTechnology";
    NSData * ssidData = [ssid dataUsingEncoding:NSASCIIStringEncoding];
    Byte *ssidBtye = (Byte *)[ssidData bytes];
    
    for(int i=0;i<ssidData.length ;i++){
        b3[i+5] = ssidBtye[i];
    }
    b3[37] = 0x02;
    b3[38] = 0x01;
    b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
    NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
    [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];

}

#pragma mark -------------------------- 搜索设备 --> 发送账号成功后发送密码
- (void)confirmSSIDSuccess{
//    if([RoverGlobal sharedInstance].isSuccess == YES)
    {
        [RoverGlobal sharedInstance].isSuccess = NO;
        [self performSelector:@selector(confirmPASSWORDSuccess) withObject:nil afterDelay:1.0];
        Byte b3[64];
        for(int k=0;k<64;k++){
            b3[k] = 0x00;
        }
        b3[0] = 0x55;
        b3[1] = 0xAA;
        b3[2] = 0x18;
        b3[3] = 0x02;
        b3[4] = 0x00;
        
        NSString * password = @"Awise2015@";
        NSData * passwordData = [password dataUsingEncoding:NSASCIIStringEncoding];
        Byte *ssidBtye = (Byte *)[passwordData bytes];
        
        for(int i=0;i<passwordData.length ;i++){
            b3[i+5] = ssidBtye[i];
        }
        b3[63] = [[RoverGlobal sharedInstance] getChecksum:b3];
        NSData *data = [[NSData alloc] initWithBytes:b3 length:64];
        [[RoverGlobal sharedInstance] sendDataToDevice:BroadCast order:data tag:0];
    }
}

- (void)confirmPASSWORDSuccess{
    if([RoverGlobal sharedInstance].isSuccess == YES){
        NSLog(@"发送成功");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)editNameFun:(id)sender {
    [self.backGroundView setCenter:CGPointMake(160, 150)];
}

- (IBAction)editSSIDFun:(id)sender {
    [self.backGroundView setCenter:CGPointMake(160, 150)];
}

- (IBAction)editPWDFun:(id)sender {
    [self.backGroundView setCenter:CGPointMake(160, 150)];
}
@end

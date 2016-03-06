//
//  DeviceMannagerController.h
//  FishDemo
//
//  Created by rover on 16/3/5.
//  Copyright © 2016年 Rover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoverGlobal.h"

@interface DeviceMannagerController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSString                *nameStr;
    NSString                *ssidStr;
    NSString                *pwdStr;
    int                     selectIndex;
}
@property (nonatomic, retain) NSString          *nameStr;
@property (nonatomic, retain) NSString          *ssidStr;
@property (nonatomic, retain) NSString          *pwdStr;
@property (assign)            int               selectIndex;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UITableView *deviceTable;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameFeild;
@property (weak, nonatomic) IBOutlet UITextField *ssidFeild;
@property (weak, nonatomic) IBOutlet UITextField *pwdFeild;



- (IBAction)editNameFun:(id)sender;
- (IBAction)editSSIDFun:(id)sender;
- (IBAction)editPWDFun:(id)sender;




@end
